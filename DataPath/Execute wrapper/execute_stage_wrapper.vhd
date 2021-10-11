----------------------------------------------------------------------------------
-- Create Date: 29.05.2021
-- Module Name: execute stage wrapper
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: exec stage of the pipeline of DLX 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity execute_stage_wrapper is
    generic (NBIT : integer := 32; -- nbits operands
                N : integer := 32);-- nbits PC
                -- I/O signals
    port    (RD1E :  IN std_logic_vector(NBIT-1 downto 0);    -- SrcA
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
end execute_stage_wrapper;

architecture Behavioral of execute_stage_wrapper is

component ALU 
	generic(NBIT : integer := 32);
	port(op1, op2:  IN std_logic_vector(NBIT-1 downto 0);
		      sel:  IN std_logic_vector(     5 downto 0);
		   result: OUT std_logic_vector(NBIT-1 downto 0);
		 CarryOut: OUT std_logic;
		 overflow: OUT std_logic);
end component;

component MUX21 
    generic(N: integer := 16);
    port (a,b: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic;
          y:  OUT std_logic_vector(N-1 downto 0));
end component;

component mux31                 -- 00 RD, 01 resultW, 10 ALUoutME
    generic(N: integer := 16);
    port (a,b,c: IN std_logic_vector(N-1 downto 0);
            sel: IN std_logic_vector(  1 downto 0);
              y: OUT std_logic_vector(N-1 downto 0));
end component;

signal SrcAE, SrcBE, SB: std_logic_vector(NBIT-1 downto 0);
signal carryOut_s, overflow_s: std_logic;

begin

mux31_1: mux31          generic map (NBIT)
                           port map (RD1E, ResultWE, ALUoutME, ForwardAE, SrcAE);
                           
mex31_2: mux31          generic map (NBIT)
                           port map (RD2E, ResultWE, ALUoutME, ForwardBE, SB);

selSrcB: MUX21          generic map (NBIT)
                           port map (SB, SignImmE, AluSrcE, SrcBE);
                           
regAddr: MUX21          generic map (5)
                           port map (RtE, --
                            RdE, --
                             RegDstE,
                              WriteRegE);
                  
ALUcomp: ALU            generic map (NBIT)
                           port map (SrcAE, SrcBE, ALUcontrolE, ALUoutE, carryOut_s, overflow_s);
                           
RsE_o <= RsE;
RtE_o <= RtE;
                  
WriteDataE <= SB;

end Behavioral;
