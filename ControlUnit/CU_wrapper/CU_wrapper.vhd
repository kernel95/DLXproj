library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.myTypes.all;

entity CU_wrapper is
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
        ALUcontrolE: OUT std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU
        RegDestE:    OUT std_logic; --select first mux of execute stage
        ALUSrcE:     OUT std_logic; --select second mux of execute stage
        en_ALU:      OUT std_logic;   
        --MEMORY
        MemWriteM: out std_logic;
            
        --WB
        RegWriteW: out std_logic;
        MemToRegW: out std_logic;
            
        --TO HAZARD UNIT            FOR THE WRAPPER
        BranchD_H: OUT std_logic; 
        MemToRegE_H: OUT std_logic;
        RegWriteE_H: OUT std_logic;
        MemToRegM_H: OUT std_logic;
        RegWriteM_H: OUT std_logic;
        RegWriteW_H: OUT std_logic;
        -- FOR RF      
        CALL, RET: OUT std_logic;
        FILL, SPILL: IN std_logic);
            
end CU_wrapper;

architecture Behavioral of CU_wrapper is

component CU 
       port (-- INPUTS
              Rst : in std_logic;   -- Active Low              
              OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);
              -- FETCH
              BranchD    : out std_logic;            -- Sel mux on Program Counter and Clear Pipe Regs between F and D
              --DECODE
              Select_ext: out std_logic; --signal for sign extend 
              IsJal:  OUT std_logic; -- control signal to set muxes to address R31
              RD1:    out std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
              RD2:    out std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH
              RegWriteD:     out std_logic; --ENABLE WRITE PORT OF RF COMING FROM WRITEBACK ---- TO DO IN DATAPATH
              Comp_control: OUT std_logic_vector(1 downto 0); --control signal for comparator that gives to CU the EqualD signal
              --EXECUTE
              en_ALU:   out std_logic;
              RegDestD: OUT std_logic; --select first mux of execute stage
              ALUSrcD: OUT std_logic; --select second mux of execute stage
              ALUcontrolD: OUT std_logic_vector(5 downto 0); -- DECODER SIGNAL ALU
              --MEMORY
              MemWriteD: OUT std_logic; -- ENABLE WRITE PORT OF DATA MEMORY STAGE
              --WB
              MemToRegD: OUT std_logic; -- SEL OF MUX IN WRITEBACK STAGE
              --FOR WINDOW REGISTER
              CALL, RET: OUT std_logic;
              FILL, SPILL: IN std_logic); 
end component;

--PIPELINE REGS
--DECODE
signal RegWriteD_reg,   RegWriteD_regnext:   std_logic;
signal RegDestD_reg,    RegDestD_regnext:    std_logic;
signal ALUSrcD_reg,     ALUSrcD_regnext:     std_logic;
signal ALUcontrolD_reg, ALUcontrolD_regnext: std_logic_vector(5 downto 0);
signal MemWriteD_reg,   MemWriteD_regnext:   std_logic; 
signal MemToRegD_reg,   MemToRegD_regnext:   std_logic;
signal en_ALUD_reg,      en_ALUD_regnext:    std_logic; 
--EXECUTE
signal RegWriteE_reg,   RegWriteE_regnext:   std_logic;
signal MemWriteE_reg,   MemWriteE_regnext:   std_logic;
signal MemToRegE_reg,   MemToRegE_regnext:   std_logic;
--MEMORY
signal RegWriteM_reg,   RegWriteM_regnext:   std_logic;
signal MemToRegM_reg,   MemToRegM_regnext:   std_logic;
--WB

--SIGNALS CU
signal BranchD_CU:        std_logic;
signal IsJal_CU:          std_logic;
signal select_ext_CU:     std_logic;
signal RD1_CU, RD2_CU:    std_logic;
signal Comp_control_CU:   std_logic_vector(1 downto 0);
signal CALL_CU, RET_CU: std_logic;

--signals for HazardUnit
signal RegWriteM_CU : std_logic; 
signal RegWriteW_CU : std_logic;

begin

Control : CU port map (RST => reset, 
                       OPCODE => OPCODE, 
                       FUNC => FUNC, 
                       BranchD => BranchD_CU, 
                       Select_ext => select_ext_CU, 
                       isJal => IsJal_CU, 
                       RD1 => RD1_CU, 
                       RD2 => RD2_CU,
                       RegWriteD => RegWriteD_regnext, 
                       Comp_control => comp_control_CU,
                       en_ALU => en_ALUD_regnext, 
                       RegDestD => RegDestD_regnext,
                       AluSrcD => ALUSrcD_regnext, 
                       ALUControlD => ALUControlD_regnext, 
                       MemWriteD => MemWriteD_regnext,
                       MemToRegD => MemToRegD_regnext, 
                       CALL => CALL_CU , RET => RET_CU, FILL => FILL, SPILL => SPILL);
                             
process(clock, reset)
begin
    if (reset = '1') then
    
        RegWriteD_reg   <= '0';
        RegDestD_reg    <= '0'; 
        ALUSrcD_reg     <= '0';
        ALUcontrolD_reg <= (others => '0');
        MemWriteD_reg   <= '0';
        MemToRegD_reg   <= '0';
        en_ALUD_reg     <= '0';
        
        RegWriteE_reg <= '0';
        MemWriteE_reg <= '0';
        MemToRegE_reg <= '0';
        
        RegWriteM_reg <= '0';
        MemToRegM_reg <= '0';
        
    elsif(FlushE = '1') then
        RegWriteD_reg   <= '0';
        RegDestD_reg    <= '0'; 
        ALUSrcD_reg     <= '0';
        ALUcontrolD_reg <= (others => '0');
        MemWriteD_reg   <= '0';
        MemToRegD_reg   <= '0';
            
    elsif(rising_edge(clock)) then
        RegWriteD_reg   <= RegWriteD_regnext;
        RegDestD_reg    <= RegDestD_regnext;
        ALUSrcD_reg     <= ALUSrcD_regnext;
        ALUcontrolD_reg <= ALUcontrolD_regnext;
        MemWriteD_reg   <= MemWriteD_regnext;
        MemToRegD_reg   <= MemToRegD_regnext;
        en_ALUD_reg     <= en_ALUD_regnext;
        RegWriteE_reg   <= RegWriteE_regnext;
        MemToRegE_reg   <= MemToRegE_regnext;
        MemWriteE_reg   <= MemWriteE_regnext;
        RegWriteM_reg   <= RegWriteM_regnext;
        MemToRegM_reg   <= MemToRegM_regnext;
    end if;
    
end process;
    --DECODE SIGNALS ASSIGNMENT
    PC_SrcD      <= BranchD_CU AND EqualD;
    select_ext   <= select_ext_CU;
    IsJal        <= IsJal_CU;
    RD1          <= RD1_CU;
    RD2          <= RD2_CU;
    Comp_control <= Comp_control_CU;
    CALL <= CALL_CU;
    RET <= RET_CU;
    
    --EXECUTE SIGNALS ASSIGNMENT
    AluControlE  <= ALUcontrolD_reg;
    AluSrcE      <= ALUSrcD_reg;
    RegDestE     <= RegDestD_reg;
    en_ALU       <= en_ALUD_reg;
    MemWriteE_regnext <= MemWriteD_reg;
    RegWriteE_regnext <= RegWriteD_reg;
    MemToRegE_regnext <= MemToRegD_reg;
    
    --MEMORY SIGNALS ASSINMENT
    MemWriteM           <= MemWriteE_reg;
    RegWriteM_CU        <= MemWriteE_reg;
    RegWriteM_regnext   <= RegWriteE_reg;
    MemToRegM_regnext   <= MemToRegE_reg;
    --WB SIGNALS ASSIGNMENT
    RegWriteW    <= RegWriteM_reg;
    RegWriteW_CU <= RegWriteM_reg;
    MemToRegW    <= MemToRegM_reg;
    --HAZARD UNIT
    BranchD_H    <= BranchD_cu; 
    MemToRegE_H  <= MemToRegE_regnext;
    RegWriteE_H  <= RegWriteE_regnext;
    MemToRegM_H  <= RegWriteM_CU;
    RegWriteM_H  <= RegWriteM_regnext;
    RegWriteW_H  <= RegWriteW_CU;
    
end Behavioral;
