library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture tb of tb is

component shifter_wrapper is
    generic (nbit : integer := 32);
    port (r1, r2: in std_logic_vector(nbit-1 downto 0);
          conf : in std_logic_vector(1 downto 0);               --00 sll, 01 srl, 10 sra
          en_shifter : in std_logic;
          shifted_out : out std_logic_vector(nbit-1 downto 0));
end component;

signal r1_s, r2_s:  std_logic_vector(31 downto 0);
signal conf_s :  std_logic_vector(1 downto 0);               --00 sll, 01 srl, 10 sra
signal shifted_out_s :  std_logic_vector(31 downto 0);
signal en_shifter_s : std_logic;
    
begin

shifter_dut : shifter_wrapper generic map (nbit=> 32) port map (r1_s, r2_s, conf_s, en_shifter_s, shifted_out_s);

VectProc:process
begin
   --sll
   r1_s <= x"0000000f"; r2_s <= x"00000000"; conf_s <= "01"; en_shifter_s<='0';
   wait for 10 ns;
   
   assert shifted_out_s=x"00000000" report "error: enable";
   
   en_shifter_s<='1';
   wait for 10 ns;
   
   for I in 0 to 31 loop
		r2_s <= std_logic_vector(to_signed(I, 32));
		wait for 10 ns;
		assert (shifted_out_s = std_logic_vector(shift_left(unsigned(r1_s), to_integer(unsigned(r2_s(4 downto 0))))) ) report "error:sll";      --SLL
	end loop;
   
   --srl
   r1_s <= x"f0000000"; r2_s <= x"00000000"; conf_s <= "00";
   wait for 10 ns;
   
   for I in 0 to 31 loop
		r2_s <= std_logic_vector(to_signed(I, 32));
		wait for 10 ns;
		assert (shifted_out_s = std_logic_vector(shift_right(unsigned(r1_s), to_integer(unsigned(r2_s(4 downto 0))))) ) report "error:srl";      
	end loop;

   -- sla
   r1_s <= x"8000000f"; r2_s <= x"00000000"; conf_s <= "11";
   wait for 10 ns;
   for I in 0 to 31 loop
		r2_s <= std_logic_vector(to_signed(I, 32));
		wait for 10 ns;
		assert (shifted_out_s = std_logic_vector(shift_left(signed(r1_s), to_integer(unsigned(r2_s(4 downto 0))))) ) report "error:sla";          
    end loop;
   
   -- sra
   r1_s <= x"8000000f"; r2_s <= x"00000000"; conf_s <= "10";
   wait for 10 ns;
   for I in 0 to 31 loop
		r2_s <= std_logic_vector(to_signed(I, 32));
		wait for 10 ns;
		assert (shifted_out_s = std_logic_vector(shift_right(signed(r1_s), to_integer(unsigned(r2_s(4 downto 0))))) ) report "error:sra";          
    end loop;
    
    wait;
end process VectProc;

end tb;