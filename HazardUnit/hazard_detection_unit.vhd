library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity hazard_detection_unit is
    port(
        -- Input from the DP
        RsD, RtD :  IN std_logic_vector(4 downto 0);
        RsE, RtE :  IN std_logic_vector(4 downto 0);
        WriteRegM : IN std_logic_vector(4 downto 0);
        WriteRegW : IN std_logic_vector(4 downto 0);
        WriteRegE : IN std_logic_vector(4 downto 0);
        -- Input from the CU
        BranchD :   IN std_logic;
        MemToRegE : IN std_logic;
        MemToRegM : IN std_logic;
        RegWriteM : IN std_logic;
        RegWriteW : IN std_logic;
        RegWriteE : IN std_logic;
        -- Forwarding MUX selector
        ForwardAD : OUT std_logic;
        ForwardBD : OUT std_logic;
        ForwardAE : OUT std_logic_vector(1 downto 0);
        ForwardBE : OUT std_logic_vector(1 downto 0);
        -- Pipeline register control signals
        StallF :    OUT std_logic;
        StallD :    OUT std_logic;
        FlushE :    OUT std_logic
    );
end hazard_detection_unit;

architecture behavioral of hazard_detection_unit is

signal LWstall      : std_logic;
signal BranchStall  : std_logic;

begin
    process(RsD, RtD, RsE, RtE, WriteRegM, WriteRegE, WriteRegW, BranchD, MemToRegE, MemToRegM,
	    RegWriteM, RegWriteW, RegWriteE, LWstall, BranchStall)
    begin
    -- Forwarding Rs 
    if((RsE /= "00000") AND (RsE = WriteRegM) AND RegWriteM = '1') then
        ForwardAE <= "10";
    elsif((RsE /= "00000") AND (RsE = WriteRegW) AND RegWriteW = '1') then
        ForwardAE <= "01";
    else
        ForwardAE <= "00";
    end if;
    
    -- Forwarding Rt
    if((RtE /= "00000") AND (RtE = WriteRegM) AND RegWriteM = '1') then
        ForwardBE <= "10";
    elsif((RtE /= "00000") AND (RtE = WriteRegW) AND RegWriteW = '1') then
        ForwardBE <= "01";
    else
        ForwardBE <= "00";
    end if;
    
    if((RsD /= "00000") AND (RsD = WriteRegM) AND (RegWriteM = '1')) then 
        ForwardAD <= '1';
    else
        ForwardAD <= '0';
    end if;

    if((RtD /= "00000") AND (RtD = WriteRegM) AND (RegWriteM = '1')) then
        ForwardBD <= '1';
    else 
        ForwardBD <= '0';
    end if;

    if (((RsE = RtE) OR (RtD = RtE)) AND MemToRegE = '1') then
        LWstall <= '1';
    else
        LWstall <= '0';
    end if;

    --LWstall <= (((RsE = RtE) OR (RtD = RtE)) AND MemToRegE);

    if((BranchD = '1' AND RegWriteE = '1' AND (WriteRegE = RsD OR WriteRegE = RtD)) OR
        (BranchD = '1' AND MemToRegM = '1' AND (WriteRegM = RsD OR WriteRegM = RtD))) then
        BranchStall <= '1';
    else
        BranchStall <= '0';
    end if;


    --StallF <= LWstall OR BranchStall;
    StallF <= '0';
    StallD <= LWstall OR BranchStall;
    --FlushE <= LWstall OR BranchStall;
    FlushE <= '0';
    end process;
   

end behavioral;

