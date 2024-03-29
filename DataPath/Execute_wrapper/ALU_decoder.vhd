library ieee;
use ieee.std_logic_1164.all;

entity ALU_decoder is
	port(s5,s4,s3,s2,s1,s0: IN std_logic; --signal coming from control unit
	     en_ALU: IN std_logic;
		 en_mult,en_comp,en_Shift,en_Adder,en_Logic: OUT std_logic); --decoder will enable the respective block for the operation needed
end ALU_decoder;

architecture ALU_decoder_beh of ALU_decoder is
begin
	
	process(s5,s4,s3,s2,s1,s0)
	begin
	    if(en_ALU = '1') then
		  en_logic <= (not(s5) AND not(s4));  
		  en_adder <= ((NOT s5) AND s4);
		  en_shift <= (s5 AND (NOT s4));
		  en_comp  <= (s5 AND s4 AND (NOT s3));
		  en_mult  <= (s5 AND s4 AND s3);
		else
		  en_logic <= '0';
		  en_adder <= '0';
		  en_shift <= '0';
		  en_comp  <= '0';
		  en_mult  <= '0';
	    end if;
	end process;

end ALU_decoder_beh;