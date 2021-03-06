library ieee;
use ieee.std_logic_1164.all;

entity g_block_carry is
	port(Gik, Pik, Gk1j, Pk1j, carry_in: in std_logic;
	Gij: out std_logic);
end g_block_carry;

architecture specification of g_block_carry is
begin
    Gij <= Gik or (Pik and (Gk1j or (Pk1j and carry_in)));
end specification;