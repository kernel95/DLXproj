library IEEE;
use IEEE.std_logic_1164.all;

entity TB_P4_ADDER is
end TB_P4_ADDER;

architecture TEST of TB_P4_ADDER is
constant NBIT:integer:=32;	
-- P4 component declaration
  component final_adder is
	generic(nbit : integer := 32);
  port(op1, op2: IN integer std_logic_vector(nbit-1 downto 0);
       CarryIn:  IN std_logic;
       sum: OUT std_logic_vector(nbit-1 downto 0);
       CarryOut, overflow: OUT std_logic);
  end component;
	
signal op1_s,op2_s: std_logic_vector(NBIT-1 downto 0);
signal CarryIn_s: std_logic;
signal sum_s: std_logic_vector(NBIT-1 downto 0);
signal CarryOut_s, overflow_s: std_logic;

  
begin

  dut: final_adder generic map (NBIT => NBIT)
                      port map (op1_s, op2_s, CarryIn_s, sum_s, CarryOut_s, overflow_s);

  CarryIn_s<='0';
  op1_s<="00000000000000000000000000000101";
  op2_s<="00000000000000000000000000000110";
	
end TEST;