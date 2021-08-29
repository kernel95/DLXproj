----------------------------------------------------------------------------------
-- Create Date: 16.08.2021
-- Module Name: OR GATE
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR_GATE is
	port(x, y: IN std_logic;
		 z: OUT std_logic);
end OR_GATE;

architecture DF of OR_GATE is
begin

	z <= (X) OR (Y);

end DF;