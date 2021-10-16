library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_unit is
    generic (nbit : integer := 32;
             nwords : integer := 64);
    port (ALUOutMIn, WriteDataM: in std_logic_vector(nbit-1 downto 0);
          ReadDataM, ALUOutMOut : out std_logic_vector(nbit-1 downto 0);
          address_to_dram : out std_logic_vector(nbit-1 downto 0);
          data_to_dram : out std_logic_vector(nbit-1 downto 0);
          dram_to_dlx : in std_logic_vector(nbit-1 downto 0);
          WriteRegMIn : in std_logic_vector(4 downto 0);
          WriteRegMOut : out std_logic_vector(4 downto 0);
          clk, rst, MemWriteM : in std_logic;
          MemWriteM_out : out std_logic);
end memory_unit;

architecture Structural of memory_unit is



begin

ALUOutMOut <= ALUOutMIn;    -- ALUOutMIn used by dram but is also pipelined and sent back to the Fetch Unit
WriteRegMOut <= WriteRegMIn;-- WriteRegM is pipelined, but is also used by the Hazard Unit

address_to_dram <= ALUOutMIn;
data_to_dram <= WriteDataM;
ReadDataM <= dram_to_dlx;
MemWriteM_out <= MemWriteM;
--dram : data_ram generic map (nwords, nbit)
--                port map (ALUOutMIn, WriteDataM, ReadDataM, rst, clk, MemWriteM);


end Structural;
