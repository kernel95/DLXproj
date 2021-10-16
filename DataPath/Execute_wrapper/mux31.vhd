----------------------------------------------------------------------------------
-- Create Date: 14.08.2021
-- Module Name: mux31
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: part of exec stage of the pipeline of DLX 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux31 is
    generic(N: integer := 16);
    port (a,b,c: IN std_logic_vector(N-1 downto 0);
            sel: IN std_logic_vector(  1 downto 0);
              y: OUT std_logic_vector(N-1 downto 0));
end mux31;

architecture Behavioral of mux31 is
begin

mux3 : process(a,b,c,sel)
       begin
        if(sel = "00") then
            y <= a;
        elsif (sel = "01") then 
            y <= b;
        elsif (sel = "10") then
            y <= c;
        end if;
    end process;
end Behavioral;
