library ieee;
use ieee.std_logic_1164.all;

package myTypes is

-- Control unit input sizes
    constant OP_CODE_SIZE : integer :=  6;                                              -- OPCODE field size
    constant FUNC_SIZE    : integer :=  11;                                             -- FUNC field size

    -- R-Type instruction -> OPCODE field
    constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000000";          -- for register-to-register operation

    -- R-Type instruction -> FUNC field
    constant RTYPE_AND : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100100";    -- AND RS1,RS2,RD
    constant RTYPE_OR  : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100101";
    constant RTYPE_XOR : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100110";
    --constant RTYPE_NAND TO ASK
    -- NOR  TO ASK
    -- XNOR TO ASK
    
    constant RTYPE_ADD : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100000";    -- ADD RS1,RS2,RD
    constant RTYPE_SUB : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000100010";    -- SUB RS1,RS2,RD
    
    constant RTYPE_SRL  : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000000110";   -- SRL RS1,RS2,RD
    constant RTYPE_SLL  : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000000100";   -- SLL RS1,RS2,RD
    constant RTYPE_SRA  : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000000111";   -- SRA RS1,RS2,RD
    --constant RTYPE_SLA  REMOVE IT
    
    --constant RTYPE_SEQZ REMOVE IT
    constant RTYPE_SEQ : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101000";   -- SEQ RS1,RS2,RD
    constant RTYPE_SNE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000010101";   -- SNE RS1,RS2,RD
    constant RTYPE_SGE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101101";   -- SGE RS1,RS2,RD
    constant RTYPE_SGT : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101011";   -- SGT RS1,RS2,RD
    constant RTYPE_SLE : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101100";   -- SLE RS1,RS2,RD
    constant RTYPE_SLT : std_logic_vector(FUNC_SIZE - 1 downto 0) :=  "00000101010";   -- SLT RS1,RS2,RD
    
    constant RTYPE_MULT : std_logic_vector(FUNC_SIZE - 1 downto 0) := "00000001110";   -- MULT
    
    
    



-- I-Type instruction -> OPCODE field
    
    constant ITYPE_ANDi  : std_logic_vector(OP_CODE_SIZE - 1 downto 0)  := "001100";  -- ANDI1 RS1,RD,INP1
    constant ITYPE_ORi   : std_logic_vector(OP_CODE_SIZE - 1 downto 0)  := "001101";  -- OR_I1 RS1,RD,INP1
    constant ITYPE_XORi  : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := "001110";   -- XOR_I1 RS1,RD,INP1
    
    constant ITYPE_ADDi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001000";   -- ADDI2 RS1,RD,INP2
    constant ITYPE_SUBi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "001010";   -- SUBI2 RS1,RD,INP2
    
    constant ITYPE_SRLi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010110";   -- SRLi
    constant ITYPE_SLLi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010100";   -- SRLi
    constant ITYPE_SRAi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010111";   -- SRAi
    
    constant ITYPE_SEQi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011000";   -- SEQi 
    constant ITYPE_SNEi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011001";   -- SNEi 
    constant ITYPE_SGEi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011101";   -- SGEi 
    constant ITYPE_SGTi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011011";   -- SGTi 
    constant ITYPE_SLEi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011100";   -- SLEi 
    constant ITYPE_SLTi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "011010";   -- SLTi
    
    --constant RTYPE_MULTi : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := "";   -- MULTi TO ASK
    
    constant ITYPE_LW : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=    "100011";   -- LOAD WORD
    constant ITYPE_SW : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=    "101011";   -- STORE WORD
    
    --NOP
    constant NOP        : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "010101"; -- NOP
    
    --BRANCHES
    constant ITYPE_J : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=     "000010";   -- J
    constant ITYPE_JAL : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=   "000011";   -- JAL
    
    constant ITYPE_BEQZ : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000100";   -- BEQZ
    constant ITYPE_BNEZ : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  "000101";   -- BNEZ
    
end myTypes;
