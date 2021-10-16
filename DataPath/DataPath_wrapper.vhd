----------------------------------------------------------------------------------
-- Create Date: 17.08.2021
-- Module Name: Datapath Wrapper
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DataPath_wrapper is
  Port (  clk: IN std_logic;
          rst: IN std_logic;
  
        --IRAM Memory signals
          address_to_iram: out std_logic_vector(31 downto 0);
          iram_to_dlx: in std_logic_vector(31 downto 0);
        --DRAM Memory signals
          address_to_dram: out std_logic_vector(31 downto 0);
          data_to_dram : out std_logic_vector(31 downto 0);
          dram_to_dlx: in  std_logic_vector(31 downto 0);
          dram_we : out std_logic;
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
          en_ALU:      in std_logic; --enable for the ALU
          --Memory
          MemWriteM: in std_logic; --write enable for memory stage
          --Writeback
          MemToRegW: in std_logic --select mux on WB
          );
end DataPath_wrapper;

architecture Behavioral of DataPath_wrapper is

constant NBIT : integer := 32;
constant NWORDS_IRAM : integer := 64;
constant NWORDS_DRAM : integer := 64;

component fetch_stage_wrapper is
    generic (nbit : integer := 32;
             nwords : integer := 64);
    port (PCBranchD: in std_logic_vector(nbit-1 downto 0);
          PCPlus4F, InstrD : out std_logic_vector(nbit-1 downto 0);
          address_to_iram: out std_logic_vector(nbit-1 downto 0);
          iram_to_dlx: in std_logic_vector(nbit-1 downto 0);
          PCSrcD, StallF, clk, rst : in std_logic);
end component;

component Decode_wrapper 

  Port (instrD: IN std_logic_vector(31 downto 0);
        PcPlus4D: IN std_logic_vector(31 downto 0);
        select_ext: IN std_logic; --additional signal to control sign extend
        ForwardAd, ForwardBD: IN std_logic; --forwardAD, forwardBD
        clk, en, rst: IN std_logic;
        RD1_EN, RD2_EN: IN std_logic;
        ALUOutM: IN std_logic_vector (31 downto 0);
        WriteRegW: IN std_logic_vector(4 downto 0);
        ResultW: IN std_logic_vector(31 downto 0);
        CALL, RET: IN std_logic;
        IsJal: IN std_logic; -- signal to enable write when instr JAL
        Comp_control: IN std_logic_vector(1 downto 0); --control signal to make right comparison for jumps
        RegWriteW: IN std_logic; --enable write signal from CU when Write from WB
        Memory_in: IN std_logic_vector(31 downto 0); 
        Memory_out: OUT std_logic_vector(31 downto 0);
        FILL, SPILL: OUT std_logic;
        RsD: OUT std_logic_vector(4 downto 0);
        RtD: OUT std_logic_vector(4 downto 0);
        RdE: OUT std_logic_vector(4 downto 0);
        SignImmD: OUT std_logic_vector(31 downto 0);
        PCBranchD: OUT std_logic_vector(31 downto 0);
        EqualD: OUT std_Logic;
        OP: OUT std_logic_vector(5 downto 0);
        FUNC: OUT std_logic_vector(10 downto 0);
        RD1, RD2: OUT std_logic_vector(31 downto 0));
end component;

component execute_stage_wrapper
    generic (NBIT : integer := 32; -- nbits operands
                N : integer := 32);-- nbits PC
                -- I/O signals
    port    (en_alu: IN std_logic;
             RD1E :  IN std_logic_vector(NBIT-1 downto 0);    -- SrcA
             RD2E :  IN std_logic_vector(NBIT-1 downto 0);
              RsE :  IN std_logic_vector(     4 downto 0);
              RdE :  IN std_logic_vector(     4 downto 0);    -- destRegI
              RtE :  IN std_logic_vector(     4 downto 0);    -- destRegR
         SignImmE :  IN std_logic_vector(NBIT-1 downto 0);
         
         ALUOutME :  IN std_logic_vector(NBIT-1 downto 0);
         ResultWE :  IN std_logic_vector(NBIT-1 downto 0);
         
          ALUoutE : OUT std_logic_vector(NBIT-1 downto 0);
        WriteRegE : OUT std_logic_vector(     4 downto 0);
       WriteDataE : OUT std_logic_vector(NBIT-1 downto 0);
       
                -- hazard signals
        ForwardAE :  IN std_logic_vector(     1 downto 0);
        ForwardBE :  IN std_logic_vector(     1 downto 0);
            RsE_o : OUT std_logic_vector(     4 downto 0);
            RtE_o : OUT std_logic_vector(     4 downto 0);
       
                -- Control signals
          RegDstE :  IN std_logic;
          ALUSrcE :  IN std_logic;
      ALUcontrolE :  IN std_logic_vector(     5 downto 0));   -- select alu 
end component;

component memory_unit is
    generic (nbit : integer := 32;
             nwords : integer := 64);
    port (ALUOutMIn, WriteDataM: in std_logic_vector(nbit-1 downto 0);
          ReadDataM, ALUOutMOut : out std_logic_vector(nbit-1 downto 0);
          address_to_dram : out std_logic_vector(nbit-1 downto 0);
          data_to_dram : out std_logic_vector(nbit-1 downto 0);
          dram_to_dlx : in std_logic_vector(nbit-1 downto 0);
          WriteRegMIn : in std_logic_vector(4 downto 0);
          WriteRegMOut : out std_logic_vector(4 downto 0);
          clk, rst, MemWriteM : in std_logic;
          MemWriteM_out : out std_logic);
end component;

component writeback_unit
    generic(N: integer := 32);
    port(ReadDataW, ALUOutW : in std_logic_vector(n-1 downto 0);
         WriteRegW : in std_logic_vector(4 downto 0);
         MemToRegW: in std_logic;
         WriteRegW_out : out std_logic_vector(4 downto 0);
         ResultW: out std_logic_vector(n-1 downto 0));
end component;

--SIGNAL AS REGISTERS FOR PIPELINE
-- FETCH  -> DECODE
    signal IR, IRnext: std_logic_vector(31 downto 0);
    signal PCPlus4, PCPlus4next: std_logic_vector(31 downto 0);
-- DECODE -> EXECUTE
    signal RD1, RD1next: std_logic_vector(31 downto 0);
    signal RD2, RD2next: std_logic_vector(31 downto 0);
    signal RsD, RsDnext: std_logic_vector(4 downto 0);
    signal RtD, RtDnext: std_logic_vector(4 downto 0);
    signal RdD, RdDnext: std_logic_vector(4 downto 0);
    signal SignImmD, SignImmDnext: std_logic_vector(31 downto 0);
-- EXECUTE -> MEMORY
    signal ALUOutE, ALUOutEnext: std_logic_vector(31 downto 0);
    signal WriteDataE, WriteDataEnext: std_logic_vector(31 downto 0);
    signal WriteRegE, WriteRegEnext: std_logic_vector(4 downto 0);
-- MEMORY -> WB
    signal ReadDataM, ReadDataMnext: std_logic_vector(31 downto 0);
    signal ALUOutM, ALUOutMnext: std_logic_vector(31 downto 0);
    signal WriteRegM, WriteRegMnext: std_logic_vector(4 downto 0);
--------------------------------------------------------------------

--signal interconnections
-- FETCH WIRES
signal PCBranchD_wire: std_logic_vector(31 downto 0);
signal PCPlus4F_wire:  std_logic_vector(31 downto 0);
signal InstrD_wire:    std_logic_vector(31 downto 0);
signal WriteRegW_wire: std_logic_vector(4 downto  0);
signal ResultW_wire:   std_logic_vector(31 downto 0);

--DECODE WIRES
signal RsD_wire: std_logic_vector(4 downto 0);
signal RtD_wire: std_logic_vector(4 downto 0);
signal RdD_wire: std_logic_vector(4 downto 0);
signal SignImmD_wire: std_logic_vector(31 downto 0);
signal RD1_wire : std_logic_vector(31 downto 0);
signal RD2_wire : std_logic_vector(31 downto 0);
signal RF_OUT, RF_IN : std_logic_vector(31 downto 0);

--EXECUTE WIRES
signal ALUOutE_wire: std_logic_vector(31 downto 0);
signal WriteRegE_H_wire: std_logic_vector(4 downto 0);
signal WriteDataE_wire: std_logic_vector(31 downto 0);

--MEMORY WIRES
signal ReadDataM_wire: std_logic_vector(31 downto 0);
signal ALUOutMOut_wire: std_logic_vector(31 downto 0);
signal WriteRegMOut_wire: std_logic_vector(4 downto 0);

--WB WIRES
signal WriteRegWBOut_wire: std_logic_vector(4 downto 0);


begin
    process( clk, rst, StallF, StallD, PCSrcD, FlushE)
    begin
        if(rst = '1') then
            -- FETCH -> DECODE
            IR <= (OTHERS => '0');
            PCPlus4 <= (OTHERS => '0');
            -- DECODE -> EXECUTE
            RD1 <= (OTHERS => '0');
            RD2 <= (OTHERS => '0');
            RsD <= (OTHERS => '0');
            RtD <= (OTHERS => '0');
            RdD <= (OTHERS => '0');
            SignImmD <= (OTHERS => '0');
            --EXECUTE -> MEMORY
            ALUOutE <= (OTHERS => '0');
            WriteDataE <= (OTHERS => '0');
            WriteRegE <= (OTHERS => '0');
            -- MEMORY -> WB
            ReadDataM <= (OTHERS => '0');
            ALUOutM <= (OTHERS => '0');
            WriteRegM <= (OTHERS => '0');
        
        elsif(rising_edge(clk)) then
            -- CLR for FETCH -> DECODE REGS
            if ( PCSrcD = '1') then
                IR <= (OTHERS => '0'); -- NOP
                PCPlus4 <= (OTHERS => '0'); --NO INCREMENT FOR PC
            end if;
            -- CLR for DECODE -> EXECUTE REGS
            if (FlushE = '1') then
                RD1 <= (OTHERS => '0');
                RD2 <= (OTHERS => '0');
                RsD <= (OTHERS => '0');
                RtD <= (OTHERS => '0');
                RdD <= (OTHERS => '0');
                SignImmD <= (OTHERS => '0');
            end if;
            -- FETCH -> DECODE
            if(StallD = '0') then
                IR <= IRnext;
                PCPlus4 <= PCPlus4next;
            end if;
            -- DECODE -> EXECUTE
            RD1 <= RD1next;
            RD2 <= RD2next;
            RsD <= RsDnext;
            RtD <= RtDnext;
            RdD <= RdDnext;
            SignImmD <= SignImmDnext;
            --EXECUTE -> MEMORY
            ALUOutE <= ALUOutEnext;
            WriteDataE <= WriteDataEnext;
            WriteRegE <= WriteRegEnext;
            -- MEMORY -> WB
            ReadDataM <= ReadDataMnext;
            ALUOutM <= ALUOutMnext;
            WriteRegM <= WriteRegMnext;
        end if;
    end process;
                
        
 fetch_stage: fetch_stage_wrapper generic map (NBIT, NWORDS_IRAM)
                                     port map (PCBranchD_wire, PCPlus4F_wire, InstrD_wire, address_to_iram, iram_to_dlx, PCSrcD, StallF, clk, rst);       
        
        
        IRnext <= InstrD_wire;
        PCPlus4next <= PCPlus4F_wire;
        
 decode_stage: decode_wrapper port map ( IR, PCPlus4, Select_ext, ForwardAD, ForwardBD, clk, en_RF ,rst_RF, RD1_EN, RD2_EN, ALUOutMOut_wire,
                                         WriteRegW_wire, ResultW_wire, CALL, RET, isJal, Comp_control, RegWriteW, RF_OUT, RF_IN, FILL, SPILL,
                                         RsD_wire, RtD_wire, RdD_wire, SignImmD_wire, PCBranchD_wire, EqualD, OP, FUNC,
                                         RD1_wire, RD2_wire);
        
        --Pipeline registers                    
        RD1next <= RD1_wire;
        RD2next <= RD2_wire;
        RsDnext <= RsD_wire;
        RtDnext <= RtD_wire;
        RdDnext <= RdD_wire;
        SignImmDnext <= SignImmD_wire;
        --To hazard unit
        RsD_H <= RsD_wire;
        RtD_H <= RtD_wire;
                                         
 execute_stage: execute_stage_wrapper generic map (NBIT, NBIT)
                                         port map (en_ALU, RD1, RD2, RsD, RdD, RtD, SignImmD, 
                                                   ALUOutMOut_wire, ResultW_wire,
                                                   ALUOutE_wire, WriteRegE_H_wire, WriteDataE_wire,
                                                   ForwardAE, ForwardBE, RsE_H, RtE_H,
                                                   RegDstE, ALUSrcE, ALUcontrolE);
        --Pipeline                                                   
        ALUOutEnext <= ALUOutE_wire;
        WriteDataEnext <= WriteDataE_wire;
        WriteRegEnext <= WriteRegE_H_wire;
        --To hazard unit
        WriteRegE_H <= WriteRegE_H_wire;
                                                   
  memory_stage: memory_unit generic map (NBIT, NWORDS_DRAM)
                               port map (ALUOutE, WriteDataE,
                                         ReadDataM_wire, ALUOutMOut_wire,
                                         address_to_dram, data_to_dram,
                                         dram_to_dlx,
                                         WriteRegE, WriteRegMOut_wire,
                                         clk, rst_mem, MemWriteM, dram_we);      
        
        --Pipeline
        ReadDataMnext <= ReadDataM_wire;
        ALUOutMnext <= ALUOutMOut_wire;
        WriteRegMnext <= WriteRegMOut_wire;
        --To hazard unit
        WriteRegMOut_H <= WriteRegMOut_wire;
        
 WB_stage: writeback_unit generic map (NBIT)
                             port map (ReadDataM, ALUOutM,
                                       WriteRegM,
                                       MemToRegW,
                                       WriteRegW_wire,
                                       ResultW_wire);  
    
        WriteRegWBOut_H <= WriteRegW_wire;

end Behavioral;
