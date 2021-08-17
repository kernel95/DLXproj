----------------------------------------------------------------------------------
-- Create Date: 15.03.2021
-- Module Name: shift
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: component for the multiplier (Booth algorithm)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- use ieee.std_logic_unsigned.all;

entity shift is
  generic (NBIT: integer := 32;
          SHIFT: integer := 3); -- shift is the second operand of the multiplication. only 3 bits per time 
  port    (a   : IN std_logic_vector((NBIT/2)-1 downto 0); -- first operand of the multiplication
           pos_a, neg_a, pos_2a, neg_2a: OUT std_logic_vector(NBIT-1 downto 0)); -- computed partial products
end shift;

architecture behavioral of shift is

  constant nbit_shift: integer := SHIFT*2;
  signal pos: std_logic_vector(NBIT-1 downto 0);
  signal neg: std_logic_vector(NBIT-1 downto 0);
                                    
  begin  
     process(a)
     
     variable sign_n: std_logic_vector(nbit/2-1 downto 0);

     begin
       
        sign_n := (others => a((nbit/2)-1));
        pos <= sign_n&a;
        neg <= std_logic_vector(0-signed(sign_n&a));

     end process;

     pos_a <= std_logic_vector(signed(pos) sll nbit_shift);
     neg_a <= std_logic_vector(signed(neg) sll nbit_shift);
     pos_2a <= std_logic_vector(signed(pos) sll nbit_shift+1);
     neg_2a <= std_logic_vector(signed(neg) sll nbit_shift+1);

end behavioral;
