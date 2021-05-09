library ieee;
use ieee.std_logic_1164.all;

entity g_block is
	port(Gik, Pik, Gk1j: IN std_logic;
		 Gij: OUT std_logic);
end g_block;

architecture Beh_arc of g_block is
begin
	Gij <= Gik or (Pik and Gk1j);
end Beh_arc;