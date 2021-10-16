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
              en_ALU: out std_logic;
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
end cu;

architecture dlx_cu of cu is
  
  constant MICROCODE_MEM_SIZE : integer := 90; -- number of possible operations
  constant CW_SIZE : integer := 19; -- number of output control signals
  
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := (--R-TYPE IN INCRESING ORDER OF FUNC VALUE
                                "0000000000000000000", -- FUNC 0x00
                                "0000000000000000000", -- FUNC 0x01
                                "0000000000000000000", -- FUNC 0x02
                                "0000000000000000000", -- FUNC 0x03
                                "0010111011000010000", -- SLL  FUNC 0X04
                                "0000000000000000000", -- FUNC 0x05
                                "0010111011000000000", -- SRL  FUNC 0X06
                                "0010111011000100000", -- SRA  FUNC 0X07
                                "0000000000000000000", -- FUNC 0x08
                                "0000000000000000000", -- FUNC 0x09
                                "0000000000000000000", -- FUNC 0x0A
                                
                                "0000000000000000000", -- FUNC 0x0B
                                "0000000000000000000", -- FUNC 0x0C
                                "0000000000000000000", -- FUNC 0x0D
                                "0010111011111110000", -- MUL FUNC 0X0E
                                "0000000000000000000", -- FUNC 0x0F
                                "0010111010001110000", -- NAND FUNC 0x10 
                                "0010111010000010000", -- NOR  FUNC 0x11
                                "0010111010010010000", -- XNOR FUNC 0x12
                                "0000000000000000000", -- FUNC 0x13
                                "0000000000000000000", -- FUNC 0x14
                                "0000000000000000000", -- FUNC 0x15
                                "0000000000000000000", -- FUNC 0x16
                                "0000000000000000000", -- FUNC 0x17
                                "0000000000000000000", -- FUNC 0x18
                                "0000000000000000000", -- FUNC 0x19
                                "0000000000000000000", -- FUNC 0x1A
                                "0000000000000000000", -- FUNC 0x1B
                                "0000000000000000000", -- FUNC 0x1C
                                "0000000000000000000", -- FUNC 0x1D
                                "0000000000000000000", -- FUNC 0x1E
                                "0000000000000000000", -- FUNC 0x1F
                                ---------------------------------------
                                "0010111010100000000", -- ADD  FUNC 0X20
                                "0000000000000000000", -- FUNC 0x21
                                "0010111010100010000", -- SUB  FUNC 0X22
                                "0000000000000000000", -- FUNC 0x23
                                ---------------------------------------
                                "0010111010010000000", -- AND  FUNC 0X24
                                "0010111010011100000", -- OR   FUNC 0X25
                                "0010111010001100000", -- XOR  FUNC 0X26
                                "0000000000000000000", -- FUNC 0x27
                                ---------------------------------------
                                "0010111011100010000", -- SEQ  FUNC 0X28
                                "0010111011100100000", -- SNEQ FUNC 0X29
                                
                                "0010111011101100000", -- SLT  FUNC 0X2A
                                "0010111011101000000", -- SGT  FUNC 0X2B
                                "0010111011101010000", -- SLE  FUNC 0X2C
                                "0010111011100110000", -- SGE  FUNC 0X2D
                                ---------------------------------------
                                --I-TYPE IN INCRESING ORDER OF OPCODE VALUE
                                "0000000000000000000", -- OPCODE 0x00
                                "0000000000000000000", -- OPCODE 0x01
                                "1100000000000000001", -- J    OPCODE 0X02
                                "1111000000000000001", -- JAL  OPCODE 0X03
                                "1000110000000000010", -- BEQZ OPCODE 0X04
                                "1000110000000000011", -- BNEZ OPCODE 0X05
                                "0000000000000000000", -- OPCODE 0x06
                                "0000000000000000000", -- OPCODE 0x07
                                -----------------------------------------
                                "0010100110100000000", -- ADDi OPCODE 0X08
                                "0000000000000000000", -- OPCODE 0x09
                                "0010100110100010000", -- SUBi OPCODE 0X0A
                                ----------------------------------------- 
                                "0000000000000000000", -- OPCODE 0x0B                               
                                "0010100110010000000", -- ANDi OPCODE 0X0C
                                "0010100110011100000", -- ORi  OPCODE 0X0D
                                "0010100110001100000", -- XORi OPCODE 0X0E
                                "0010100110001110000", -- NANDi OPCODE 0X0F
                                "0010100110000010000", -- NORi  OPCODE 0X10
                                "0010100110010010000", -- XNORi OPCODE 0X11
                                "0000000000000000000", -- OPCODE 0x12
                                "0000000000000000000", -- OPCODE 0x13
                                ------------------------------------------
                                "0010100111000010000", -- SLLi OPCODE 0X14
                                ------------------------------------------
                                "0000000000000000000", -- NOP  OPCODE 0X15
                                ------------------------------------------
                                "0010100111000000000", -- SRLi  OPCODE 0X16
                                "0010100111000100000", -- SRAi  OPCODE 0X17
                                "0010100111100010000", -- SEQi  OPCODE 0X18
                                "0010100111100100000", -- SNEQi OPCODE 0X19
                                "0010100111101100000", -- SLTi  OPCODE 0X1A
                                "0010100111101000000", -- SGTi  OPCODE 0X1B
                                "0010100111101010000", -- SLEi  OPCODE 0X1C
                                "0010100111100110000", -- SGEi  OPCODE 0X1D
                                "0000000000000000000", -- OPCODE 0x1E
                                "0000000000000000000", -- OPCODE 0x1F
                                "0010100111111110000", -- MULi OPCODE 0X20
                                "0000000000000000000", -- OPCODE 0x21
                                "0000000000000000000", -- OPCODE 0x22
                                ------------------------------------------
                                "0010100110100000100", -- LOAD  OPCODE 0X23
                                "0000000000000000000", -- OPCODE 0x24
                                "0000000000000000000", -- OPCODE 0x25
                                "0000000000000000000", -- OPCODE 0x26
                                "0000000000000000000", -- OPCODE 0x27
                                "0000000000000000000", -- OPCODE 0x28
                                "0000000000000000000", -- OPCODE 0x29
                                "0000000000000000000", -- OPCODE 0x2A
                                "0000100100100001000"); -- STORE OPCODE 0X2B
                                ------------------------------------------
                         
  -- signals
  signal cw : std_logic_vector(CW_SIZE -1 downto 0);
  begin

  process(OPCODE, FUNC, rst)
       begin
        if (rst = '1') then
            cw <= (OTHERS => '0');
        else 
            case conv_integer(unsigned(OPCODE)) is
	        -- case of R type requires analysis of FUNC
		        when 0 => cw <= cw_mem(conv_integer(FUNC)); -- first 17 positions are dedicated for R-TYPE
                when others => cw <= cw_mem(conv_integer(OPCODE) + 46); --AFTER 17 all I-TYPE last addr is 0x2A = 42 dec
         end case;
         end if;
  end process;
  
  BranchD       <= CW(CW_SIZE - 1);
  Select_ext    <= CW(CW_SIZE - 2);
  RegWriteD     <= CW(CW_SIZE - 3);
  IsJal         <= CW(CW_SIZE - 4);
  RD1           <= CW(CW_SIZE - 5);
  RD2           <= CW(CW_SIZE - 6);
  RegDestD      <= CW(CW_SIZE - 7);
  ALUSrcD       <= CW(CW_SIZE - 8);
  en_ALU        <= CW(CW_SIZE - 9);
  AluControlD   <= CW(CW_SIZE - 10 downto CW_SIZE - 15);
  MemWriteD     <= CW(CW_SIZE - 16);
  MemToRegD     <= CW(CW_SIZE - 17);
  Comp_control  <= CW(CW_SIZE - 18 downto CW_SIZE - 19);
  
end dlx_cu;
