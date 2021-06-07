library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity dram_tb is
end dram_tb;

architecture tb of dram_tb is

component data_ram is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( addr: in std_logic_vector(isize-1 downto 0);
          din: in std_logic_vector(isize-1 downto 0);
          dout: out std_logic_vector(isize-1 downto 0);
          rst, clk, we : in std_logic);
end component;

signal addr_i, din_i, dout_i : std_logic_vector(31 downto 0);
signal clk_i, rst_i, we_i : std_logic := '0';

begin

dram : data_ram generic map (64, 32) port map (addr_i, din_i, dout_i, rst_i, clk_i, we_i);

ClkProc:process(clk_i)
begin
    clk_i <= not(clk_i) after 0.5 ns;
end process ClkProc;

VectProc:process
variable tmp_din, tmp_addr : std_logic_vector(31 downto 0) := (others=>'0');
begin
    rst_i <= '1'; we_i <= '0';
    addr_i <= X"00000000"; din_i <= X"00000000";
    wait for 1 ns;
    rst_i <= '0';
    wait for 1 ns;
    
    -- Test the Write Enable
    for i in 0 to 63 loop
        we_i <= '0';
        addr_i <= std_logic_vector(to_unsigned(i*4, 32));  -- +4 
        din_i <= std_logic_vector(to_unsigned(i, 32));
        wait for 1 ns;
        assert (dout_i = X"00000000") report "Write enable failure";
    end loop;
    
    addr_i <= X"00000000"; din_i <= X"00000000";
    wait for 1 ns;
    
    -- Test the write
    for i in 0 to 63 loop
        we_i <= '1';
        addr_i <= std_logic_vector(to_unsigned(i*4, 32));  -- +4 at each iteration
        din_i <= std_logic_vector(to_unsigned(i, 32));     -- assign i to the i-th word line
        wait for 1 ns;
        we_i <= '0';
        assert (dout_i = din_i) report "Write data failure";
        wait for 1 ns;
    end loop;
    
    addr_i <= X"00000000"; din_i <= X"00000000";
    wait for 1 ns;
    
    -- Test the read
    for i in 0 to 63 loop
        addr_i <= std_logic_vector(to_unsigned(i*4, 32));  -- +=4 
        wait for 1 ns;
        assert (dout_i = std_logic_vector(to_unsigned(i, 32))) report "Read data failure";
    end loop;
    
    -- Test two consequtive writes
    for i in 0 to 63 loop
        we_i <= '1';
        addr_i <= std_logic_vector(to_unsigned(i*4, 32));  -- +=4 
        din_i <= std_logic_vector(to_unsigned(i + 64, 32));
        wait for 1 ns;
        assert (dout_i = din_i) report "Write data failure";
    end loop;
    
    we_i <= '0';
    
    wait;
end process VectProc;


end tb;
