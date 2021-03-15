----------------------------------------------------------------------------------
-- Create Date: 11.03.2021
-- Module Name: rca_signed - Structural
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: component for the multiplier (Booth algorithm)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rca_signed is
    generic(NBIT: integer := 32);
    port   ( a, b: IN  std_logic_vector(NBIT-1 downto 0);
                c: OUT std_logic;
                s: OUT std_logic_vector(NBIT-1 downto 0));
end rca_signed;

architecture Structural of rca_signed is

component half_adder 
    port( a, b: IN  std_logic;
         co, s: OUT std_logic);
end component;

component full_adder 
    port( a, b, ci:  IN std_logic;
             co, s: OUT std_logic);
end component;

signal carry_s : std_logic_vector(NBIT-1 downto 0);

begin
    ha: half_adder port map(a(0), b(0), carry_s(0), s(0));
    fn: for i in 1 to NBIT-1 generate
            fa: full_adder port map(a(i), b(i), carry_s(i-1), carry_s(i), s(i));
        end generate;
        c <= carry_s(NBIT-1);
end Structural;
