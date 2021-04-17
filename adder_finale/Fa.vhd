library ieee;
use ieee.std_logic_1164.all;

entity FA is
  port (A, B: IN std_logic;
        Ci:   IN std_logic;
        Co:  OUT std_logic;
        S:   OUT std_logic;
  );
end FA;

architecture Beh of FA is
begin

    process(A, B, Ci)
    begin
        S <= A xor B xor Ci;
        Co <= (A and B) or (B and Ci) or (A and Ci);
    end process;
    
end Beh;