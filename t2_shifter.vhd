library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity t2_shifter is
    generic (nbit : integer := 32);
    port (r1, r2: in std_logic_vector(nbit-1 downto 0);
          conf : in std_logic_vector(1 downto 0);               --00 sll, 01 srl, 10 sra, 11 sla
          shifted_out : out std_logic_vector(nbit-1 downto 0));
end t2_shifter;

-- Only 32 bit for now, slightly hardcoded
architecture structural of t2_shifter is

    signal mask00, mask08, mask16, mask24 : std_logic_vector(38 downto 0);
    signal coarse_grain_shift : std_logic_vector(38 downto 0);
    signal fine_grain_shift_sel : std_logic_vector(2 downto 0);

    begin

    level1:process(r1, r2, conf)
    begin
        case conf is
            when "00" =>    mask00 <= r1 & "0000000";
                            mask08 <= r1(23 downto 0) & x"000" & "000";
                            mask16 <= r1(15 downto 0) & x"00000" & "000";
                            mask24 <= r1(7 downto 0) & x"0000000" & "000";

            when "01" =>    mask00 <= "0000000" & r1;
                            mask08 <= x"000" & "000" & r1(31 downto 8);
                            mask16 <= x"00000" & "000" & r1(31 downto 16);
                            mask24 <= x"0000000" & "000" & r1(31 downto 24);

            when "10" =>    mask00 <= (38 downto 32 => r1(31)) & r1;
                            mask08 <= (38 downto 24 => r1(31)) & r1(31 downto 8);
                            mask16 <= (38 downto 16 => r1(31)) & r1(31 downto 16);
                            mask24 <= (38 downto 8 => r1(31)) & r1(31 downto 24);
            
            when "11" =>    mask00 <= r1 & "0000000";
                            mask08 <= r1(31) & r1(23 downto 0) & x"000" & "00";
                            mask16 <= r1(31) & r1(15 downto 0) & x"00000" & "00";
                            mask24 <= r1(31) & r1(7 downto 0) & x"0000000" & "00";
                            
            when others=>   mask00 <= (others=>'0');
                            mask08 <= (others=>'0');                            
                            mask16 <= (others=>'0');
                            mask24 <= (others=>'0');
        end case;
    end process level1;
    
    level2:process(mask00, mask08, mask16, mask24, r2)
    begin
        case r2(4 downto 3) is
            when "00" =>    coarse_grain_shift <= mask00;
            when "01" =>    coarse_grain_shift <= mask08;
            when "10" =>    coarse_grain_shift <= mask16;
            when "11" =>    coarse_grain_shift <= mask24;
            when others =>  coarse_grain_shift <= (others=>'0');
        end case;
    end process level2;

    fine_grain_shift_sel <= r2(2 downto 0) when conf = "00" else
                            not(r2(2 downto 0)) when conf = "01" else
                            not(r2(2 downto 0)) when conf = "10" else
                            r2(2 downto 0) when conf = "11";

    level3:process(coarse_grain_shift, fine_grain_shift_sel)
    begin
        case fine_grain_shift_sel is
            when "000" => shifted_out <= coarse_grain_shift(38 downto 7);
            when "001" => shifted_out <= coarse_grain_shift(37 downto 6);
            when "010" => shifted_out <= coarse_grain_shift(36 downto 5);
            when "011" => shifted_out <= coarse_grain_shift(35 downto 4);
            when "100" => shifted_out <= coarse_grain_shift(34 downto 3);
            when "101" => shifted_out <= coarse_grain_shift(33 downto 2);
            when "110" => shifted_out <= coarse_grain_shift(32 downto 1);
            when "111" => shifted_out <= coarse_grain_shift(31 downto 0);
            when others => shifted_out <= (others=>'0');
        end case;
    end process level3;
end structural;
