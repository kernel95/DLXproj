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
          address_to_iram: out std_logic_vector(31 downto 0);
          iram_to_dlx: in std_logic_vector(31 downto 0);
        --DRAM Memory signals
          DRAM_in: out std_logic_vector(31 downto 0);
          DRAM_out: in  std_logic_vector(31 downto 0);
        
        --HAZARD UNIT SIGNALS
        --Fetch
          StallF, StallD: IN std_logic;
        --Decode
          ForwardAD, ForwardBD: IN std_logic;
          FlushE: IN std_logic;
          rst_RF: IN std_logic;
          en_RF: IN std_logic;
          
          RsD_H: OUT std_logic_vector(4 downto 0);  --To Hazard Unit
          RtD_H: OUT std_logic_vector(4 downto 0);  --To Hazard Unit
          
        --EXECUTE
          ForwardAE, ForwardBE: IN std_logic_vector(1 downto 0);
          WriteRegE_H: OUT std_logic_vector(4 downto 0);    --To Hazard Unit
          RsE_H: OUT std_logic_vector(4 downto 0);          --To Hazard Unit
          RtE_H: OUT std_logic_vector(4 downto 0);          --To Hazard Unit
          
        --MEMORY
          WriteRegMOut_H: OUT std_logic_vector(4 downto 0); --To Hazard Unit
          rst_mem: IN std_logic; 
          
        --WB
          WriteRegWBOut_H: OUT std_logic_vector(4 downto 0); --To Hazard Unit
          
        --Control Unit OUT
          OP: OUT std_logic_vector (5 downto 0);
          FUNC: OUT std_logic_vector(10 downto 0);
          EqualD: OUT std_logic;
          FILL, SPILL: OUT std_logic; --signals for Register File fill and spill form/to memory
        --Control Unit IN
          --Fetch
          PCSrcD: IN std_logic; --feed mux for PC and CLR REG between fetch and decode
          --Decode
          RegWriteW: IN std_logic; -- from writeback, enables RF for DATA_IN
          Select_ext: IN std_logic; --additional signal to control sign extend
          CALL, RET: IN std_logic; --signals for Register File call and ret
          RD1_EN, RD2_EN : IN std_logic; --Read enable
          isJal    : IN std_logic; --OP is jal
          Comp_control : in std_logic_vector(1 downto 0);
          --Execute
          RegDstE: IN std_Logic; -- select for mux on execute for writing destination reg
          ALUSrcE: IN std_logic; --select between immediate or operand 
          ALUControlE: in std_logic_vector (5 downto 0); --decode for ALU
          --Memory
          MemWriteM: in std_logic; --write enable for memory stage
          --Writeback
          MemToRegW: in std_logic --select mux on WB
          );
end component;

--IRAM
component instruction_ram is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( addr: in std_logic_vector(isize-1 downto 0);
          dout: out std_logic_vector(isize-1 downto 0);
          rst : in std_logic);
end component;

signal clk_s, rst_s: std_logic := '0';
--IRAM Memory signals
signal address_to_iram_s, iram_to_dlx_s: std_logic_vector(31 downto 0);
--DRAM Memory signals
signal DRAM_in_s, DRAM_out_s: std_logic_vector(31 downto 0);

--HAZARD UNIT SIGNALS
--Fetch
signal StallF_s, StallD_s: std_logic;
--DECODE
signal ForwardAD_s, ForwardBD_s, FlushE_s, rst_RF_s, en_RF_s: std_logic;
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
--Fetch
signal PCSrcD_s:  std_logic; --feed mux for PC and CLR REG between fetch and decode
--Decode
signal RegWriteW_s:  std_logic; -- from writeback, enables RF for DATA_IN
signal Select_ext_s:  std_logic; --additional signal to control sign extend
signal CALL_s, RET_s:  std_logic; --signals for Register File call and ret
signal RD1_EN_s, RD2_EN_s : std_logic; --Read enable
signal isJal_s    :  std_logic; --OP is jal
signal Comp_control_s : std_logic_vector(1 downto 0);
--Execute          
signal RegDstE_s:  std_Logic; -- select for mux on execute for writing destination reg
signal ALUSrcE_s:  std_logic; --select between immediate or operand 
signal ALUControlE_s:  std_logic_vector (5 downto 0); --decode for ALU       
--Memory
signal MemWriteM_s:  std_logic; --write enable for memory stage
--Writeback
signal MemToRegW_s:  std_logic; --select mux on WB           
                            

begin

DUT: DataPath_wrapper port map (clk_s, rst_s, address_to_iram_s , iram_to_dlx_s, DRAM_in_s, DRAM_out_s, StallF_s, StallD_s, ForwardAD_s, ForwardBD_s, FlushE_s, rst_RF_s, en_RF_s,
                                RsD_H_s, RtD_H_s, ForwardAE_s, ForwardBE_s, WriteRegE_H_s, RsE_H_s, RtE_H_s, WriteRegMOut_H_s, rst_mem_s, WriteRegWBOut_H_s,
                                OP_s, FUNC_s, EqualD_s, FILL_s, SPILL_s, PCSrcD_s, RegWriteW_s, Select_ext_s, CALL_s, RET_s, RD1_EN_s, RD2_EN_s, isJal_s, Comp_control_s,
                                RegDstE_s, ALUSrcE_s, ALUControlE_s, MemWriteM_s, MemToRegW_s);

iram : instruction_ram generic map (64, 32) port map (address_to_iram_s, iram_to_dlx_s, rst_s);

ClkProc:process(clk_s)
begin
    clk_s <= not(clk_s) after 5 ns;
end process ClkProc;

--ADD_i OPCODE = 0x08
--RS1 00000
--RD 00001
--IMM 0000000000000001

--00100000000000010000000000000001 => 0x20010001

VectProc:process
begin
    rst_s <= '1';  
    --Hazard Unit
    StallF_s <= '0';  StallD_s <= '0'; ForwardAD_s <= '0'; ForwardBD_s <= '0'; FlushE_s <= '0'; rst_RF_s <= '1'; en_RF_s <= '1';
    ForwardAE_s <= "00";  ForwardBE_s <= "00";
    rst_mem_s <= '1';
    --Control Unit
    --Fetch
      PCSrcD_s <= '0';
      --Decode
      RegWriteW_s <= '0';
      Select_ext_s <= '0';
      CALL_s <= '0'; RET_s <= '0';
      RD1_EN_s <= '1'; RD2_EN_s <= '1';
      isJal_s <= '0';
      Comp_control_s <= "00";
      --Execute
      RegDstE_s <= '0';
      ALUSrcE_s <= '0'; 
      ALUControlE_s <= "000000";
      --Memory
      MemWriteM_s <= '0';
      --Writeback
      MemToRegW_s <= '0';
      
      wait until rising_edge(clk_s);
      rst_s <= '0';
      rst_RF_s <= '0';
      rst_mem_s <= '0';
      
      wait until rising_edge(clk_s);
      Select_ext_s <= '0';
      
      wait until rising_edge(clk_s);
      RegDstE_s <= '1';
      ALUSrcE_s <= '1'; 
      ALUControlE_s <= "010000";
      
      wait until rising_edge(clk_s);
      MemWriteM_s <= '0';
      
      wait until rising_edge(clk_s);
      MemToRegW_s <= '0';
      RegWriteW_s <= '1';
      
      wait until rising_edge(clk_s);
      RegWriteW_s <= '0';
      wait;
end process;
end Behavioral;
