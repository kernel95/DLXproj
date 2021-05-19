library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_generic is
    generic(nbit : integer := 32);
    port( d: in std_logic_vector(nbit-1 downto 0);
          q: out std_logic_vector(nbit-1 downto 0);
          clk, reset, en : in std_logic);
end register_generic;

architecture Behavioral of register_generic is
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            q <= (others=>'0');
        elsif (clk='1' and clk'event and en='1') then
            q <= d;
        end if;
    end process;

end Behavioral;
