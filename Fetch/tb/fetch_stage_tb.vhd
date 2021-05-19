library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetch_stage_tb is
end fetch_stage_tb;

architecture tb of fetch_stage_tb is

component fetch_stage_wrapper is
    generic (nbit : integer := 32;
             nwords : integer := 64);
    port (PCBranchD: in std_logic_vector(nbit-1 downto 0);
          PCPlus4F, InstrD : out std_logic_vector(nbit-1 downto 0);
          PCSrcD, StallF, clk, rst : in std_logic);
end component;

signal PCBranchD_s, PCPlus4F_s, InstrD_s : std_logic_vector(31 downto 0); 
signal PCSrcD_s, StallF_s, clk_s, rst_s : std_logic := '0';

begin

fetch_dut : fetch_stage_wrapper generic map (32,64) port map (PCBranchD_s, PCPlus4F_s, InstrD_s, PCSrcD_s, StallF_s, clk_s, rst_s);

ClkProc:process(clk_s)
begin
    clk_s <= not(clk_s) after 5 ns;
end process ClkProc;

VectProc:process
begin
    rst_s <= '1'; PCSrcD_s <= '0'; StallF_s <= '0'; PCBranchD_s <= x"00000000"; 
    wait for 10 ns;
    rst_s <= '0';
    
    wait;
end process VectProc;
end tb;
