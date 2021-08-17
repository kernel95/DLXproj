----------------------------------------------------------------------------------
-- Create Date: 11.03.2021
-- Module Name: full-adder
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: component for the rca of the multiplier (Booth algorithm)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fa is
    port( a, b, ci:  IN std_logic;
             co, s: OUT std_logic);
end fa;

architecture Structural of fa is

component and2 
    port(a, b:  IN std_logic;
            o: OUT std_logic);
end component;

component xor2 
    port (a, b:  IN std_logic;
             o: OUT std_logic);
end component;

component or2 
    port( a, b:  IN std_logic;
             o: OUT std_logic);
end component;

signal s1, s2, s3: std_logic;

begin
    xor_1: xor2 port map(a, b, s1);
    xor_2: xor2 port map(s1, ci, s);
    and_1: and2 port map(a, b, s2);
    and_2: and2 port map(s1, ci, s3);
     or_1:  or2 port map(s2, s3, co);
end Structural;