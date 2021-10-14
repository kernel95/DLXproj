library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity data_ram is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( addr: in std_logic_vector(isize-1 downto 0);
          din: in std_logic_vector(isize-1 downto 0);
          dout: out std_logic_vector(isize-1 downto 0);
          rst, clk, we : in std_logic);
end data_ram;

architecture Behavioral of data_ram is
    type ram_type is array (0 to nwords - 1) of std_logic_vector(isize - 1 downto 0);
    signal dram_memory : ram_type;
begin
    -- Runtime
    dout <= dram_memory(to_integer(unsigned(addr(isize-1 downto 2)))) when (addr(isize-1 downto 2) < std_logic_vector(to_unsigned(nwords, 32))) else x"00000000" ;
    
     -- At reset, load the memory from a file
    mem_p: process(rst,clk)
        variable tmp_data_u : std_logic_vector(isize-1 downto 0);
    begin
        if(rst='1') then
            dram_memory <= (others=>(others=>'0'));
        elsif(clk='1' and clk'event) then
            if(we = '1') then
                dram_memory(to_integer(unsigned(addr(isize-3 downto 2)))) <= din;
            end if;
        end if;
    end process mem_p;
end Behavioral;
