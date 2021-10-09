library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.myTypes.all;

entity TB_CU is
--  Port ( );
end TB_CU;

architecture Behavioral of TB_CU is

component cu
       port (-- INPUTS
                            
              --Clk : in std_logic;
              Rst : in std_logic;  

              OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);
       
              -- FETCH
              BranchD    : out std_logic;            -- Sel mux on Program Counter and Clear Pipe Regs between F and D
              
              --DECODE
              Select_ext: out std_logic; --signal for sign extend 
              --EqualD: IN std_logic; --WE WILL CONSIDER IT ON WRAPPER WITH PIPELINE
              -----
              --ENABLE_RF: out std_logic; -- ENABLE REGISTER FILE --- TO DO IN DATAPATH
              IsJal:  OUT std_logic; -- control signal to set muxes to address R31
              RD1:    out std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
              RD2:    out std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH
              RegWriteD:     out std_logic; --ENABLE WRITE PORT OF RF COMING FROM WRITEBACK ---- TO DO IN DATAPATH

              Comp_control: OUT std_logic_vector(1 downto 0); --control signal for comparator that gives to CU the EqualD signal
              -----
              
              --EXECUTE
              RegDestD: OUT std_logic; --select first mux of execute stage
              ALUSrcD: OUT std_logic; --select second mux of execute stage
              ALUcontrolD: OUT std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU
              
              --MEMORY
              MemWriteD: OUT std_logic; -- ENABLE WRITE PORT OF DATA MEMORY STAGE
              
              --WB
              MemToRegD: OUT std_logic; -- SEL OF MUX IN WRITEBACK STAGE
              
              --FOR WINDOW REGISTER
              CALL, RET: OUT std_logic;
              FILL, SPILL: IN std_logic); 
              
              --TO HAZARD UNIT            FOR THE WRAPPER
              --BranchD_H: OUT std_logic; 
              --MemToRegE_H: OUT std_logic;
              --RegWriteE_H: OUT std_logic;
              --MemToRegM_H: OUT std_logic;
              --RegWriteM_H: OUT std_logic;
              --RegWriteW_H: OUT std_logic); 
end component;

signal Rst_s : std_logic;  
signal OPCODE_s:  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
signal FUNC_s:  std_logic_vector(FUNC_SIZE - 1 downto 0);     
-- FETCH
signal BranchD_s:  std_logic;            -- Sel mux on Program Counter and Clear Pipe Regs between F and D           
--DECODE
signal Select_ext_s: std_logic; --signal for sign extend 
-----
--signal ENABLE_RF_s: std_logic; -- ENABLE REGISTER FILE --- TO DO IN DATAPATH
signal IsJal_s: std_logic; -- control signal to set muxes to address R31
signal RD1_s:  std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
signal RD2_s:  std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH
signal RegWriteD_s: std_logic; --ENABLE WRITE PORT OF RF COMING FROM WRITEBACK ---- TO DO IN DATAPATH
signal Comp_control_s: std_logic_vector(1 downto 0); --control signal for comparator that gives to CU the EqualD signal
-----         
--EXECUTE
signal RegDestD_s:  std_logic; --select first mux of execute stage
signal ALUSrcD_s:  std_logic; --select second mux of execute stage
signal ALUcontrolD_s: std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU         
--MEMORY
signal MemWriteD_s:  std_logic; -- ENABLE WRITE PORT OF DATA MEMORY STAGE           
--WB
signal MemToRegD_s:  std_logic; -- SEL OF MUX IN WRITEBACK STAGE           
--FOR WINDOW REGISTER
signal CALL_s, RET_s: std_logic;
signal FILL_s, SPILL_s:  std_logic; 

--SIGNAL FOR TB
signal OPCODE_addr: std_logic_vector(OP_CODE_SIZE - 1 downto 0);
signal FUNC_addr  : std_logic_vector(FUNC_SIZE - 1 downto 0);

begin

DUT: cu port map (Rst_s, OPCODE_s, FUNC_s, BranchD_s, Select_ext_s,
                  IsJal_s, RD1_s, RD2_s, RegWriteD_s, Comp_control_s, RegDestD_s,
                  ALUSrcD_s, ALUcontrolD_s, MemWriteD_s, MemToRegD_s, CALL_s, RET_s, FILL_s, SPILL_s);
                  
process
begin

    Rst_s <= '1';
    
    OPCODE_s <= (OTHERS => '0');
    FUNC_s <= (OTHERS => '0');
    OPCODE_addr <= (others => '0');
    FUNC_addr   <= (others => '0');
    
    wait for 10 ns;
    
    Rst_s <= '0';
    
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
    
    wait;
    
end process;
end Behavioral;
