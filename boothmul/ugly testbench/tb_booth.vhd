----------------------------------------------------------------------------------
-- Create Date: 16.05.2021
-- Module Name: testbench 
-- Project Name: DLX
-- Version: 2.0 -- fixed the ugly testbench
-- Additional Comments: testbench for the multiplier (Booth algorithm)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_booth is
end tb_booth;

architecture test of tb_booth is
  constant numBit: integer := 16;
  constant N: integer := 32;

  signal A_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal B_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal en_mp_i: std_logic;
  signal Y_mp_i : std_logic_vector(N-1 downto 0) := (others => '0');

  component mul_wrapper 
	generic( NBIT: integer := 32;
              N: integer := 16;
              M: integer := 16);
  port   (a: IN  std_logic_vector(N-1 downto 0);
          b: IN  std_logic_vector(M-1 downto 0);
         en: IN  std_logic;
        mul: OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    dut: mul_wrapper port map (a=>A_mp_i, b=>B_mp_i, en=>en_mp_i, mul=>Y_mp_i);
    
    process
    begin
    
    en_mp_i <= '1', '0' after 5 ns, '1' after 10 ns;
    
    A_mp_i <= x"0004";
    B_mp_i <= x"0004";
    wait for 11 ns;
    assert (Y_mp_i = x"00000010") report "error positive";
    
    A_mp_i <= x"fff6";
    B_mp_i <= x"0004";
    wait for 10 ns;
    assert (Y_mp_i = x"ffffffd8") report "error 1 neg";
    
    A_mp_i <= x"0004";
    B_mp_i <= x"fff6";
    wait for 10 ns;
    assert (Y_mp_i = x"ffffffd8") report "error 2 neg";
    
    A_mp_i <= x"fff6";
    B_mp_i <= x"fff6";
    wait for 10 ns;
    assert (Y_mp_i = x"00000064") report "error both neg";
    
    wait;
    end process;
end test;
