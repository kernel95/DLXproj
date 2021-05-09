----------------------------------------------------------------------------------
-- Create Date: 28.04.2021
-- Module Name: tb_comparator
-- Project Name: DLX
-- Version: 2.0 - removed types
-- Additional Comments: testbench for the comparator 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.comparator_type.all;

entity tb_comparator is
end tb_comparator;

architecture Behavioral of tb_comparator is

constant NBIT : integer := 32;
signal      A_S : std_logic_vector(NBIT-1 downto 0);
signal      B_S : std_logic_vector(NBIT-1 downto 0);
signal     en_S : std_logic;
signal   cond_S : std_logic_vector(2 downto 0);
signal      O_S : std_logic;

component zero_comparator 
    generic (N : integer := 32);        --num bits
    port    (A : IN  std_logic_vector(N-1 downto 0);
             B : IN  std_logic_vector(N-1 downto 0);
            en : IN  std_logic;
          cond : IN  std_logic_vector(2 downto 0);
             O : OUT std_logic);
end component;

begin

dut: zero_comparator generic map(NBIT) port map (A_S, B_S, en_S, cond_S, O_S);

A_S    <= "00000000000000000000000000000001", "00000000000000000000000000000000" after 4 ns,  "00000000000000000000000000000001" after 15 ns;
B_S    <= "00000000000000000000000000000000", "00000000000000000000000000000001" after 11 ns, "00000000000000000000000000000000" after 19 ns,
          "00000000000000000000000000000011" after 21 ns, "00000000000000000000000000000000" after 25 ns, 
          "00000000000000000000000000000111" after 30 ns, "00000000000000000000000000000000" after 35 ns;

en_S   <= '1';
cond_S <= "000" after 2  ns, -- ZERO
          "001" after 7  ns, -- EQ
          "010" after 12 ns,  -- NEQ
          "011" after 17 ns,  -- GE
          "100" after 22 ns,  -- GT
          "101" after 27 ns,  -- LE
          "110" after 32 ns;  -- LT

end Behavioral;
