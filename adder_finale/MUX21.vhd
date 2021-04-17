library ieee;
use ieee.std_logic_1164.all;

entity MUX21 is
    generic(N: integer := 16);
    port (a,b: IN std_logic_vector(N-1 downto 0)
          sel: IN std_logic;
          y:  OUT std_logic_vector(N-1 downto 0));
end MUX21;

architecture beh of MUX21 is
begin
    process(a,b,sel)
    begin
        if(s = '0') then
            y <= a;
        else
            y <= b;
        end if;
    end process;
end beh ; -- beh