----------------------------------------------------------------------------------
-- Create Date: 27.04.2021
-- Module Name: zero_comparator
-- Project Name: DLX
-- Version: 2.0 -- removed types
-- Additional Comments: comparator to allow jumps 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity zero_comparator is
    generic (N : integer := 32);        --num bits
    port    (A : IN  std_logic_vector(N-1 downto 0);
             B : IN  std_logic_vector(N-1 downto 0);
            en : IN  std_logic;
          cond : IN  std_logic_vector(2 downto 0);
             O : OUT std_logic);
end zero_comparator;

architecture Behavioral of zero_comparator is

begin

compare: process (en, A, B, cond)
         begin
            O <= '0';
            if (en = '1') then
                case cond is
                    when "000" =>                   -- ZERO
                        if (unsigned(A) = 0) then 
                            O <= '1';
                        end if;
                    when "001" =>                   -- EQ
                        if (A = B) then
                            O <= '1';
                        end if;
                    when "010" =>                   -- NEQ
                        if (A /= B) then 
                            O <= '1';
                        end if;
                    when "011" =>                   -- GE
                        if (A >= B) then
                             O <= '1';
                        end if;
                    when "100" =>                   -- GT
                        if (A > B) then
                             O <= '1';
                        end if;
                    when "101" =>                   -- LE 
                        if (A <= B) then
                             O <= '1';
                        end if;
                    when "110" =>                   -- LT
                        if (A < B) then
                             O <= '1';
                        end if;
                    when others => O <= '0';        -- NOP
                    end case;
               end if;
          end process;
end Behavioral;

