library ieee;
use ieee.std_logic_1164.all;

entity logic_op_unit is
	generic(Nbit: integer := 32);
	port (op1, op2: IN std_logic_vector(nbit-1 downto 0);
		  en_logic: IN std_logic;
		  s3,s2,s1,s0: IN std_logic; --operation coding
		  logic_out: OUT std_logic_vector(nbit-1 downto 0));
end logic_op_unit;

architecture logic_op_unit_arc of Logic_op_unit is
begin
	-- F = OP1' * OP2' * S0 + OP1' * OP2 * S1 + OP1 * OP2' * S2 + OP1 * OP2 * S3
	logic_out <= (NOT(op1) AND NOT(op2) AND (others => s0)) OR  --write function F as a comment later
				 (NOT(op1) AND op2 AND (others => s1)) OR
				 (op1 AND NOT(op2) AND (others => s2)) OR
				 (op1 AND op2 AND (others => s3));

end logic_op_unit_arc;