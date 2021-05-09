library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_wrapper is
    generic(nbit : integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 CarryIn:  IN std_logic;
		 sum: OUT std_logic_vector(nbit-1 downto 0);
		 CarryOut, overflow: OUT std_logic;
		 en_adder: IN std_logic);
end adder_wrapper;

architecture Behavioral of adder_wrapper is

component sparse_tree_adder
    generic(nbit : integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 CarryIn:  IN std_logic;
		 sum: OUT std_logic_vector(nbit-1 downto 0);
		 CarryOut, overflow: OUT std_logic);
end component;

signal sum_out: std_logic_vector(nbit-1 downto 0);

begin

    sparse_adder: sparse_tree_adder generic map (nbit)
                                       port map (op1, op2, CarryIn, Sum_out, CarryOut, overflow);
    
    sum <= sum_out when en_adder = '1' else
           (others =>'0');

end Behavioral;
