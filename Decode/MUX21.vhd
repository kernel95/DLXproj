----------------------------------------------------------------------------------
-- Create Date: 16.08.2021
-- Module Name: MUX21
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity MUX21 is
    generic(N: integer := 32);
    port (a,b: IN std_logic_vector(N-1 downto 0); --inputs are RD1 or RD2 and the other input is ALUOUT
          sel: IN std_logic;
          y1:  OUT std_logic_vector(N-1 downto 0));
end MUX21;

architecture beh of MUX21 is
begin
    mux21:process(a,b,sel)
    begin
        if(sel = '0') then
            y <= a;
        else
            y <= b;
        end if;
    end process mux21;
end beh ; -- beh