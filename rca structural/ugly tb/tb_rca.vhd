----------------------------------------------------------------------------------
-- Create Date: 11.03.2021
-- Module Name: rca_signed - testbench
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: component for the multiplier (Booth algorithm)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_rca is
end tb_rca;

architecture Behavioral of tb_rca is
    constant n : integer := 16;
	
	component rca_signed is
    generic(NBIT: integer := 32);
    port   ( a, b: IN  std_logic_vector(NBIT-1 downto 0);
                c: OUT std_logic;
                s: OUT std_logic_vector(NBIT-1 downto 0));
    end component;
	
	signal a_s, b_s, y_s : std_logic_vector(n-1 downto 0);
	signal c_s : std_logic;
    
    begin	
	   d1: rca_signed generic map (n) port map (a => a_s, b => b_s, c => c_s, s => y_s);
	
    	a_s <= "1111111111111101", "0000000000000011" after 10 ns, "0000000000000001" after 20 ns;
    	b_s <= "1111111111111110", "0000000000000010" after 10 ns, "1111111111111101" after 20 ns;
    	
end Behavioral;
