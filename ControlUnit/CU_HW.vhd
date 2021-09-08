----------------------------------------------------------------------------------
-- Create Date: 23.08.2021
-- Module Name: CONTROL UNIT
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: HARD WIRED VERSION
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity cu is
       
       port (-- INPUTS
                            
              --Clk : in std_logic;
              Rst : in std_logic;   -- Active Low
              
             
              OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);
       
              -- FETCH
              BranchD    : out std_logic;            -- Sel mux on Program Counter and Clear Pipe Regs between F and D
              
              --DECODE
              Select_ext: out std_logic; --signal for sign extend 
              --EqualD: IN std_logic; --WE WILL CONSIDER IT ON WRAPPER WITH PIPELINE
              -----
              ENABLE_RF: out std_logic; -- ENABLE REGISTER FILE --- TO DO IN DATAPATH
              IsJal:  OUT std_logic; -- control signal to set muxes to address R31
              RD1:    out std_logic; -- ENALBE READ PORT 1 OF RF -- TO DO IN DATAPATH
              RD2:    out std_logic; -- ENABLE READ PORT 2 OF RF -- TO DO IN DATAPATH
              RegWriteD:     out std_logic; --ENABLE WRITE PORT OF RF COMING FROM WRITEBACK ---- TO DO IN DATAPATH
              
              
              Comp_control: OUT std_logic_vector(1 downto 0); --control signal for comparator that gives to CU the EqualD signal
              -----
              
              --EXECUTE
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
              
              --TO HAZARD UNIT            FOR THE WRAPPER
              --BranchD_H: OUT std_logic; 
              --MemToRegE_H: OUT std_logic;
              --RegWriteE_H: OUT std_logic;
              --MemToRegM_H: OUT std_logic;
              --RegWriteM_H: OUT std_logic;
              --RegWriteW_H: OUT std_logic);              
end cu;

architecture dlx_cu of cu is
  
  constant MICROCODE_MEM_SIZE : integer := 47; -- number of possible operations
  constant CW_SIZE : integer := 18; -- number of output control signals
  
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := (--R-TYPE IN INCRESING ORDER OF FUNC VALUE
                                "001011101000010000", -- SLL  FUNC 0X04
                                "001011101000000000", -- SRL  FUNC 0X06
                                "001011101000100000", -- SRA  FUNC 0X07
                                ---------------------------------------
                                "001011100100000000", -- ADD  FUNC 0X20
                                "001011100100010000", -- SUB  FUNC 0X22
                                ---------------------------------------
                                "001011100010000000", -- AND  FUNC 0X24
                                "001011100011100000", -- OR   FUNC 0X25
                                "001011100001100000", -- XOR  FUNC 0X26
                                ---------------------------------------
                                "001011101100010000", -- SEQ  FUNC 0X28
                                "001011101100100000", -- SNEQ FUNC 0X29
                                "001011101100110000", -- SGE  FUNC 0X2D
                                "001011101101000000", -- SGT  FUNC 0X2B
                                "001011101101010000", -- SLE  FUNC 0X2C
                                "001011101101100000", -- SLT  FUNC 0X2A
                                ---------------------------------------
                                "001011101111110000", -- MUL TO DO
                                ---------------------------------------
                                "001011100001110000", -- NAND FUNC TO DO 
                                "001011100000010000", -- NOR  FUNC TO DO
                                "001011100010010000", -- XNOR FUNC TO DO
                                
                                --I-TYPE IN INCRESING ORDER OF OPCODE VALUE
                                "110000000000000010", -- J    OPCODE 0X02
                                "111100000000000010", -- JAL  OPCODE 0X03
                                "110011000000000010", -- BEQZ OPCODE 0X04
                                "110011000000000011", -- BNEZ OPCODE 0X05
                                -----------------------------------------
                                "001010010100000000", -- ADDi OPCODE 0X08
                                "001010010100010000", -- SUBi OPCODE 0X0A
                                -----------------------------------------                                
                                "001010010010000000", -- ANDi OPCODE 0X0C
                                "001010010011100000", -- ORi  OPCODE 0X0D
                                "001010010001100000", -- XORi OPCODE 0X0E
                                "001010010001110000", -- NANDi TO DO
                                "001010010000010000", -- NORi  TO DO
                                "001010010010010000", -- XNORi TO DO
                                ------------------------------------------
                                "001010011000010000", -- SLLi OPCODE 0X14
                                ------------------------------------------
                                "000000000000000000", -- NOP  OPCODE 0X15
                                ------------------------------------------
                                "001010011000000000", -- SRLi  OPCODE 0X16
                                "001010011000100000", -- SRAi  OPCODE 0X17
                                "001010011100010000", -- SEQi  OPCODE 0X18
                                "001010011100100000", -- SNEQi OPCODE 0X19
                                "001010011101100000", -- SLTi  OPCODE 0X1A
                                "001010011101000000", -- SGTi  OPCODE 0X1B
                                "001010011101010000", -- SLEi  OPCODE 0X1C
                                "001010011100110000", -- SGEi  OPCODE 0X1D
                                ------------------------------------------
                                "001010010100000100", -- LOAD  OPCODE 0X23
                                "000010010100001000", -- STORE OPCODE 0X2B
                                ------------------------------------------
                                "001010011111110000"); -- MULi TO BE DECIDED
                                
                                
  -- signals
  signal cw : std_logic_vector(CW_SIZE -1 downto 0);
  begin

  process(OPCODE, FUNC, rst)
       begin
        if (rst = '0') then
            cw <= (OTHERS => '0');
        end if;
        
         case conv_integer(unsigned(OPCODE)) is
	        -- case of R type requires analysis of FUNC
		        when 0 => cw <= cw_mem(conv_integer(FUNC)); -- first 17 positions are dedicated for R-TYPE
                when others => cw <= cw_mem(conv_integer(FUNC) + 42); --AFTER 17 all I-TYPE last addr is 0x2A = 42 dec
         end case;
  end process;

end dlx_cu;
