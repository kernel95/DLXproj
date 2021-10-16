library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.myTypes.all;
use IEEE.numeric_std.all;


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
          address_to_iram: out std_logic_vector(31 downto 0);
          iram_to_dlx: in std_logic_vector(31 downto 0);
        --DRAM Memory signals
          DRAM_in: out std_logic_vector(31 downto 0);
          DRAM_out: in  std_logic_vector(31 downto 0);
        
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
          en_ALU: IN std_logic;
          --Memory
          MemWriteM: in std_logic; --write enable for memory stage
          --Writeback
          MemToRegW: in std_logic --select mux on WB
          );
end component;

--Control Unit Wrapper
component CU_wrapper 
  Port (--INPUT
        clock, reset: in std_logic;
        OPCODE: in std_logic_vector(OP_CODE_SIZE - 1 downto 0);
        FUNC  : in std_logic_vector(FUNC_SIZE - 1 downto 0);
        EqualD: in std_logic;
        FlushE: in std_logic;
        --OUTPUT
        
        --DECODE
        PC_SrcD :   out std_logic;
        Select_ext: out std_logic;
        IsJal:      out std_logic;
        RD1:        out std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
        RD2:        out std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH 
        Comp_control: out std_logic_vector(1 downto 0); -- control which branch to compute
            
        --EXECUTE
        en_ALU:      OUT std_logic;
        ALUcontrolE: OUT std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU
        RegDestE:    OUT std_logic; --select first mux of execute stage
        ALUSrcE:     OUT std_logic; --select second mux of execute stage
           
        --MEMORY
        MemWriteM: out std_logic;
            
        --WB
        RegWriteW: out std_logic;
        MemToRegW: out std_logic;
            
        --TO HAZARD UNIT            FOR THE WRAPPER
        BranchD_H:   OUT std_logic; 
        MemToRegE_H: OUT std_logic;
        RegWriteE_H: OUT std_logic;
        MemToRegM_H: OUT std_logic;
        RegWriteM_H: OUT std_logic;
        RegWriteW_H: OUT std_logic;
        -- FOR RF      
        CALL, RET:   OUT std_logic;
        FILL, SPILL: IN std_logic);
end component;

--Hazard detection unit wrapper
component hazard_detection_unit 
    port(
        -- Input from the DP
        RsD, RtD :  IN std_logic_vector(4 downto 0);
        RsE, RtE :  IN std_logic_vector(4 downto 0);
        WriteRegM : IN std_logic_vector(4 downto 0);
        WriteRegW : IN std_logic_vector(4 downto 0);
        WriteRegE : IN std_logic_vector(4 downto 0);
        -- Input from the CU
        BranchD :   IN std_logic;
        MemToRegE : IN std_logic;
        MemToRegM : IN std_logic;
        RegWriteM : IN std_logic;
        RegWriteW : IN std_logic;
        RegWriteE : IN std_logic;
        -- Forwarding MUX selector
        ForwardAD : OUT std_logic;
        ForwardBD : OUT std_logic;
        ForwardAE : OUT std_logic_vector(1 downto 0);
        ForwardBE : OUT std_logic_vector(1 downto 0);
        -- Pipeline register control signals
        StallF :    OUT std_logic;
        StallD :    OUT std_logic;
        FlushE :    OUT std_logic
    );
end component;

--IRAM <-> DLX signals
signal address_to_iram : std_logic_vector(31 downto 0);
signal iram_to_dlx : std_logic_vector(31 downto 0);

--CU <-> DLX signals
signal clock_CU, reset_CU: std_logic;
signal OPCODE_CU: std_logic_vector(OP_CODE_SIZE - 1 downto 0);
signal FUNC_CU  : std_logic_vector(FUNC_SIZE - 1 downto 0);
signal EqualD_CU: std_logic;
signal FlushE_CU: std_logic;
--DECODE
signal PC_SrcD_CU :     std_logic;
signal Select_ext_CU:   std_logic;
signal IsJal_CU:        std_logic;
signal RD1_CU:          std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
signal RD2_CU:          std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH 
signal Comp_control_CU: std_logic_vector(1 downto 0); -- control which branch to compute
--EXECUTE
signal ALUcontrolE_CU:  std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU
signal RegDestE_CU:     std_logic; --select first mux of execute stage
signal ALUSrcE_CU:      std_logic; --select second mux of execute stage
signal en_ALU_CU:       std_logic;
 --MEMORY
signal MemWriteM_CU:    std_logic;
--WB
signal RegWriteW_CU:    std_logic;
signal MemToRegW_CU:    std_logic;
--TO HAZARD UNIT 
signal BranchD_H_CU:    std_logic; 
signal MemToRegE_H_CU:  std_logic;
signal RegWriteE_H_CU:  std_logic;
signal MemToRegM_H_CU:  std_logic;
signal RegWriteM_H_CU:  std_logic;
signal RegWriteW_H_CU:  std_logic;
--FOR RF          
signal CALL_CU, RET_CU:   std_logic;
signal FILL_CU, SPILL_CU: std_logic;

signal OPCODE_addr_CU: std_logic_vector(OP_CODE_SIZE - 1 downto 0);
signal FUNC_addr_CU  : std_logic_vector(FUNC_SIZE - 1 downto 0);

--DP <-> DLX signals
--IRAM Memory signals
--DRAM Memory signals
signal DRAM_in_DP, DRAM_out_DP: std_logic_vector(31 downto 0);

--HAZARD UNIT SIGNALS
--Fetch
signal StallF_DP, StallD_DP: std_logic;
--DECODE
signal ForwardAD_DP, ForwardBD_DP, FlushE_DP, rst_RF_DP, en_RF_DP: std_logic;
signal RsD_H_DP, RtD_H_DP: std_logic_vector(4 downto 0);
--EXECUTE
signal ForwardAE_DP, ForwardBE_DP: std_logic_vector(1 downto 0);         
signal WriteRegE_H_DP, RsE_H_DP, RtE_H_DP :  std_logic_vector(4 downto 0);
--MEMORY
signal WriteRegMOut_H_DP: std_logic_vector(4 downto 0);          
signal rst_mem_DP: std_logic;          
--WB
signal WriteRegWBOut_H_DP: std_logic_vector(4 downto 0);                    

--CU
signal OP_DP: std_logic_vector (5 downto 0);
signal FUNC_DP: std_logic_vector(10 downto 0);
signal EqualD_DP: std_logic;
signal FILL_DP, SPILL_DP: std_logic; --signals for Register File fill and spill form/to memory
--Control Unit IN
--Fetch
signal PCSrcD_DP:  std_logic; --feed mux for PC and CLR REG between fetch and decode
--Decode
signal RegWriteW_DP:  std_logic; -- from writeback, enables RF for DATA_IN
signal Select_ext_DP:  std_logic; --additional signal to control sign extend
signal CALL_DP, RET_DP:  std_logic; --signals for Register File call and ret
signal RD1_EN_DP, RD2_EN_DP : std_logic; --Read enable
signal isJal_DP    :  std_logic; --OP is jal
signal Comp_control_DP : std_logic_vector(1 downto 0);
--Execute          
signal RegDstE_DP:  std_Logic; -- select for mux on execute for writing destination reg
signal ALUSrcE_DP:  std_logic; --select between immediate or operand 
signal ALUControlE_DP:  std_logic_vector (5 downto 0); --decode for ALU       
--Memory
signal MemWriteM_DP:  std_logic; --write enable for memory stage
--Writeback
signal MemToRegW_DP:  std_logic; --select mux on WB 

begin

iram : instruction_ram generic map (nwords, isize) port map (address_to_iram, iram_to_dlx, rst);

Control_unit: CU_wrapper port map (clock => clk,
                                   reset => rst,
                                   OPCODE => OP_DP,
                                   FUNC => FUNC_DP,
                                   EqualD => EqualD_DP,
                                   FlushE => FlushE_DP,
                                   
                                   Pc_SrcD => Pc_SrcD_CU,
                                   Select_ext => Select_ext_CU,
                                   isJal => isJal_CU,
                                   RD1 => RD1_CU,
                                   RD2 => RD2_CU,
                                   Comp_control => Comp_control_CU,
                                   
                                   en_ALU      => en_ALU_CU,
                                   ALUControlE => ALUControlE_CU,
                                   RegDestE => RegDestE_CU,
                                   ALUSrcE => ALUSrcE_CU,
                                   
                                   MemWriteM => MemWriteM_CU,
                                   
                                   RegWriteW => RegWriteW_CU,
                                   MemToRegW => MemToRegW_CU,
                                   
                                   BranchD_H => BranchD_H_CU,
                                   MemToRegE_H => MemToRegE_H_CU,
                                   RegWriteE_H => RegWriteE_H_CU,
                                   MemToRegM_H => MemToRegM_H_CU,
                                   RegWriteM_H => RegWriteM_H_CU,
                                   RegWriteW_H => RegWriteW_H_CU,
                                   
                                   CALL => CALL_CU, RET => RET_CU,
                                   FILL => FILL_CU, SPILL => SPILL_CU                       
                                   );
                                   
DataPath: DataPath_wrapper port map (clk => clk,
                                     rst => rst,
                                     address_to_iram => address_to_iram,
                                     iram_to_dlx => iram_to_dlx,
                                     DRAM_in => DRAM_in_DP,
                                     DRAM_out => DRAM_out_DP,
                                     
                                     StallF => StallF_DP,
                                     StallD => StallD_DP,
                                     
                                     ForwardAD => ForwardAD_DP,
                                     ForwardBD => ForwardBD_DP,
                                     FlushE => FlushE_DP,
                                     rst_RF => rst,
                                     en_RF => '1',
                                     
                                     RsD_H => RsD_H_DP,
                                     RtD_H => RtD_H_DP,
                                     
                                     ForwardAE => ForwardAE_DP,
                                     ForwardBE => ForwardBE_DP,
                                     WriteRegE_H => WriteRegE_H_DP,
                                     RsE_H => RsE_H_DP,
                                     RtE_H => RtE_H_DP,
                                     
                                     WriteRegMOut_H => WriteRegMOut_H_DP,
                                     rst_mem => rst,
                                     
                                     WriteRegWBOut_H => WriteRegWBOut_H_DP,
                                     
                                     OP => OP_DP,
                                     FUNC => FUNC_DP,
                                     EqualD => EqualD_DP,
                                     FILL => FILL_DP,
                                     SPILL => SPILL_DP,
                                     
                                     PCSrcD => PC_SrcD_CU,
                                     
                                     RegWriteW => RegWriteW_CU,
                                     Select_ext => Select_ext_CU,
                                     CALL => CALL_CU, RET => RET_CU,
                                     RD1_EN => RD1_CU, RD2_EN => RD2_CU,
                                     isJal => isJal_CU,
                                     Comp_control => Comp_control_CU,
                                     
                                     RegDstE => RegDestE_CU,
                                     ALUSrcE => ALUSrcE_CU,
                                     ALUControlE => ALUControlE_CU,
                                     en_ALU      => en_ALU_CU,
                                     
                                     MemWriteM => MemWriteM_CU,
                                     MemToRegW => MemToRegW_CU);
                                     
HazardUnit: hazard_detection_unit port map ( 
                        RsD => RsD_H_DP,
                        RtD => RtD_H_DP,
                        RsE => RsE_H_DP,
                        RtE => RtE_H_DP,
                        WriteRegM => WriteRegMOut_H_DP, 
                        WriteRegW => WriteRegWBOut_H_DP,
                        WriteRegE => WriteRegE_H_DP,
                        BranchD => BranchD_H_CU,
                        MemToRegE => MemToRegE_H_CU,
                        MemToRegM => MemToRegM_H_CU,
                        RegWriteM => RegWriteM_H_CU,
                        RegWriteW => RegWriteW_H_CU,
                        RegWriteE => RegWriteE_H_CU,
                        ForwardAD => ForwardAD_DP,
                        ForwardBD => ForwardBD_DP,
                        ForwardAE => ForwardAE_DP,
                        ForwardBE => ForwardBE_DP,
                        StallF => StallF_DP,
                        StallD => StallD_DP,
                        FlushE => FlushE_DP
                        );                                     

end Behavioral;
