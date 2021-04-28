----------------------------------------------------------------------------------
-- Create Date: 27.04.2021
-- Module Name: zero_comparator
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: comparator to allow jumps 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use WORK.comparator_type.all;

entity zero_comparator is
    generic (N : integer := 32);        --num bits
    port    (A : IN  std_logic_vector(N-1 downto 0);
             B : IN  std_logic_vector(N-1 downto 0);
            en : IN  std_logic;
          cond : IN  TYPE_COMP;
             O : OUT std_logic);
end zero_comparator;

architecture Behavioral of zero_comparator is

begin

compare: process (en, A, B, cond)
         begin
            O <= '0';
            if (en = '1') then
                case cond is
                    when ZERO => 
                        if (unsigned(A) = 0) then 
                            O <= '1';
                        end if;
                    when EQ => 
                        if (A = B) then
                            O <= '1';
                        end if;
                    when NEQ =>
                        if (A /= B) then 
                            O <= '1';
                        end if;
                    when GE => 
                        if (A >= B) then
                             O <= '1';
                        end if;
                    when GT => 
                        if (A > B) then
                             O <= '1';
                        end if;
                    when LE => 
                        if (A <= B) then
                             O <= '1';
                        end if;
                    when LT => 
                        if (A < B) then
                             O <= '1';
                        end if;
                    end case;
               end if;
          end process;
end Behavioral;
