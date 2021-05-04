library ieee;
use ieee.std_logic_1164.all;

entity MUX81 is
    generic(N: integer := 16);
    port (a,b,c,d,e,f,g,h: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic_vector(2 downto 0);
          y:  OUT std_logic_vector(N-1 downto 0));
end MUX81;

architecture beh of MUX81 is
begin
    mux81:process(a,b,c,d,sel)
    begin
        if(sel = "000") then y <= a;
        elsif (sel = "001") then y <= b;
        elsif (sel = "010") then y <= c;
        elsif (sel = "011") then y <= d;
        elsif (sel = "100") then y <= e;
        elsif (sel = "101") then y <= f;
        elsif (sel = "110") then y <= g;
        else y <= h;
        end if;
    end process mux81;
    
end beh; -- beh
