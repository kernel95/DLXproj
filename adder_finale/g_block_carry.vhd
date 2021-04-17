library ieee;
use ieee.std_logic_1164.all;

entity g_block_carry is
	port (Gik, Pik, Gk1j, Pk1j, CarryIn: IN std_logic;
		  Gij: OUT std_logic);
end g_block_carry;

architecture g_block_carry_arc of g_block_carry is
begin

	Gij <= Gik or (Pik and (Gk1j or (pk1j and CarryIn)));

end g_block_carry_arc;