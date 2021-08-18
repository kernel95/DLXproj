library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_unit is
    generic (nbit : integer := 32;
             nwords : integer := 64);
    port (ALUOutMIn, WriteDataM: in std_logic_vector(nbit-1 downto 0);
          ReadDataM, ALUOutMOut : out std_logic_vector(nbit-1 downto 0);
          WriteRegMIn : in std_logic_vector(4 downto 0);
          WriteRegMOut : out std_logic_vector(4 downto 0);
          clk, rst, MemWriteM : in std_logic);
end memory_unit;

architecture Structural of memory_unit is

component data_ram is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( addr: in std_logic_vector(isize-1 downto 0);
          din: in std_logic_vector(isize-1 downto 0);
          dout: out std_logic_vector(isize-1 downto 0);
          rst, clk, we : in std_logic);
end component;

begin

ALUOutMOut <= ALUOutMIn;    -- ALUOutMIn used by dram but is also pipelined and sent back to the Fetch Unit
WriteRegMOut <= WriteRegMIn;-- WriteRegM is pipelined, but is also used by the Hazard Unit

dram : data_ram generic map (nwords, nbit)
                port map (ALUOutMIn, WriteDataM, ReadDataM, rst, clk, MemWriteM);


end Structural;
