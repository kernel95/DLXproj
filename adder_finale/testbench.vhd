library IEEE;
use IEEE.std_logic_1164.all;

entity TB_ADDER is
end TB_ADDER;

architecture TEST of TB_ADDER is
constant NBIT : integer := 32;  
-- P4 component declaration
  component adder_wrapper
    generic(nbit : integer := 32);
  port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
     CarryIn:  IN std_logic;
     sum: OUT std_logic_vector(nbit-1 downto 0);
     CarryOut, overflow: OUT std_logic;
     en_adder: IN std_logic);
  end component;
  
signal op1_s,op2_s: std_logic_vector(NBIT-1 downto 0);
signal CarryIn_s: std_logic;
signal sum_s: std_logic_vector(NBIT-1 downto 0);
signal CarryOut_s, overflow_s: std_logic;
signal en_adder_s: std_logic;
signal op2_ss: std_logic_vector(NBIT-1 downto 0);

  
begin

  dut: adder_wrapper generic map (NBIT)
                      port map (op1_s, op2_s, CarryIn_s, sum_s, CarryOut_s, overflow_s, en_adder_s);  
                      
  process
  begin
  
  en_adder_s <= '0';
  
  CarryIn_s <= '0';
  op1_s  <= "00000000000000000000000000000101";
  op2_s  <= "00000000000000000000000000000110";
  op2_ss <= "00000000000000000000000000000011";
  wait for 10 ns;
  -- 5 + 6
  CarryIn_s <= '0';
  op1_s <= "00000000000000000000000000000101";
  op2_s <= "00000000000000000000000000000110";
  
  en_adder_s <= '1';
  
  wait for 10 ns;
  -- 15 + 1
  CarryIn_s <= '0';
  op1_s <= "00000000000000000000000000001111";
  op2_s <= "00000000000000000000000000000001";
  wait for 10 ns;
  -- 14 - 4
  CarryIn_s <= '0';
  op1_s <= "00000000000000000000000000001110";
  op2_s <= not(op2_ss);
  wait for 10 ns;
  
  wait;
  
  end process;
  
end TEST;