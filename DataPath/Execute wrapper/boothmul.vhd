----------------------------------------------------------------------------------
-- Create Date: 15.03.2021
-- Module Name: booth multiplier
-- Project Name: DLX
-- Version: 1.0
-- Additional Comments: main entity of the multiplier (Booth algorithm)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity boothmul is
  generic( NBIT: integer := 32;
              N: integer := 16;
              M: integer := 16);
  port   (a: IN  std_logic_vector(N-1 downto 0);
          b: IN  std_logic_vector(M-1 downto 0);
        mul: OUT std_logic_vector(NBIT-1 downto 0));
end boothmul;

architecture structural of boothmul is

  type signalVector is array (((M/2 -1)*2) downto 0) of std_logic_vector(NBIT-1 downto 0);
    -- array type for all the signals we will use. (M/2-1)*2 is the number of rows
    -- signals we need . each signal has nbit bits (32)
  type signVector is array ((M/2)-1 downto 0) of std_logic_vector (NBIT-1 downto 0);
  
  signal b_s : std_logic_vector(M downto 0);
  signal sum_vector: signalVector;
  signal pos_av, neg_av, pos_2av, neg_2av: signVector;
  signal carry_s : std_logic_vector ((M/2)-1 downto 0);

  component shift 
    generic(NBIT: integer := 32;
           SHIFT: integer := 3);
    port   (a : in std_logic_vector((NBIT/2)-1 downto 0);
           pos_a, neg_a, pos_2a, neg_2a: out std_logic_vector(NBIT-1 downto 0));
  end component;

  component vp 
    generic(NBIT: integer := 32);
       port(pos_a, neg_a, pos_2a, neg_2a: in std_logic_vector(NBIT-1 downto 0);
             sel: in std_logic_vector(2 downto 0);
           s_out: out std_logic_vector(NBIT-1 downto 0));
  end component;

  component rca_signed 
    generic(NBIT: integer := 32);
    port   ( a, b: IN  std_logic_vector(NBIT-1 downto 0);
                c: OUT std_logic;
                s: OUT std_logic_vector(NBIT-1 downto 0));
  end component;

  begin
  
    b_s <= b&'0'; -- need an additional bit '0'

    gmul: for i in 0 to (M/2)-1 generate
        f0: if(i=0) generate
            sh0: shift generic map (NBIT, i) 
                       port    map ( a=>a, pos_a => pos_av(0), neg_a => neg_av(0), pos_2a => pos_2av(0), neg_2a => neg_2av(0));
            vp0: vp    generic map (NBIT)    
                       port    map (pos_a => pos_av(0), neg_a => neg_av(0), pos_2a => pos_2av(0), neg_2a => neg_2av(0), sel=> b_s(2 downto 0), s_out => sum_vector(0));
        end generate;
        
        f1: if(i=1) generate
            sh1: shift       generic map (NBIT, i) 
                             port    map (a=>a, pos_a => pos_av(1), neg_a => neg_av(1), pos_2a => pos_2av(1), neg_2a => neg_2av(1));
            vp1: vp          generic map (NBIT)   
                             port    map (pos_a => pos_av(1), neg_a => neg_av(1), pos_2a => pos_2av(1), neg_2a => neg_2av(1), sel=> b_s(4 downto 2), s_out => sum_vector(1));
            sum0: rca_signed generic map (NBIT)
                             port    map (a=> sum_vector(0), b=> sum_vector(1), c => carry_s(i), s=>sum_vector(2));
        end generate;
        
        fn: if(i > 1) generate
            shn: shift       generic map (NBIT, i)
                             port    map (a=>a, pos_a => pos_av(i), neg_a => neg_av(i), pos_2a => pos_2av(i), neg_2a => neg_2av(i));
            vpn: vp          generic map (NBIT)
                             port    map (pos_a => pos_av(i), neg_a => neg_av(i), pos_2a => pos_2av(i), neg_2a => neg_2av(i), sel => b_s((i*2)+2 downto (i*2)), s_out => sum_vector((i*2)-1));
            sumn: rca_signed generic map (NBIT)
                             port    map (a=> sum_vector((i*2)-2), b=> sum_vector((i*2)-1), c => carry_s(i), s=> sum_vector(i*2));
        end generate;
    end generate;
   mul <= sum_vector(M-2);
end structural;