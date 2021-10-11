library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb is
end tb;

architecture tb of tb is

component hazard_detection_unit 
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
end component;

-- Input from the DP
signal RsD_s, RtD_s :   std_logic_vector(4 downto 0);
signal RsE_s, RtE_s :   std_logic_vector(4 downto 0);
signal WriteRegM_s :  std_logic_vector(4 downto 0);
signal WriteRegW_s :  std_logic_vector(4 downto 0);
signal WriteRegE_s :  std_logic_vector(4 downto 0);
-- Input from the CU
signal BranchD_s :    std_logic;
signal MemToRegE_s :  std_logic;
signal MemToRegM_s :  std_logic;
signal RegWriteM_s :  std_logic;
signal RegWriteW_s :  std_logic;
signal RegWriteE_s :  std_logic;
-- Forwarding MUX selector
signal ForwardAD_s :  std_logic;
signal ForwardBD_s :  std_logic;
signal ForwardAE_s :  std_logic_vector(1 downto 0);
signal ForwardBE_s :  std_logic_vector(1 downto 0);
-- Pipeline register control signals
signal StallF_s :     std_logic;
signal StallD_s :     std_logic;
signal FlushE_s :     std_logic;

begin

HDU : hazard_detection_unit port map (RsD_s, RtD_s,RsE_s, RtE_s, WriteRegM_s, WriteRegW_s, WriteRegE_s,
    BranchD_s, MemToRegE_s, MemToRegM_s, RegWriteM_s, RegWriteW_s, RegWriteE_s, 
    ForwardAD_s, ForwardBD_s, ForwardAE_s, ForwardBE_s,
    StallF_s, StallD_s, FlushE_s);
    
VectProc:process
begin
    --Forward RS from Memory to Execute
    RsE_s <= "00001"; WriteRegM_s <= "00001"; RegWriteM_s <= '1';
    wait for 10 ns;
    assert (ForwardAE_s = "10") report "ForwardAE_s = 10";
    
    --Forward RS from Writeback to Execute
    RsE_s <= "00001"; WriteRegM_s <= "00000"; RegWriteM_s <= '0';
                      WriteRegW_s <= "00001"; RegWriteW_s <= '1';
    wait for 10 ns;
    assert (ForwardAE_s = "01") report "ForwardAE_s = 01";
    
    --Normal RS selection in Execute
    RsE_s <= "00001"; WriteRegM_s <= "00000"; RegWriteM_s <= '0';
                      WriteRegW_s <= "00000"; RegWriteW_s <= '0';
    wait for 10 ns;
    assert (ForwardAE_s = "00") report "ForwardAE_s = 00";  
    
    wait for 50 ns;
    
    RsE_s <= "00000";
    --Forward RT from Memory to Execute
    RtE_s <= "00001"; WriteRegM_s <= "00001"; RegWriteM_s <= '1';
    wait for 10 ns;
    assert (ForwardBE_s = "10") report "ForwardBE_s = 10";
    
    --Forward RT from Writeback to Execute
    RtE_s <= "00001"; WriteRegM_s <= "00000"; RegWriteM_s <= '0';
                      WriteRegW_s <= "00001"; RegWriteW_s <= '1';
    wait for 10 ns;
    assert (ForwardBE_s = "01") report "ForwardBE_s = 01";
    
    --Normal RT selection
    RtE_s <= "00001"; WriteRegM_s <= "00000"; RegWriteM_s <= '0';
                      WriteRegW_s <= "00000"; RegWriteW_s <= '0';
    wait for 10 ns;
    assert (ForwardBE_s = "00") report "ForwardBE_s = 00";    
    
    wait for 50 ns;
    
    RtE_s <= "00000";
    --Forward RS from Writeback to Decode
    RsD_s <= "00001"; WriteRegM_s <= "00001"; RegWriteM_s <= '1';
    wait for 10 ns;
    assert (ForwardAD_s = '1') report "ForwardAD_s = 1";
    
    --Normal RS selection in Decode
    RsD_s <= "00001"; WriteRegM_s <= "00000"; RegWriteM_s <= '0';
    wait for 10 ns;
    assert (ForwardAD_s = '0') report "ForwardAD_s = 0";
    
    wait for 50 ns;
    
    RsD_s <= "00000";
    
    --Forward RT from Writeback to Decode
    RtD_s <= "00001"; WriteRegM_s <= "00001"; RegWriteM_s <= '1';
    wait for 10 ns;
    assert (ForwardBD_s = '1') report "ForwardBD_s = 1";
    
    --Normal RT selection in Decode
    RtD_s <= "00001"; WriteRegM_s <= "00000"; RegWriteM_s <= '0';
    wait for 10 ns;
    assert (ForwardBD_s = '0') report "ForwardBD_s = 0";
    
    wait for 50 ns;
    
    RtD_s <= "00000";
    
    --LW stall test
    -- RsE == RtE
    RsE_s <= "00001"; RtE_s <= "00001"; MemToRegE_s <= '1';
    wait for 10 ns;
    assert (StallF_s = '1') report "StallF = 1";
    assert (StallD_s = '1') report "StallD = 1";
    assert (FlushE_s = '1') report "FlushE = 1";
    
    wait for 50 ns;
    
    -- RtD == RtE
    RsE_s <= "00000"; RtE_s <= "00000"; MemToRegE_s <= '1';
    RtD_s <= "00001"; RtE_s <= "00001";
    wait for 10 ns;
    assert (StallF_s = '1') report "StallF = 1";
    assert (StallD_s = '1') report "StallD = 1";
    assert (FlushE_s = '1') report "FlushE = 1";
    
    wait for 50 ns;
    RsE_s <= "00000"; RtE_s <= "00000"; MemToRegE_s <= '0';
    --BranchStall test
    BranchD_s <= '1'; RegWriteE_s<= '1'; WriteRegE_s <= "00001"; RsD_s <= "00001";
    wait for 10 ns;
    assert (StallF_s = '1') report "StallF = 1";
    assert (StallD_s = '1') report "StallD = 1";
    assert (FlushE_s = '1') report "FlushE = 1";
    wait;           
wait;
end process;
end tb;