----------------------------------------------------------------------------------
-- Create Date: 29.08.2021
-- Module Name: comparator_addr
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity comparator_addr is
  Port (y1, y2: IN std_logic_vector(31 downto 0);
        comp_control: IN std_logic_vector(1 downto 0); --control signal to decide which jump has to be performed
        EqualD: OUT std_logic);
end comparator_addr;

architecture Behavioral of comparator_addr is

begin
    process(comp_control,y1,y2)
    begin
    
    if(comp_control = "00") then --case you want compare both input
      if (unsigned(y1) = unsigned(y2)) then
        EqualD <= '1';
      else
        EqualD <= '0';
      end if;
    elsif (comp_control = "01") then --case you want to do just J
      EqualD <= '1';
    elsif (comp_control = "10") then --case you want to do BEQZ
      if(unsigned(y1) = 0) then
        EqualD <= '1';
      else
        EqualD <= '0';
      end if; 
    elsif (comp_control = "11") then --case you want to do BNEZ
      if(unsigned(y1) = 0) then
        EqualD <= '0';
      else
        EqualD <= '1';
      end if;
    
    end if;
    end process;
    
end Behavioral;
