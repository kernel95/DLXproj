library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity shifter is
    generic (nbit : integer := 32);
    port (r1, r2: in std_logic_vector(nbit-1 downto 0);
          conf : in std_logic_vector(1 downto 0);               -- 00 srl, 01 sll, 10 sra, 11 sla
          shifted_out : out std_logic_vector(nbit-1 downto 0));
end shifter;

architecture structural of shifter is
    component MUX21 is
    generic(N: integer := 16);
    port (a,b: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic;
          y:  OUT std_logic_vector(N-1 downto 0));
    end component;
    
    component MUX41 is
    generic(N: integer := 16);
    port (a,b,c,d: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic_vector(1 downto 0);
          y:  OUT std_logic_vector(N-1 downto 0));
    end component;
    
    component MUX81 is
    generic(N: integer := 16);
    port (a,b,c,d,e,f,g,h: IN std_logic_vector(N-1 downto 0);
          sel: IN std_logic_vector(2 downto 0);
          y:  OUT std_logic_vector(N-1 downto 0));
    end component;
    
    type first_level_masks_type is array(0 to nbit/8-1) of std_logic_vector(nbit+7 downto 0);
    type second_level_masks_type is array(0 to 7) of std_logic_vector(nbit-1 downto 0);
    
    -- Arrays with the first level mask 
    signal left_first_level, right_first_level, final_first_level : first_level_masks_type;
    -- First level selected mask
    signal final_first_level_mask : std_logic_vector(nbit+7 downto 0);
    -- Array with the various nibbles of the selected mask
    signal second_level : second_level_masks_type;
    -- Selector of the final shifted value
    signal third_level_sel : std_logic_vector(2 downto 0);
    
    begin

    -- Level 1: masks generation 
    level1_masks_generation: for i in 1 to nbit/8 generate
        -- Right masks
        right_first_level(i-1)(nbit+7 downto nbit+8-8*(i)) <= (others => (r1(nbit-1) and conf(1))); -- At first, sign-extend the r1 operand in all the masks
        right_first_level(i-1)(nbit+7-8*(i) downto 0) <= r1(nbit-1 downto 8*(i-1)); -- Assign the shifted value to each mask
        -- Left masks
        left_first_level(i-1)(nbit+7 downto 8*i-1) <= '0' & r1(nbit-8*(i-1)-1 downto 0); -- At first, assign the r1 operand to each mask
        left_first_level(i-1)(8*i-2 downto 0) <= (others => '0'); -- Then insert the '0's on the right nibble to perform the left shift
        --Left/Right selection
        MUX21_i : MUX21 generic map(N=>nbit+8) port map(a=>right_first_level(i-1), b=>left_first_level(i-1), sel=>conf(0), y=>final_first_level(i-1));
    end generate level1_masks_generation;
    
    --Level 2: mask selection (needs a for)
    MUX41_level_2 : MUX41 generic map(N=>nbit+8) port map(a=>final_first_level(0), b=>final_first_level(1), c=>final_first_level(2), d=>final_first_level(3),
        sel=> r2(4 downto 3), y=>final_first_level_mask);
    -- Level 2 mask generation
    level2_masks_generation: for i in 0 to 7 generate
        second_level(i) <= final_first_level_mask(nbit+i-1 downto i);
    end generate level2_masks_generation;    
    
    --Level 3: fine-grain shift (needs a for)
    third_level_sel(2) <= r2(2) xor (conf(0));
    third_level_sel(1) <= r2(1) xor (conf(0));
    third_level_sel(0) <= r2(0) xor (conf(0));
    
    MUX81_level_3: MUX81 generic map(N=>nbit) port map(a=>second_level(0), b=>second_level(1), c=>second_level(2), d=>second_level(3),
        e=>second_level(4), f=>second_level(5), g=>second_level(6), h=>second_level(7), sel=>third_level_sel, y=>shifted_out);

end structural;