----------------------------------------------------------------------------------
-- Create Date: 11.03.2021
-- Module Name: half-adder
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: component for the rca of the multiplier (Booth algorithm)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port( a, b: IN  std_logic;
         co, s: OUT std_logic);
end half_adder;

architecture Structural of half_adder is

component and2 
    port(a, b:  IN std_logic;
            o: OUT std_logic);
end component;

component xor2 
    port (a, b:  IN std_logic;
             o: OUT std_logic);
end component;

begin
    carry : and2 port map(a, b, co);
    sum   : xor2 port map(a, b, s);
end Structural;
