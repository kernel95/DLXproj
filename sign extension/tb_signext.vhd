----------------------------------------------------------------------------------
-- Create Date: 05.05.2021
-- Module Name: testbench sign extension
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_signext is
end tb_signext;

architecture Behavioral of tb_signext is

signal a_s : std_logic_vector(31 downto 0);
signal s_s : std_logic;
signal y_s : std_logic_vector(31 downto 0);

component sign_ext 
    port( a: IN  std_logic_vector(31 downto 0);
          s: IN  std_logic;                  -- 0 ->  I  ; 1 -> J  .
          y: OUT std_logic_vector(31 downto 0));
end component;

begin
dut : sign_ext port map(a_s, s_s, y_s);

a_s <= "01100000000000000000111100001111", "11001111111111111111000011110000" after 10 ns, "01100000000000000001111111111111" after 20 ns, "11000111111111111110000000000000" after 30 ns;
s_s <= '0', '1' after 20 ns;

end Behavioral;
