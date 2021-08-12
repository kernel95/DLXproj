library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity writeback_tb is
end writeback_tb;

architecture Behavioral of writeback_tb is

component writeback_unit is
    generic(N: integer := 32);
    port(ReadDataW, ALUOutW : in std_logic_vector(n-1 downto 0);
         WriteRegW : in std_logic_vector(4 downto 0);
         MemToRegW: in std_logic;
         WriteRegW_out : out std_logic_vector(4 downto 0);
         ResultW: out std_logic_vector(n-1 downto 0));
end component;

signal ReadDataW_s, ALUOutW_s : std_logic_vector(31 downto 0);
signal WriteRegW_s : std_logic_vector(4 downto 0);
signal MemToRegW_s:  std_logic;
signal WriteRegW_out_s : std_logic_vector(4 downto 0);
signal ResultW_s : std_logic_vector(31 downto 0);

begin

DUT: writeback_unit generic map (N=>32) port map (ReadDataW_s, ALUOutW_s, WriteRegW_s, MemToRegW_s, WriteRegW_out_s, ResultW_s);

VectProc:process
begin
    ReadDataW_s <= X"AAAAAAAA"; ALUOutW_s <= X"FFFFFFFF";
    WriteRegW_s <= "01010";
    MemToRegW_s <= '0';
    wait for 10 ns;
    assert ResultW_s = X"FFFFFFFF" report "mux1";
    assert WriteRegW_out_s = "01010" report "WriteRegW_out";
    MemToRegW_s <= '1';
    wait for 10 ns;
    assert ResultW_s = X"AAAAAAAA" report "mux2";
    WriteRegW_s <= "11110";
    wait for 10 ns;
    assert WriteRegW_out_s = "11110" report "WriteRegW_out";
    wait;
end process VectProc;

end Behavioral;
