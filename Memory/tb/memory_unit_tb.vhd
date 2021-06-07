library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_unit_tb is
end memory_unit_tb;

architecture tb of memory_unit_tb is

component memory_unit is
    generic (nbit : integer := 32;
             nwords : integer := 64);
    port (ALUOutMIn, WriteDataM : in std_logic_vector(nbit-1 downto 0);
          ReadDataM, ALUOutMOut : out std_logic_vector(nbit-1 downto 0);
          WriteRegMIn : in std_logic_vector(4 downto 0);
          WriteRegMOut : out std_logic_vector(4 downto 0);
          clk, rst, MemWriteM : in std_logic);
end component;

signal ALUOutMIn_s, WriteDataM_s : std_logic_vector(31 downto 0);
signal ReadDataM_s, ALUOutMOut_s : std_logic_vector(31 downto 0);
signal WriteRegMIn_s : std_logic_vector(4 downto 0);
signal WriteRegMOut_s : std_logic_vector(4 downto 0);
signal clk_s, rst_s, MemWriteM_s : std_logic := '0';

begin

mem_u : memory_unit generic map(32, 64) port map(ALUOutMIn_s, WriteDataM_s, ReadDataM_s, ALUOutMOut_s, 
                     WriteRegMIn_s, WriteRegMOut_s, clk_s, rst_s, MemWriteM_s);

ClkProc:process(clk_s)
begin
    clk_s <= not(clk_s) after 0.5 ns;
end process ClkProc;                 

VectProc:process
begin
    ALUOutMIn_s <= X"00000000"; WriteDataM_s <= X"00000000"; WriteRegMIn_s <= "00000";
    rst_s <= '1'; MemWriteM_s <= '0';
    wait for 1 ns;
    
    rst_s <= '0'; MemWriteM_s <= '0';
    wait for 1 ns;
    
    ALUOutMIn_s <= X"00000004"; WriteDataM_s <= X"aaaaaaaa"; WriteRegMIn_s <= "11111";
    MemWriteM_s <= '1';
    wait for 1 ns;
    
    MemWriteM_s <= '0';
    

    wait;
end process VectProc;    
end tb;
