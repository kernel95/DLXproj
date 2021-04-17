library ieee;
use ieee.std_logic_1164.all;

entity pg_block is
	port (Gik, Pik, Gk1j, Pk1j: IN std_logic;
		  Gij, Pij: OUT std_logic);
end pg_block;

architecture beh_arc of pg_block is
begin
	Pij <= Pik and Pk1j;
	Gik <= Gik or (Pik and Gk1j);
end beh_arc;