library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DLX is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( clk, rst : in std_logic
          );
end DLX;

architecture Behavioral of DLX is

--IRAM
component instruction_ram is
    generic (nwords : integer := 64;
             isize  : integer := 32);
    port( addr: in std_logic_vector(isize-1 downto 0);
          dout: out std_logic_vector(isize-1 downto 0);
          rst : in std_logic);
end component;

--Datapath Wrapper
component DataPath_wrapper 
  Port (  clk: IN std_logic;
          rst: IN std_logic;
  
        --IRAM Memory signals
          IRAM_in: IN std_logic_vector(31 downto 0);
          IRAM_out: OUT std_logic_vector(31 downto 0);
        --DRAM Memory signals
          DRAM_in: IN std_logic_vector(31 downto 0);
          DRAM_out: OUT  std_logic_vector(31 downto 0);
        
        --HAZARD UNIT SIGNALS
        --Fetch
          StallF, StallD: IN std_logic;
        --Decode
          ForwardAD, ForwardBD: IN std_logic;
          FlushE: IN std_logic;
          rst_RF: IN std_logic;
          en_RF: IN std_logic;
          
          RsD_H: OUT std_logic_vector(4 downto 0);  --To Hazard Unit
          RtD_H: OUT std_logic_vector(4 downto 0);  --To Hazard Unit
          
        --EXECUTE
          ForwardAE, ForwardBE: IN std_logic_vector(1 downto 0);
          WriteRegE_H: OUT std_logic_vector(4 downto 0);    --To Hazard Unit
          RsE_H: OUT std_logic_vector(4 downto 0);          --To Hazard Unit
          RtE_H: OUT std_logic_vector(4 downto 0);          --To Hazard Unit
          
        --MEMORY
          WriteRegMOut_H: OUT std_logic_vector(4 downto 0); --To Hazard Unit
          rst_mem: IN std_logic; 
          
        --WB
          WriteRegWBOut_H: OUT std_logic_vector(4 downto 0); --To Hazard Unit
          
        --Control Unit OUT
          OP: OUT std_logic_vector (5 downto 0);
          FUNC: OUT std_logic_vector(10 downto 0);
          EqualD: OUT std_logic;
          FILL, SPILL: OUT std_logic; --signals for Register File fill and spill form/to memory
        --Control Unit IN
          --Fetch
          PCSrcD: IN std_logic; --feed mux for PC and CLR REG between fetch and decode
          --Decode
          RegWriteW: IN std_logic; -- from writeback, enables RF for DATA_IN
          Select_ext: IN std_logic; --additional signal to control sign extend
          CALL, RET: IN std_logic; --signals for Register File call and ret
          RD1_EN, RD2_EN : IN std_logic; --Read enable
          isJal    : IN std_logic; --OP is jal
          Comp_control : in std_logic_vector(1 downto 0);
          --Execute
          RegDstE: IN std_Logic; -- select for mux on execute for writing destination reg
          ALUSrcE: IN std_logic; --select between immediate or operand 
          ALUControlE: in std_logic_vector (5 downto 0); --decode for ALU
          --Memory
          MemWriteM: in std_logic; --write enable for memory stage
          --Writeback
          MemToRegW: in std_logic --select mux on WB
          );
end component;

--Control Unit Wrapper
--Hazard detection unit wrapper

--IRAM <-> DLX signals
signal address_to_iram : std_logic_vector(31 downto 0);
signal iram_to_dlx : std_logic_vector(31 downto 0);

begin

iram : instruction_ram generic map (nwords, isize) port map (address_to_iram, iram_to_dlx, rst);



end Behavioral;
