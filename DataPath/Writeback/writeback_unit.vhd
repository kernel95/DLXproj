library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity writeback_unit is
    generic(N: integer := 32);
    port(ReadDataW, ALUOutW : in std_logic_vector(n-1 downto 0);
         WriteRegW : in std_logic_vector(4 downto 0);
         MemToRegW: in std_logic;
         WriteRegW_out : out std_logic_vector(4 downto 0);
         ResultW: out std_logic_vector(n-1 downto 0));
end writeback_unit;

architecture Structural of writeback_unit is

component MUX21 is
    generic(N: integer := 16);
    port (a,b: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic;
          y:  OUT std_logic_vector(N-1 downto 0));
end component;

begin

MUX21_1 : MUX21 generic map (N=> N) port map(a=> ALUOutW, b=> ReadDataW, sel=> MemToRegW, y=> ResultW);

WriteRegW_out <= WriteRegW;


end Structural;
