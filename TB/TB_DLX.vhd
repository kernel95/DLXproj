library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.myTypes.all;

entity TB_DLX is
end TB_DLX;

architecture behavioral of TB_DLX is

constant nwords : integer := 64;
constant isize : integer := 32;

constant clk_period : TIME := 10 ns;

component DLX

    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( clk, rst : in std_logic);
    
end component;

signal clk_s, rst_s: std_logic;

begin

DUT : DLX generic map (nwords, isize) port map (clk_s, rst_s);

clkproc: process
begin
    clk_s <= '1';
    wait for (clk_period/2);
    clk_s <= '0';
    wait for (clk_period/2);
end process clkproc;

process
begin
    
    rst_s <= '1';
    
    wait for clk_period;
    
    rst_s <= '0';
    
    wait for clk_period;
    
    wait;
    
end process;

end behavioral;