----------------------------------------------------------------------------------
-- Create Date: 05.05.2021
-- Module Name: sign extension
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sign_ext is
    port( a: IN  std_logic_vector(31 downto 0);
          s: IN  std_logic;                  -- 0 ->  I  ; 1 -> J  .
          y: OUT std_logic_vector(31 downto 0));
end sign_ext;

architecture Behavioral of sign_ext is

begin

immediate: process (a, s)
           begin
           if    (s = '0' and a(15) = '1') then 
                y <= "1111111111111111" & a(15 downto 0);
           elsif (s = '0' and a(15) = '0') then
                y <= "0000000000000000" & a(15 downto 0);
           elsif (s = '1' and a(25) = '1') then 
                y <= "111111" & a(25 downto 0);
           elsif (s = '1' and a(25) = '0') then
                y <= "000000" & a(25 downto 0);
           end if;
           end process;
                
end Behavioral;
