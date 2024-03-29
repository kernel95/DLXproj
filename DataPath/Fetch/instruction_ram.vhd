library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity instruction_ram is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( addr: in std_logic_vector(isize-1 downto 0);
          dout: out std_logic_vector(isize-1 downto 0);
          rst : in std_logic);
end instruction_ram;

architecture Behavioral of instruction_ram is

    type ram_type is array (0 to nwords - 1) of std_logic_vector(isize - 1 downto 0);
    signal iram_memory : ram_type;
begin
    
    -- Runtime
    
    dout <= iram_memory(to_integer(unsigned(addr(isize-1 downto 2)))) when addr(isize-1 downto 2)<std_logic_vector(to_unsigned(nwords, 32)) else x"00000000";
    
    -- At reset, load the memory from a file
    fill_mem_p: process(rst)
        file mem_fp: text;
        variable file_line : line;
        variable index : integer := 0;
        variable tmp_data_u : std_logic_vector(isize-1 downto 0);
    begin
        if(rst='1') then
            iram_memory <= (others=>(others=>'0'));
            file_open(mem_fp, "./Simulation/iram.txt", READ_MODE);
            while(not endfile(mem_fp)) loop
                readline(mem_fp, file_line);
                hread(file_line, tmp_data_u);
                iram_memory(index) <= tmp_data_u;
                index := index + 1;
            end loop;
        end if;
    end process fill_mem_p;

end Behavioral;
