----------------------------------------------------------------------------------
-- Create Date: 16.08.2021
-- Module Name: Decode_stage_wrapper
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;


entity Decode_wrapper is

  Port (instrD: IN std_logic_vector(31 downto 0);
        PcPlus4D: IN std_logic_vector(31 downto 0);
        select_ext: IN std_logic; --additional signal to control sign extend
        ForwardAd, ForwardBD: IN std_logic; --forwardAD, forwardBD
        clk, en, rst: IN std_logic;
        RD1_EN, RD2_EN : IN std_logic;
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
        
end Decode_wrapper;

architecture Behavioral of Decode_wrapper is

constant nbit: integer := 32;
constant N: integer := 4;
constant M: integer := 4;
constant F: integer := 4;

component or_gate
    port(x, y: IN std_logic;
         z: OUT std_logic);
end component;

component sign_ext
    port( a: IN  std_logic_vector(31 downto 0);
          s: IN  std_logic;                  -- 0 ->  I  ; 1 -> J  .
          y: OUT std_logic_vector(31 downto 0));
end component;

component adder_generic
    generic (nbit: integer := 32);
    port (a, b: in std_logic_vector(nbit-1 downto 0);
          y: out std_logic_vector(nbit-1 downto 0));
end component;

component MUX21
    generic(N: integer := 32);
    port (a,b: IN std_logic_vector(N-1 downto 0); --inputs are RD1 or RD2 and the other input is ALUOUT
          sel: IN std_logic;
          y:  OUT std_logic_vector(N-1 downto 0));
end component;

component comparator_addr
    Port (y1, y2: IN std_logic_vector(31 downto 0);
          comp_control: IN std_logic_vector(1 downto 0); --control signal to decide which jump has to be performed
          EqualD: OUT std_logic);
end component;

component window_rf
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
end component;

--additional signals for sign extended and shift for adder and branches    
signal signImmD_temp: std_logic_vector(31 downto 0);

--signal for window register file
--signal en_RD1, en_RD2, en_WR: std_logic;
signal A1, A2: std_logic_vector(4 downto 0); --A1=RD1_addr,  A2=RD2_addr
--signal WD3: std_logic_vector(31 downto 0); -- ResultW
--signal FILL,SPILL,CALL,RET: std_logic;
--signal Memory_in, Memory_out: std_logic_vector(31 downto 0);
signal RD1_rf, RD2_rf: std_logic_vector(31 downto 0);
signal clk_rf: std_logic;

--signal for muxes and comparator
signal out1_mux, out2_mux: std_logic_vector(31 downto 0);
signal ResultOrJal: std_logic_vector(31 downto 0);
signal Addr_or_R31: std_logic_vector(4 downto 0);

--signal from OR between RegWriteW and IsJal
signal enable_for_W_RF: std_logic;

begin

    clk_rf <= not(clk);
    signImmD <= signImmD_temp;
    
    

    Sign_extended: sign_ext port map (InstrD, select_ext, signImmD_temp);
    
    adder: adder_generic generic map (nbit) port map (signImmD_temp, PCPlus4D, PCBranchD);

    --new mux to drive write inside the Reg the result from WB
    -- or write the address of a jump inside R31
    MUX3: MUX21 generic map (nbit) port map (ResultW, PcPlus4D, IsJal, ResultOrJal); 

    OR1: or_gate port map (IsJal, RegWriteW, enable_for_W_RF);

    MUX4: MUX21 generic map (5) port map (WriteRegW, "11111", IsJal, Addr_or_R31);

    RF: window_rf generic map (N,M,F,nbit)
                     port map (clk_rf, rst, en, RD1_EN, RD2_EN, enable_for_W_RF, Addr_or_R31, A1, A2, 
                               FILL, SPILL, CALL, RET,
                               Memory_in, Memory_out, ResultOrJal, RD1_rf, RD2_rf);    
    
    MUX1: MUX21 generic map (nbit) port map (RD1_rf, ALUOutM, ForwardAd, out1_mux);
    MUX2: MUX21 generic map (nbit) port map (RD2_rf, ALUOutM, ForwardBD, out2_mux);
    
    Comparator: comparator_addr port map (out1_mux, out2_mux, Comp_control, EqualD);
    
    RD1 <= out1_mux;
    RD2 <= out2_mux;
    
    A1 <= InstrD(25 downto 21);
    A2 <= instrD(20 downto 16);
    
    RsD <= InstrD(25 downto 21);
    RtD <= instrD(20 downto 16);
    RDe <= instrD(15 downto 11);
    
    Op <= instrD(31 downto 26);
    FUNC <= instrD(10 downto 0);


end Behavioral;
