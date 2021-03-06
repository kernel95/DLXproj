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
        ALUOutM: IN std_logic_vector (31 downto 0);
        WriteRegW: IN std_logic_vector(4 downto 0);
        ResultW: IN std_logic_vector(31 downto 0);
        CALL, RET: IN std_logic;
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

component sign_ext
    port( a: IN  std_logic_vector(31 downto 0);
          s: IN  std_logic;                  -- 0 ->  I  ; 1 -> J  .
          y: OUT std_logic_vector(31 downto 0));
end component;

component shift_by_two
    Port (SignImmD: in std_logic_vector(31 downto 0);
          shifted_out: out std_logic_vector(31 downto 0));
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
signal sign_ext_in: std_logic_vector(31 downto 0);
signal signImmD_temp: std_logic_vector(31 downto 0);
signal shifted_out: std_logic_vector(31 downto 0);

--signal for window register file
signal en_RD1, en_RD2, en_WR: std_logic;
signal A1, A2: std_logic_vector(4 downto 0); --A1=RD1_addr,  A2=RD2_addr
--signal WD3: std_logic_vector(31 downto 0); -- ResultW
--signal FILL,SPILL,CALL,RET: std_logic;
--signal Memory_in, Memory_out: std_logic_vector(31 downto 0);
signal RD1_rf, RD2_rf: std_logic_vector(31 downto 0);
signal clk_rf: std_logic;

--signal for muxes and comparator
signal out1_mux, out2_mux: std_logic_vector(31 downto 0);

--internal signal for pipeline




begin
    sign_ext_in <= "0000000000000000" & InstrD(15 downto 0);
    clk_rf <= not(clk);
    
    
    Sign_extended: sign_ext port map (sign_ext_in, select_ext, signImmD_temp);
    
    shift: shift_by_two port map (signImmD_temp, shifted_out);
    
    adder: adder_generic generic map (nbit) port map (shifted_out, PCPlus4D, PCBranchD);
                            
    RF: window_rf generic map (N,M,F,nbit)
                     port map (clk_rf, 
                               rst, en, 
                               en_RD1,
                               en_RD2,
                                en_WR,
                                 WriteRegW,
                                  A1,
                                   A2,
                                    FILL,
                                     SPILL,
                                      CALL,
                                       RET,
                                        Memory_in,
                                         Memory_out,
                                          ResultW,
                                           RD1_rf,
                                            RD2_rf);    
    
    MUX1: MUX21 generic map (nbit) port map (RD1_rf, ALUOutM, ForwardAd, out1_mux);
    MUX2: MUX21 generic map (nbit) port map (RD2_rf, ALUOutM, ForwardBD, out2_mux);
    
    Comparator: comparator_addr port map (out1_mux, out2_mux, EqualD);
    
    RD1 <= out1_mux;
    RD2 <= out2_mux;
    
    RsD <= InstrD(25 downto 21);
    RtD <= instrD(20 downto 16);
    RDe <= instrD(15 downto 11);
    
    Op <= instrD(31 downto 26);
    FUNC <= instrD(10 downto 0);


end Behavioral;
