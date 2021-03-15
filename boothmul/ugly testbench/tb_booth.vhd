----------------------------------------------------------------------------------
-- Create Date: 11.03.2021
-- Module Name: testbench 
-- Project Name: DLX
-- Version: 1.0
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

  signal Y_mp_i : std_logic_vector(N-1 downto 0) := (others => '0');

  component boothmul 
  generic(NBIT : integer := 32;
          N: integer := 16;
          M: integer := 16);
  port(a: in std_logic_vector(N-1 downto 0);
       b: in std_logic_vector(M-1 downto 0);
       mul: out std_logic_vector(NBIT-1 downto 0));
  end component;

  begin

    dut: boothmul port map (a=>A_mp_i, b=>B_mp_i, mul=>Y_mp_i);

    A_mp_i <= "0000011111111111", "0000000000000010" after 30 ns, "1111111111000000" after 60 ns;
    B_mp_i <= "1111111111101000", "0000000000011000" after 30 ns, "1111111111111100" after 60 ns;
    
end test;
