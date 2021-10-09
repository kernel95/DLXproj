library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.myTypes.all;

entity TB_CU_Wrapper is
--  Port ( );
end TB_CU_Wrapper;

architecture Behavioral of TB_CU_Wrapper is

component CU_wrapper 
  Port (--INPUT
        clock, reset: in std_logic;
        OPCODE: in std_logic_vector(OP_CODE_SIZE - 1 downto 0);
        FUNC  : in std_logic_vector(FUNC_SIZE - 1 downto 0);
        EqualD: in std_logic;
        FlushE: in std_logic;
        --OUTPUT
        
        --DECODE
        PC_SrcD :   out std_logic;
        Select_ext: out std_logic;
        IsJal:      out std_logic;
        RD1:        out std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
        RD2:        out std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH 
        Comp_control: out std_logic_vector(1 downto 0); -- control which branch to compute
            
        --EXECUTE
        ALUcontrolE: OUT std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU
        RegDestE:    OUT std_logic; --select first mux of execute stage
        ALUSrcE:     OUT std_logic; --select second mux of execute stage
           
        --MEMORY
        MemWriteM: out std_logic;
            
        --WB
        RegWriteW: out std_logic;
        MemToRegW: out std_logic;
            
        --TO HAZARD UNIT            FOR THE WRAPPER
        BranchD_H:   OUT std_logic; 
        MemToRegE_H: OUT std_logic;
        RegWriteE_H: OUT std_logic;
        MemToRegM_H: OUT std_logic;
        RegWriteM_H: OUT std_logic;
        RegWriteW_H: OUT std_logic;
        -- FOR RF      
        CALL, RET:   OUT std_logic;
        FILL, SPILL: IN std_logic);
end component;

--TB SIGNALS
signal clock_s, reset_s: std_logic;
signal OPCODE_s: std_logic_vector(OP_CODE_SIZE - 1 downto 0);
signal FUNC_s  : std_logic_vector(FUNC_SIZE - 1 downto 0);
signal EqualD_s: std_logic;
signal FlushE_s: std_logic;     
--DECODE
signal PC_SrcD_s :     std_logic;
signal Select_ext_s:   std_logic;
signal IsJal_s:        std_logic;
signal RD1_s:          std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
signal RD2_s:          std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH 
signal Comp_control_s: std_logic_vector(1 downto 0); -- control which branch to compute
--EXECUTE
signal ALUcontrolE_s:  std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU
signal RegDestE_s:     std_logic; --select first mux of execute stage
signal ALUSrcE_s:      std_logic; --select second mux of execute stage
 --MEMORY
signal MemWriteM_s:    std_logic;
--WB
signal RegWriteW_s:    std_logic;
signal MemToRegW_s:    std_logic;
--TO HAZARD UNIT 
signal BranchD_H_s:    std_logic; 
signal MemToRegE_H_s:  std_logic;
signal RegWriteE_H_s:  std_logic;
signal MemToRegM_H_s:  std_logic;
signal RegWriteM_H_s:  std_logic;
signal RegWriteW_H_s:  std_logic;
--FOR RF          
signal CALL_s, RET_s:   std_logic;
signal FILL_s, SPILL_s: std_logic;

signal OPCODE_addr: std_logic_vector(OP_CODE_SIZE - 1 downto 0);
signal FUNC_addr  : std_logic_vector(FUNC_SIZE - 1 downto 0);

begin

DUT : CU_wrapper port map (clock_s, reset_s, OPCODE_s, FUNC_s, EqualD_s, FlushE_s,
                           PC_SrcD_s, Select_ext_s, IsJal_s, RD1_s, RD2_s, Comp_control_s,
                           ALUcontrolE_s, RegDestE_s, ALUSrcE_s, MemWriteM_s, RegWriteW_s,
                           MemToRegW_s, BranchD_H_s, MemToRegE_H_s, RegWriteE_H_s, MemToRegM_H_s,
                           RegWriteM_H_s, RegWriteW_H_s, CALL_s, RET_s, FILL_s, SPILL_s);
                           
ClkProc:process
begin

    clock_s <= '1';
    wait for 5 ns;
    clock_s <= '0';
    wait for 5 ns;
    
end process ClkProc;

VectProc:process
begin

reset_s <= '1';
OPCODE_addr <= (others => '0');
FUNC_addr   <= (others => '0');
OPCODE_s    <= (others => '0');
FUNC_s      <= (others => '0');
EqualD_s    <= '0';
FlushE_s    <= '0';

wait for 5 ns;

reset_s <= '0';

wait for 5 ns;

for i in 0 to 89 loop
    
    FUNC_addr <= std_logic_vector(unsigned(FUNC_addr) + 1);
    FUNC_s <= FUNC_addr;
    
    if( i > 45 ) then
       FUNC_addr   <= (others => '0');
       FUNC_s <= FUNC_addr;
       OPCODE_addr <= std_logic_vector(unsigned(OPCODE_addr) + 1);
       OPCODE_s <= OPCODE_addr;
    end if;
    wait for 10 ns;
    end loop;
    
    wait for 5 ns;
    wait for 5 ns;
    wait for 5 ns;
wait;
end process;

end Behavioral;
