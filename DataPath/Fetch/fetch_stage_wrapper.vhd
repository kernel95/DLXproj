library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetch_stage_wrapper is
    generic (nbit : integer := 32;
             nwords : integer := 64);
    port (PCBranchD: in std_logic_vector(nbit-1 downto 0);
          PCPlus4F, InstrD : out std_logic_vector(nbit-1 downto 0);
          PCSrcD, StallF, clk, rst : in std_logic);
end fetch_stage_wrapper;

architecture structural of fetch_stage_wrapper is

component adder_genericu is
    generic (nbit: integer := 32);
    port (a, b: in std_logic_vector(nbit-1 downto 0);
          y: out std_logic_vector(nbit-1 downto 0));
end component;

component instruction_ram is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( addr: in std_logic_vector(isize-1 downto 0);
          dout: out std_logic_vector(isize-1 downto 0);
          rst : in std_logic);
end component;

component register_generic is
    generic(nbit : integer := 32);
    port( d: in std_logic_vector(nbit-1 downto 0);
          q: out std_logic_vector(nbit-1 downto 0);
          clk, reset, en : in std_logic);
end component;

component MUX21 is
    generic(N: integer := 16);
    port (a,b: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic;
          y:  OUT std_logic_vector(N-1 downto 0));
end component;

signal PC, PCF, PCPlus4F_i : std_logic_vector(nbit-1 downto 0);
signal PC_en : std_logic;
begin

pc_mux : MUX21 generic map (nbit) port map (PCPlus4F_i, PCBranchD, PCSrcD, PC);

pc_reg : register_generic generic map (nbit) port map (PC, PCF, clk, rst, PC_en);

iram : instruction_ram generic map (nwords, nbit) port map (PCF, InstrD, rst);

PCPlus4Adder : adder_genericu generic map (nbit) port map (PCF, x"00000004", PCPlus4F_i);

PC_en <= not(StallF);
PCPlus4F <= PCPlus4F_i;


end structural;
