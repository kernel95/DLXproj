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
    generic(n_bit: integer := 32);
    port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        carry_in: in std_logic;
        sum: out std_logic_vector(n_bit - 1 downto 0);
        carry_out, overflow: out std_logic);
end component;

component MUX21 is
    generic(N: integer := 16);
    port (a,b: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic;
          y:  OUT std_logic_vector(N-1 downto 0));
end component;

signal sum_out: std_logic_vector(nbit-1 downto 0);
signal op2_mux: std_logic_vector(nbit-1 downto 0);
signal op2_negated: std_logic_vector(nbit-1 downto 0);

begin
    
    op2_negated <= not(op2);

    mux_operand2: MUX21 generic map(nbit)
                           port map(op2, op2_negated, carryIn, op2_mux);   

    sparse_adder: sparse_tree_adder generic map (nbit)
                                       port map (op1, op2_mux, CarryIn, Sum_out, CarryOut, overflow);
    
    
    
    sum <= sum_out when en_adder = '1' else
           (others =>'0');

end Behavioral;