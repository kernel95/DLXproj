----------------------------------------------------------------------------------
-- Create Date: 16.08.2021
-- Module Name: shift_by_two
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shift_by_two is
    Port (SignImmD: in std_logic_vector(31 downto 0);
          shifted_out: out std_logic_vector(31 downto 0));
end shift_by_two;

architecture df of shift_by_two is
begin

    shifted_out <= SignImmD(31 downto 2) & "00"; --just 2 bit shifted left

end df;
