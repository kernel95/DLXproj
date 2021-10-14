library ieee;
use ieee.std_logic_1164.all;

entity ALU_decoder is
	port(s5,s4,s3,s2,s1,s0: IN std_logic; --signal coming from control unit
		 en_mult,en_comp,en_Shift,en_Adder,en_Logic: OUT std_logic); --decoder will enable the respective block for the operation needed
end ALU_decoder;

architecture ALU_decoder_beh of ALU_decoder is
begin
	
	process(s5,s4,s3,s2,s1,s0)
	begin
		en_logic <= (not(s5) AND not(s4));             --remember to include our LUT in the Report for this specification
		en_adder <= ((NOT s5) AND s4);
		en_shift <= (s5 AND (NOT s4));
		en_comp  <= (s5 AND s4 AND (NOT s3));
		en_mult  <= (s5 AND s4 AND s3);
	end process;

end ALU_decoder_beh;