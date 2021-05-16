library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ALU is
end tb_ALU;

architecture Behavioral of tb_ALU is

constant nbit : integer := 32;

component ALU is
	generic(NBIT : integer := 32);
	port(op1, op2: IN std_logic_vector(NBIT-1 downto 0);
		 sel: IN std_logic_vector(5 downto 0);
		 result: OUT std_logic_vector(NBIT-1 downto 0);
		 CarryOut, overflow: OUT std_logic);
end component;

signal op1_s, op2_s, result_s: std_logic_vector(nbit-1 downto 0);
signal sel_s: std_logic_vector(5 downto 0);
signal carryout_s, overflow_s: std_logic;

begin

ALU_DUT: ALU generic map (nbit)
                port map (op1_s, op2_s, sel_s, result_s, carryout_s, overflow_s);
                
process
begin

    sel_s <= "001000";
    op1_s <= x"00000000";
    op2_s <= x"00000000";
    
    wait for 10 ns;
    
    --LOGIC OPERATIONS
    --AND 
    op1_s <= x"000000FF";
    op2_s <= x"00000000";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore AND" ; 
    
    --OR
    sel_s <= "001110";
    wait for 10 ns;
    assert (result_s = x"000000FF") report "errore OR" ; 
    
    --XOR
    sel_s <= "000110";
    wait for 10 ns;
    assert (result_s = x"000000FF") report "errore XOR" ; 

    --NAND
    sel_s <= "000111";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore NAND" ;
    
    --NOR
    sel_s <= "000001";
    wait for 10 ns;
    assert (result_s = x"FFFFFF00") report "errore NOR" ;
    
    --XNOR
    sel_s <= "001001";
    wait for 10 ns;
    assert (result_s = x"FFFFFF00") report "errore XNOR" ;
    
    --ADDER OPERATIONS
    --ADD
    sel_s <= "010000";
    op1_s <= x"00000002";
    op2_s <= x"00000004";
    wait for 10 ns;
    assert (result_s = x"00000006") report "errore ADDER both positive operands" ;
    
    --ADD one op is negative
    sel_s <= "010000";
    op1_s <= x"00000002";
    op2_s <= x"FFFFFFFD"; -- op2= -3
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore ADDER op2 is neg" ;
    
    --SUB
    sel_s <= "010001";
    op1_s <= x"00000004";
    op2_s <= x"00000002";
    wait for 10 ns;
    assert (result_s = x"00000002") report "errore SUB" ;
    
    --SHIFT OPERATIONS
    --SHIFT RIGHT LOGICAL
    sel_s <= "100000";
    op1_s <= x"00000004";
    op2_s <= x"00000002";
    wait for 10 ns;
    assert (result_s = x"00000001") report "errore SRL" ;
    
    --SHIFT LEFT LOGICAL
    sel_s <= "100001";
    op1_s <= x"00000004";
    op2_s <= x"00000002";
    wait for 10 ns;
    assert (result_s = x"00000010") report "errore SLL" ;
    
    --SHIFT RIGHT ARITHMETICAL
    sel_s <= "100010";
    op1_s <= x"FFFFFFF6";
    op2_s <= x"00000002";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFD") report "errore SRA" ;
    
    --SHIFT LEFT ARITHMETICAL
    sel_s <= "100011";
    op1_s <= x"FFFFFFF6";
    op2_s <= x"00000002";
    wait for 10 ns;
    assert (result_s = x"FFFFFFD8") report "errore SLA" ;
    
    
    --COMPARATOR
    --IS ZERO ? true
    sel_s <= "110000";
    op1_s <= x"00000000";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore IS ZERO true" ;
    
    --IS ZERO ? false
    sel_s <= "110000";
    op1_s <= x"00000001";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore IS ZERO false" ;
    
    --IS EQ ? true
    sel_s <= "110001";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore IS EQ true" ;
    
    --IS EQ ? false
    sel_s <= "110001";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff0000";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore IS EQ false" ;
    
    --NOT EQ ? true
    sel_s <= "110010";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff0000";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore NOT EQ true" ;
    
    --NOT EQ ? false
    sel_s <= "110010";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore NOT EQ false" ;
    
    --GE ? true
    sel_s <= "110011";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff0000";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore GE true" ;
    
    --GE ? true (equal)
    sel_s <= "110011";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore GE true (equal)" ;
    
    --GE ? false
    sel_s <= "110011";
    op1_s <= x"00ff0000";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore GE false" ;
    
    --GT ? true
    sel_s <= "110100";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff0000";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore GT true" ;
    
    --GT ? false (equal)
    sel_s <= "110100";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore GT false (equal)" ;
    
    --GT ? false
    sel_s <= "110100";
    op1_s <= x"00ff0000";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore GT false" ;
    
    --LE ? false
    sel_s <= "110101";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff0000";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore LE false" ;
    
    --LE ? true (equal)
    sel_s <= "110101";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore LE true (equal)" ;
    
    --LE ? true
    sel_s <= "110101";
    op1_s <= x"00ff0000";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore LE true" ;
    
    --LT ? false
    sel_s <= "110110";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff0000";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore LT false" ;
    
    --LT ? false (equal)
    sel_s <= "110110";
    op1_s <= x"00ff00ff";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"00000000") report "errore LT false (equal)" ;
    
    --LT ? true
    sel_s <= "110110";
    op1_s <= x"00ff0000";
    op2_s <= x"00ff00ff";
    wait for 10 ns;
    assert (result_s = x"FFFFFFFF") report "errore LT true" ;
    
    --MULTIPLIER
    -- Positive MUL
    sel_s <= "111111";
    op1_s <= x"00000004";
    op2_s <= x"00000004";
    wait for 10 ns;
    assert (result_s = x"00000010") report "errore MUL 4x4" ;
    
    -- Negative MUL
    sel_s <= "111111";
    op1_s <= x"FFFFFFF6";
    op2_s <= x"00000004";
    wait for 10 ns;
    assert (result_s = x"FFFFFFD8") report "errore MUL -10x4" ;
    
    -- Both Negative MUL
    sel_s <= "111111";
    op1_s <= x"FFFFFFF6";
    op2_s <= x"FFFFFFF6";
    wait for 10 ns;
    assert (result_s = x"00000064") report "errore MUL -10x-10" ;
    
    wait;
    end process; 


end Behavioral;
