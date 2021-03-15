----------------------------------------------------------------------------------
-- Create Date: 11.03.2021
-- Module Name: half-adder
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: and gate 2 inputs
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and2 is
    port(a, b:  IN std_logic;
            o: OUT std_logic);
end and2;

architecture Behavioral of and2 is
begin
    o <= a and b; 
end Behavioral;
