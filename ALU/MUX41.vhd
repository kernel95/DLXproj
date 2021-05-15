library ieee;
use ieee.std_logic_1164.all;

entity MUX41 is
    generic(N: integer := 16);
    port (a,b,c,d: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic_vector(1 downto 0);
          y:  OUT std_logic_vector(N-1 downto 0));
end MUX41;

architecture beh of MUX41 is
begin
    mux41:process(a,b,c,d,sel)
    begin
        if(sel = "00") then y <= a;
        elsif (sel = "01") then y <= b;
        elsif (sel = "10") then y <= c;
        else y <= d;
        end if;
    end process mux41;
    
end beh; -- beh