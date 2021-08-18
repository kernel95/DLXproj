----------------------------------------------------------------------------------
-- Create Date: 16.08.2021
-- Module Name: comparator_addr
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity comparator_addr is
  Port (y1, y2: IN std_logic_vector(31 downto 0);
        EqualD: OUT std_logic);
end comparator_addr;

architecture df of comparator_addr is
signal tmp1,tmp2 : std_logic;
begin
    
    EqualD <= '1' when y1 = y2 else '0';
    
end df;
