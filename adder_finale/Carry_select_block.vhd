library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity CSB is
  generic (NBIT : integer := 16);
  port(op1, op2: IN std_logic_vector(NBIT-1 downto 0);
       CarryIn: IN std_logic;
       Sum: OUT std_logic_vector(NBIT-1 downto 0);
       CarryOut, overflow: OUT std_logic);
end CSB;

architecture Structural of CSB is

    component RCA
    Generic(N : Integer := 16);
    Port (A,B:  IN std_logic_vector(N-1 downto 0);
          CarryIn:   IN std_logic;
          S:   OUT std_logic_vector(N-1 downto 0);
          CarryOut, overflow:  OUT std_logic);
    end component;

    signal ovf, cout: std_logic_vector(1 downto 0);
    signal sumsig: std_logic_vector(2*NBIT-1 downto 0);

    begin
        adders: for i in 0 to 1 generate
            RipplecCA: rca generic map (NBIT) 
                        port map (A => op1,
                                  B => op2,
                                  CarryIn =>std_logic(to_unsigned(i, 1)(0)), 
                                  S => sumsig((i+1) * NBIT-1 downto i * NBIT),
                                  CarryOut => cout(i), 
                                  overflow => ovf(i));
        end generate adders;

        --select the right sum with the guessed carry in
        sum <= sumsig(NBIT-1 downto 0) when CarryIn = '0' else
               sumsig(2*NBIT-1 downto NBIT) when CarryIn = '1';
        -- set the right carry out
        CarryOut <= cout(0) when carryIn = '0' else
                    cout(1) when carryIn = '1';
        -- set if overflow happened 
        overflow <= ovf(0) when carryIn = '0' else
                    ovf(1) when carryIn = '1';

end Structural;