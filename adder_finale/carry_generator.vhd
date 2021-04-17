library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity carry_generator is
	generic(nbit: integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 CarryIn: IN std_logic;
		 Carry_out: OUT std_logic_vector(nbit/4-1 downto 0));
end carry_generator;

architecture carry_generator_arc of carry_generator is

component pg_net
	generic(nbit: integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 p, g: OUT std_logic_vector(nbit-1 downto 0));
end component;

component pg_block
	port (Gik, Pik, Gk1j, Pk1j: IN std_logic;
		  Gij, Pij: OUT std_logic);
end component;

component g_block
	port(Gik, Pik, Gk1j: IN std_logic;
		 Gij: OUT std_logic);
end component;

component g_block_carry
	port (Gik, Pik, Gk1j, Pk1j, CarryIn: IN std_logic;
		  Gij: OUT std_logic);
end component;

signal p, g: std_logic_vector(nbit-1 downto 0);

constant Nlines : integer := integer(ceil(log2(real(nbit))));
type signal_array is array (0 to Nlines-1) of std_logic_vector(nbit/2-1 downto 0);
signal g_matrix: signal_array;
signal p_matrix: signal_array;

begin

	--pgnetwork level0
	pgentwork0: pg_net generic map (nbit) port map (op1, op2, p, g);

	--level 1
	fgblock1: g_block_carry port map (g(1), 
									  p(1), 
									  g(0), 
									  p(0), 
									  CarryIn, 
									  g_matrix(0)(0));

	pg1: for i in 1 to nbit/2 -1 generate
	pgblock1: pg_block port map (g(2*i+1), 
								 p(2*i+1), 
								 g(2*i), 
								 p(2*i), 
								 g_matrix(0)(i), 
								 p_matrix(0)(i));

	end generate pg1;

	--level 2
	g1: g_block port map (g_matrix(0)(1), 
						  p_matrix(0)(1), 
						  g_matrix(0)(0), 
						  g_matrix(1)(0));

	pg2: for i in 1 to nbit/4-1 generate
		pgblock2: pg_block port map (g_matrix(0)(2*i+1),
									 p_matrix(0)(2*i+1), 
									 g_matrix(0)(2*i), 
									 p_matrix(0)(2*i), 
									 g_matrix(1)(i), 
									 p_matrix(1)(i));
	end generate pg2;

	--otehr levels
	lines: for j in 2 to Nlines-1 generate
		blocks: for k in - to nbit/4 -1 generate
			propagate: if(to_integer(unsigned(std_logic_vector(to_unsigned(4*(k+1) - 1, nbit)) and std_logic_vector(to_unsigned(2**j, nbit)))) = 0) generate

							g_matrix(j)(k) <= g_matrix(j-1)(k);
							p_matrix(j)(k) <= p_matrix(j-1)(k);

			end generate propagate;

		prop_and_gen: if(to_integer(unsigned(std_logic_vector(to_unsigned(4 * (k + 1)  - 1, n_bit)) and std_logic_vector(to_unsigned(2**j, n_bit)))) > 0) generate

			gen: if (4 * (k + 1) > 2**j) and (4 * (k + 1) <= 2**(j + 1)) generate
	               	olgblock: g_block port map (g_matrix(j - 1)(k),
	               								p_matrix(j - 1)(k),
	               								g_matrix(j - 1)(j - 2),
	               								g_matrix(j)(k));

	        end generate gen;

	        prop: if 4 * (k + 1) > 2**(j + 1) generate

	               olpgblock: pg_block port map(g_matrix(j - 1)(k), p_matrix(j - 1)(k), 
	               								g_matrix(j - 1)(2**(j - 2) * (4 * k - 1)/(2**j) - 1), 
	               								p_matrix(j - 1)(2**(j - 2) * (4 * k - 1)/(2**j) - 1),
	                       						g_matrix(j)(k),
	                       						p_matrix(j)(k));

	        	end generate prop;

	    	end generate prop_and_gen;

		end generate blocks;

	end generate lines;

	carry_generated: for j in 0 to nbit/4 - 1 generate
		Carry_out(j) <= g_matrix(Nlines-1)(j);
	end generate carry_generated;

end carry_generator_arc;