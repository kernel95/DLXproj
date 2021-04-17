library ieee;
use ieee.std_logic_1164.all;

entity pg_net is
	generic(nbit: integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 p, g: OUT std_logic_vector(nbit-1 downto 0));
end pg_net;

architecture pg_net_arc of pg_net is
begin

	p <= op1 xor op2;
	g <= op1 and op2;

end pg_net_arc;