----------------------------------------------------------------------------------
-- Create Date: 16.05.2021
-- Module Name: mul wrapper 
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: wrapper for the multiplier (Booth algorithm)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mul_wrapper is
	generic( NBIT: integer := 32;
              N: integer := 16;
              M: integer := 16);
  port   (a: IN  std_logic_vector(N-1 downto 0);
          b: IN  std_logic_vector(M-1 downto 0);
         en: IN  std_logic;
        mul: OUT std_logic_vector(NBIT-1 downto 0));
end mul_wrapper;

architecture specification of mul_wrapper is

component boothmul 
  generic( NBIT: integer := 32;
              N: integer := 16;
              M: integer := 16);
  port   (a: IN  std_logic_vector(N-1 downto 0);
          b: IN  std_logic_vector(M-1 downto 0);
        mul: OUT std_logic_vector(NBIT-1 downto 0));
end component;

signal mul_out: std_logic_vector(NBIT-1 downto 0);

begin

	mult: boothmul generic map (NBIT)
					  port map (a, b, mul_out);

	mul <= mul_out when en = '1' else
		   (others => '0');

end specification;
