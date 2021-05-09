library ieee;
use ieee.std_logic_1164.all;

entity sparse_tree_adder is
	generic(nbit : integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 CarryIn:  IN std_logic;
		 sum: OUT std_logic_vector(nbit-1 downto 0);
		 CarryOut, overflow: OUT std_logic);
end sparse_tree_adder;

architecture sparse_tree_adder_arc of sparse_tree_adder is

component carry_generator
	generic(nbit: integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 CarryIn: IN std_logic;
		 Carry_out: OUT std_logic_vector(nbit/4-1 downto 0));
end component;

component CSB
	generic (NBIT : integer := 4);
    port(op1, op2: IN std_logic_vector(NBIT-1 downto 0);
       CarryIn: IN std_logic;
       Sum: OUT std_logic_vector(NBIT-1 downto 0);
       CarryOut, overflow: OUT std_logic);
end component;

signal carries: std_logic_vector(nbit/4 downto 0);

begin

	carries(0) <= CarryIn;
	-- on top we have the carry generation part with the sparse tree implemented
	carry_gen: carry_generator generic map(nbit)
							      port map(op1, 
							      		   op2, 
							      		   CarryIn, 
							      		   carries(nbit/4 downto 1));

	-- on the bottom part all the adders with really carries on the input
	adders: for i in 0 to nbit/4-1 generate
		last: if (i=nbit/4-1) generate --4
			adder: CSB generic map (nbit => 4)
						  port map (op1(i*4+3 downto i*4),
						  			op2(I*4+3 downto I*4),
						  			carries(i),
						  			sum(i*4+3 downto i*4),
						  			overflow);
		end generate last;

		other_adders: if(i < nbit/4-1) generate
			adder: CSB generic map (nbit => 4)
						  port map (op1(i*4+3 downto i*4),
						  			op2(I*4+3 downto I*4),
						  			carries(i),
						  			sum(i*4+3 downto i*4));
		end generate other_adders;
	end generate adders;

	CarryOut <= carries(nbit/4);

end sparse_tree_adder_arc;