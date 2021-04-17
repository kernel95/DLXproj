library ieee;
use ieee.std_logic_1164.all;

entity RCA is
    Generic(N : Integer := 16);
    Port (A,B:  IN std_logic_vector(N-1 downto 0);
          CarryIn:   IN std_logic;
          S:   OUT std_logic_vector(N-1 downto 0)
          CarryOut, overflow:  OUT std_logic);
end RCA;

architecture structural of RCA is

component FA
    port(A, B: IN std_logic;
         Ci:   IN std_logic;
         Co:  OUT std_logic;
         S:   OUT std_logic);
end component;

signal Cin: std_logic_vector(N downto 0);

begin

    Cin(0) <= CarryIn;
    CarryOut <= Cin(N);
    overflow <= Cin(N) xor Cin(N-1);


    fulladders: for i in 0 to N-1 generate
        fulladder: fa port map (A(i), B(i), Cin(i),S(i),Cin(i+1));
    end generate;

end structural;