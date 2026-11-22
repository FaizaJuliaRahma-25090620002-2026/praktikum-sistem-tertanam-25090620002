library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Prosedur 3: tampilkan scan code PS/2 (hex) pada seven-segment
-- Digit kanan (1:0) = byte terbaru, digit kiri (3:2) = byte sebelumnya
entity js12_top is
    Port ( clk     : in  STD_LOGIC;
           PS2Clk  : in  STD_LOGIC;
           PS2Data : in  STD_LOGIC;
           seg     : out STD_LOGIC_VECTOR (6 downto 0);
           an      : out STD_LOGIC_VECTOR (3 downto 0);
           dp      : out STD_LOGIC;
           led     : out STD_LOGIC_VECTOR (7 downto 0) );
end js12_top;

architecture Behavioral of js12_top is
    signal scan_code  : STD_LOGIC_VECTOR (7 downto 0);
    signal data_ready : STD_LOGIC;
    signal code_cur   : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal code_prev  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal disp_val   : STD_LOGIC_VECTOR (15 downto 0);
begin
    u_rx : entity work.ps2_receiver
        port map (clk => clk, ps2_clk => PS2Clk, ps2_data => PS2Data,
                  scan_code => scan_code, data_ready => data_ready);

    process(clk)
    begin
        if rising_edge(clk) then
            if data_ready = '1' then
                code_prev <= code_cur;
                code_cur  <= scan_code;
            end if;
        end if;
    end process;

    disp_val <= code_prev & code_cur;

    u_seg : entity work.seg7_driver
        port map (clk => clk, value => disp_val, seg => seg, an => an, dp => dp);

    led <= code_cur;
end Behavioral;
