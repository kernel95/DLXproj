library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder_generic is
    generic (nbit: integer := 32);
    port (a, b: in std_logic_vector(nbit-1 downto 0);
          y: out std_logic_vector(nbit-1 downto 0));
end adder_generic;

architecture Behavioral of adder_generic is
begin
    y <= std_logic_vector(unsigned(a) + unsigned(b));
end Behavioral;
