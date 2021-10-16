----------------------------------------------------------------------------------
-- Create Date: 11.03.2021
-- Module Name: half-adder
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: or gate 2 inputs
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or2 is
    port( a, b:  IN std_logic;
             o: OUT std_logic);
end or2;

architecture Behavioral of or2 is
begin
    o <= a or b;
end Behavioral;