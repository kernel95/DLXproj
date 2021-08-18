----------------------------------------------------------------------------------
-- Create Date: 18.08.2021
-- Module Name: Test bench for Datapath
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_DP is
end TB_DP;

architecture Behavioral of TB_DP is

component DataPath_wrapper
  Port (  clk: IN std_logic;
          rst: IN std_logic;
  
        --IRAM Memory signals
          IRAM_in: IN std_logic_vector(31 downto 0);
          IRAM_out: OUT std_logic_vector(31 downto 0);
        --DRAM Memory signals
          DRAM_in: IN std_logic_vector(31 downto 0);
          DRAM_out: OUT  std_logic_vector(31 downto 0);
        
        --HAZARD UNIT SIGNALS
        --Fetch
          StallF, StallD: IN std_logic;
        --Decode
          ForwardAD, ForwardBD: IN std_logic;
          FlushE: IN std_logic;
          rst_RF: IN std_logic;
          en_RF: IN std_logic;
          
          RsD_H: OUT std_logic_vector(4 downto 0);
          RtD_H: OUT std_logic_vector(4 downto 0);
          
        --EXECUTE
          ForwardAE, ForwardBE: IN std_logic_vector(1 downto 0);
          WriteRegE_H: OUT std_logic_vector(4 downto 0);
          RsE_H: OUT std_logic_vector(4 downto 0);
          RtE_H: OUT std_logic_vector(4 downto 0);
          
        --MEMORY
          WriteRegMOut_H: OUT std_logic_vector(4 downto 0);
          rst_mem: IN std_logic; 
          
        --WB
          WriteRegWBOut_H: OUT std_logic_vector(4 downto 0);
        --Control Unit OUT
          OP: OUT std_logic_vector (5 downto 0);
          FUNC: OUT std_logic_vector(10 downto 0);
          EqualD: OUT std_logic;
          FILL, SPILL: OUT std_logic; --signals for Register File fill and spill form/to memory
        --Control Unit IN
          PCSrcD: IN std_logic; --feed mux for PC and CLR REG between fetch and decode
          RegWriteW: IN std_logic; -- from writeback, enables RF for DATA_IN
          Select_ext: IN std_logic; --additional signal to control sign extend
          CALL, RET: IN std_logic; --signals for Register File call and ret
          
          RegDstE: IN std_Logic; -- select for mux on execute for writing destination reg
          ALUSrcE: IN std_logic; --select between immediate or operand 
          ALUControlE: in std_logic_vector (5 downto 0); --decode for ALU
          
          MemWriteM: in std_logic; --write enable for memory stage
          MemToRegW: in std_logic --select mux on WB
          );
end component;
--FETCH
signal clk_s, rst_s: std_logic;
signal IRAM_in_s, IRAM_out_s: std_logic_vector(31 downto 0);
signal DRAM_in_s, DRAM_out_s: std_logic_vector(31 downto 0);
signal StallF_s, StallD_s: std_logic;
--DECODE
signal ForwardAD, ForwardBD_s, FlushE_s, rst_RF_s, en_RF_s: std_logic;
signal RsD_H_s, RtD_H_s: std_logic_vector(4 downto 0);
--EXECUTE
signal ForwardAE_s, ForwardBE_s: std_logic_vector(1 downto 0);         
signal WriteRegE_H_s, RsE_H_s, RtE_H_s :  std_logic_vector(4 downto 0);
--MEMORY
signal WriteRegMOut_H_s: std_logic_vector(4 downto 0);          
signal rst_mem_s: std_logic;          
--WB
signal WriteRegWBOut_H_s: std_logic_vector(4 downto 0);                    

--CU
signal OP_s: std_logic_vector (5 downto 0);
signal FUNC_s: std_logic_vector(10 downto 0);
signal EqualD_s: std_logic;
signal FILL_s, SPILL_s: std_logic; --signals for Register File fill and spill form/to memory
--Control Unit IN
signal PCSrcD_s:  std_logic; --feed mux for PC and CLR REG between fetch and decode
signal RegWriteW_s:  std_logic; -- from writeback, enables RF for DATA_IN
signal Select_ext_s:  std_logic; --additional signal to control sign extend
signal CALL_s, RET_s:  std_logic; --signals for Register File call and ret
          
signal RegDstE_s:  std_Logic; -- select for mux on execute for writing destination reg
signal ALUSrcE_s:  std_logic; --select between immediate or operand 
signal ALUControlE_s:  std_logic_vector (5 downto 0); --decode for ALU       
signal MemWriteM_s:  std_logic; --write enable for memory stage
signal MemToRegW_s:  std_logic; --select mux on WB           
                            

begin

DP_DUT: DataPath_Wrapper port map (clk_s, rst_s, IRAM_in_s, IRAM_out_s, DRAM_in_s, DRAM_out_s,
                                   StallF_s, StallD_s, ForwardAD, ForwardBD_s, FlushE_s, rst_RF_s, en_RF_s,
                                   RsD_H_s, RtD_H_s, ForwardAE_s, ForwardBE_s, WriteRegE_H_s, RsE_H_s, RtE_H_s,
                                   WriteRegMOut_H_s, rst_mem_s, WriteRegWBOut_H_s,
                                   OP_s, FUNC_s, EqualD_s, FILL_s, SPILL_s,
                                   PCSrcD_s, RegWriteW_s, Select_ext_s, CALL_s, RET_s,
                                   RegDstE_s, ALUSrcE_s, ALUControlE_s, MemWriteM_s, MemToRegW_s);
                                   

end Behavioral;
