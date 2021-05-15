library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	generic(NBIT : integer := 32);
	port(op1, op2: IN std_logic_vector(NBIT-1 downto 0);
		 sel: IN std_logic_vector(5 downto 0);
		 result: OUT std_logic_vector(NBIT-1 downto 0);
		 CarryOut, overflow: OUT std_logic);
end ALU;

architecture Specification of ALU is

constant N : integer := 16;
constant M : integer := 16;

component logic_op_unit
	generic(Nbit: integer := 32);
	port (op1, op2: IN std_logic_vector(nbit-1 downto 0);
		  en_logic: IN std_logic;
		  s3,s2,s1,s0: IN std_logic;
		  logic_out: OUT std_logic_vector(nbit-1 downto 0));
end component;

component adder_wrapper
    generic(nbit : integer := 32);
	port(op1, op2: IN std_logic_vector(nbit-1 downto 0);
		 CarryIn:  IN std_logic;
		 sum: OUT std_logic_vector(nbit-1 downto 0);
		 CarryOut, overflow: OUT std_logic;
		 en_adder: IN std_logic);
end component;

component mul_wrapper
    generic( NBIT: integer := 32;
              N: integer := 16;
              M: integer := 16);
    port   (a: IN  std_logic_vector(N-1 downto 0);
            b: IN  std_logic_vector(M-1 downto 0);
           en: IN  std_logic;
          mul: OUT std_logic_vector(NBIT-1 downto 0));
end component;

component zero_comparator is
    generic (N : integer := 32);        --num bits
    port    (A : IN  std_logic_vector(N-1 downto 0);
             B : IN  std_logic_vector(N-1 downto 0);
            en : IN  std_logic;
          cond : IN  std_logic_vector(2 downto 0);
             O : OUT std_logic);
end component;

component shifter_wrapper 
    generic (nbit : integer := 32);
    port (r1, r2: in std_logic_vector(nbit-1 downto 0);
          conf : in std_logic_vector(1 downto 0);               -- 00 srl, 01 sll, 10 sra, 11 sla
          en_shifter : in std_logic;
          shifted_out : out std_logic_vector(nbit-1 downto 0));
end component;

component ALU_decoder
	port(s5,s4,s3,s2,s1,s0: IN std_logic;
		 en_mult,en_comp,en_Shift,en_Adder,en_Logic: OUT std_logic);
end component;

    signal out_logic,out_add,out_mul,out_shift: std_logic_vector(n-1 downto 0);
    signal carry_out_add, overflow_add, out_comp: std_logic;
    signal en_mult, en_comp, en_Shift, en_Adder, en_logic: std_logic;
    
begin

    --ALU DECODER
    decoder: ALU_decoder port map (sel(5), sel(4), sel(3), sel(2), sel(1), sel(0), en_mult, en_comp, en_Shift, en_Adder, en_logic);

    --LOGIC UNIT
	logic_op: logic_op_unit generic map (NBIT)
							   port map (op1, op2, en_logic, sel(3),sel(2),sel(1),sel(0), out_logic);
							   
    --ADDER
    add_sub: adder_wrapper generic map (NBIT)
                              port map (op1, op2, sel(0), out_add, carry_out_add, overflow_add, en_Adder);
    --MULTIPLIER BASED ON BOOTH
    mul:       mul_wrapper generic map (NBIT, N, M)
                              port map (op1, op2, en_mult, out_mul);
    --COMPARATOR                       
    comp:  zero_comparator generic map (NBIT)
                              port map (op1, op2, en_comp, sel(2 downto 0), out_comp);
    --SHIFTER
    shift: shifter_wrapper generic map (NBIT)
                              port map (op1, op2, sel(1 downto 0), en_Shift, out_shift);                          

end Specification;
