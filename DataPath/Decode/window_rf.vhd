----------------------------------------------------------------------------------
-- Create Date: 16.08.2021
-- Module Name: window_RF
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

-- ASSUMPTIONS:
-- No more than a single level of filling and spilling happens

entity window_rf is
    generic(M : integer := 4;    --number if global regs
            N : integer := 4;    --number of IN/LOCAL/OUT regs
            F : integer := 4;    -- number of windows
            NBIT: integer := 32);  
    Port ( CLK:    IN std_logic;
           RESET:  IN std_logic;
           ENABLE: IN std_logic;
           RD1:    IN std_logic;
           RD2:    IN std_logic;
           WR:     IN std_logic;
           WR_ADD : IN std_logic_vector(integer(log2(real(N*3+M))) downto 0); --
           RD1_ADD: IN std_logic_vector(integer(log2(real(N*3+M))) downto 0);
           RD2_ADD: IN std_logic_vector(integer(log2(real(N*3+M))) downto 0);
           --additional signals
           FILL:  OUT std_logic;
           SPILL: OUT std_logic;
           CALL:  IN  std_logic;
           RET:   IN  std_logic;
           --BUS
           MEM_IN:  IN  std_logic_vector(NBIT-1 downto 0); --BUS for memory connection
           MEM_OUT: OUT std_logic_vector(NBIT-1 downto 0);
           --I/O
           DATAIN: IN  std_logic_vector(NBIT-1 downto 0);
           OUT1:   OUT std_logic_vector(NBIT-1 downto 0);
           OUT2:   OUT std_logic_vector(NBIT-1 downto 0));
end window_rf;


architecture Behavioral of window_rf is
    constant nreg: integer := (((F*2)+1)*N)+M; -- total number of registers inside the RF
    constant add_bit: integer := integer(ceil(log2(real(nreg)))); --number of actual address bits
    --registers
    subtype REG_ADDR is natural range 0 to nreg-1;
    type REG_ARRAY is array (REG_ADDR) of std_logic_vector(NBIT-1 downto 0);
    signal REGISTERS : REG_ARRAY;
    --additional signals
    signal CWP, SWP : integer := m; -- initialised to m because global registers are in the beginning of the RF
    signal fspill: std_logic := '0'; -- flag to know if at least one spill happened
    --signals for address convertion
    signal ADD_RD1, ADD_RD2, ADD_WR: std_logic_vector(integer(ceil(log2(real(nreg)))) -1 downto 0);

begin
    
    --conversion from virtual to physical address considering m at the
    --beginning of RF
    ADD_RD1 <= std_logic_vector(to_unsigned(cwp + to_integer(unsigned(RD1_ADD) -m ), add_bit)) when (to_integer(unsigned(RD1_ADD)) >= m) else std_logic_vector(resize(unsigned(RD1_ADD), add_bit));
    ADD_RD2 <= std_logic_vector(to_unsigned(cwp + to_integer(unsigned(RD2_ADD) -m ), add_bit)) when (to_integer(unsigned(RD2_ADD)) >= m) else std_logic_vector(resize(unsigned(RD2_ADD), add_bit));
    ADD_WR  <= std_logic_vector(to_unsigned(cwp + to_integer(unsigned( WR_ADD) -m ), add_bit)) when (to_integer(unsigned (WR_ADD)) >= m) else std_logic_vector(resize(unsigned (WR_ADD), add_bit));

    MEM_OUT <= (others => 'Z'); --set to high impedance
    
    process(CLK)
      
    variable cansave : integer := 1; --flag to understand if you can save a new window
    variable canrestore : integer := 0; --flag to understand if you can go back to the father window
    --variable fill_s: integer := 0; -- signal i rise when i do the fill
   -- variable spill_s: integer := 0; -- signal i rise when i do the spill
    
    begin        
        if(CLK = '1' and clk'event) then
           if(ENABLE = '1') then
              if(RESET = '1') then
                 REGISTERS <=(others => (others => '0'));
                 cwp <= m;
                 if(RD1 = '1') then
                   OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
                 end if;
                 if(RD2 = '1') then
                   OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
                 end if;
                 --else no reset do other cases
              elsif(RD1='1' and RD2='0' and WR='0') then --read first address
                 OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
              elsif(RD1='0' and RD2='1' and WR='0') then --read second address
                 OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
              elsif(RD1='1' and RD2='1' and WR='0') then --read both address
                 OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
                 OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
              elsif(RD1='0' and RD2='0' and WR='1') then --write at that address
                 REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
              elsif(RD1='1' and RD2='0' and WR='1') then --write and read first address

                if(ADD_RD1 /= ADD_WR) then 
                   REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
                   OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
                else --if address are the same, forward to OUT1 directly
                  REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
                   OUT1 <= DATAIN;
                end if;
                
              elsif(RD1='0' and RD2='1' and WR='1') then
                if(ADD_RD2 /= ADD_WR) then
                   REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
                   OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
                 else --if address are the same, forward to OUT2 directly
                   REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
                   OUT2 <= DATAIN;
                 end if;
                 
              elsif(RD1='1' and RD2='1' and WR='1') then --both writing and reading and forwarding to OUT if address are all the same
                REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
                
                if(ADD_RD1 /= ADD_WR) then
                   OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
                else
                  OUT1 <= DATAIN;
                end if;
                
                if(ADD_RD2 /= ADD_WR) then
                   OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
                else
                  OUT2 <= DATAIN;
              end if;
             end if;
              
            --management windows              
            if (CALL = '1' and fspill = '0') then   -- call first subroutine
              canrestore := 1;
              
              -- check if i have space for another window
                if (cwp >= (nreg - (3*n))) then  
                  cansave := 0; -- i can't save anymore i have to spill
                else
                    cansave := 1;
                end if;
              
              if (cansave = 1) then -- check if i can save (if i have free window)
                cwp <= cwp + (2*N); --move cwp to the next window
 
                -- if i don't have space for a new window
              else -- first spill
                SPILL <= '1'; --i have to rise the spill signal
                fspill <= '1'; -- spill flag set to 1
                for i in 0 to ((3*n)-1) loop -- OUTPUT to main memory
                  MEM_OUT <= REGISTERS(swp + i);
                end loop;
                --copy the out section of the previous window to the in section
                --of the new  window (the spilled one)
                for i in 0 to n-1 loop 
                  REGISTERS(swp+i) <= REGISTERS(cwp + (2*n)+i); 
                end loop;
                swp <= m;
                cwp <= m;
                SPILL <= '0';
              end if;               
            -- after the first spill  
            elsif (CALL = '1'  and fspill = '1') then -- i had a spill 
              SPILL <= '1';
              canrestore := 1; 
               for i in 0 to (2*n)-1 loop -- spill in memory 
                  MEM_OUT <= REGISTERS(swp + i);
               end loop;
              -- change window
               swp <= swp + (2*N);
               cwp <= cwp + (2*N);
               SPILL <= '0';
            end if;
            -- no spills and return subroutine (return to the parent)
            if (RET = '1'  and fspill = '0') then
              FILL <= '1';
              if (cwp = m) then
                  canrestore := 0;
                end if;
              if (canrestore = 1) then
                cwp <= cwp - (2*N);
              FILL <= '0';
            end if;
           end if;
            -- fill and return to the parent
            if (RET = '1'  and fspill = '1') then
              FILL <= '1';
              if (cwp = m) then -- last fill 
                for i in 3*n downto 0 loop
                  REGISTERS(swp+i) <= MEM_IN;
                end loop;
                fspill <= '0';
                FILL <= '0';
                cwp <= (n * 2 * (f-1)) + m;
              elsif( cwp > m ) then
                 for i in 3*n downto 0 loop
                  REGISTERS(swp+i) <= MEM_IN;
                 end loop;
               FILL <= '0';
               swp <= swp - (2*n);
               cwp <= cwp - (2*n);
               end if;
          end if;
        end if;
      end if;
    end process;
     
end Behavioral;
