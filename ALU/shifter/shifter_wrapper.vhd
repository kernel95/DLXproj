library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity shifter_wrapper is
    generic (nbit : integer := 32);
    port (r1, r2: in std_logic_vector(nbit-1 downto 0);
          conf : in std_logic_vector(1 downto 0);               -- 00 srl, 01 sll, 10 sra, 11 sla
          en_shifter : in std_logic;
          shifted_out : out std_logic_vector(nbit-1 downto 0));
end shifter_wrapper;

architecture behavioral of shifter_wrapper is

component shifter is
    generic (nbit : integer := 32);
    port (r1, r2: in std_logic_vector(nbit-1 downto 0);
            conf : in std_logic_vector(1 downto 0);               -- 00 srl, 01 sll, 10 sra, 11 sla
            shifted_out : out std_logic_vector(nbit-1 downto 0));
end component;
             
signal shifted_out_i : std_logic_vector(nbit-1 downto 0));

begin

    shifter : shifter_wrapper generic map (nbit) port map (r1, r2, conf, shifted_out_i);

    process(r1, r2, conf, en_shifter, shifted_out)
    begin
        if(en_shifter = '1') then
            shifted_out <= shifted_out_i;
        else
            shifted_out <= (others=>'0');
        end if;
    end process;

end behavioral;