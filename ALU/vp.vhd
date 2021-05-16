----------------------------------------------------------------------------------
-- Create Date: 15.03.2021
-- Module Name: vp
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: component for the multiplier (Booth algorithm)
-- the component acts as a mux and is needed to choose between the partial
-- products computed in the shift component
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--unsigned????

entity vp is
  generic(NBIT: integer := 32);
  port(pos_a, neg_a, pos_2a, neg_2a: IN std_logic_vector(NBIT-1 downto 0);
       sel: in std_logic_vector(2 downto 0);
       s_out: out std_logic_vector(NBIT-1 downto 0));
end vp;

architecture behavioral of vp is
  signal output: std_logic_vector(NBIT-1 downto 0);
  begin
    
    process(sel, pos_a, neg_a, pos_2a, neg_2a)
      begin
         if    ( sel = "000") then output <= (others =>'0'); -- 0
         elsif ( sel = "001") then output <= pos_a;          -- a
         elsif ( sel = "010") then output <= pos_a;          -- a
         elsif ( sel = "011") then output <= pos_2a;         -- 2*a
         elsif ( sel = "100") then output <= neg_2a;         -- (-2*a)
         elsif ( sel = "101") then output <= neg_a;          -- (-a)
         elsif ( sel = "110") then output <= neg_a;          -- (-a)
         else output <= (others => '0');                     -- 0
       end if;
     end process; 
  s_out <= output;
end behavioral;
