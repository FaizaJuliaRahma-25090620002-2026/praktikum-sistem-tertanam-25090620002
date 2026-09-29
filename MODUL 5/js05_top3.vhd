library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js05_top3 is
    port (
        clk  : in  std_logic;
        btnU : in  std_logic;
        btnD : in  std_logic;
        btnC : in  std_logic;
        sw   : in  std_logic_vector(0 downto 0);

        seg  : out std_logic_vector(6 downto 0);
        dp   : out std_logic;
        an   : out std_logic_vector(3 downto 0)
    );
end js05_top3;

architecture Structural of js05_top3 is

    signal btnU_db     : std_logic;
    signal btnD_db     : std_logic;
    signal btnC_db     : std_logic;

    signal btnU_pulse  : std_logic;
    signal btnD_pulse  : std_logic;

    signal count_value : std_logic_vector(15 downto 0);

    signal pulse_up    : std_logic;
    signal pulse_down  : std_logic;

begin

    debounce_U : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            STABLE_MS   => 20
        )
        port map (
            clk     => clk,
            btn_in  => btnU,
            btn_out => btnU_db
        );

    debounce_D : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            STABLE_MS   => 20
        )
        port map (
            clk     => clk,
            btn_in  => btnD,
            btn_out => btnD_db
        );

    debounce_C : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            STABLE_MS   => 20
        )
        port map (
            clk     => clk,
            btn_in  => btnC,
            btn_out => btnC_db
        );

    edge_U : entity work.edge_detected
        port map (
            clk    => clk,
            sig_in => btnU_db,
            pulse  => btnU_pulse
        );

    edge_D : entity work.edge_detected
        port map (
            clk    => clk,
            sig_in => btnD_db,
            pulse  => btnD_pulse
        );

    -- Freeze / Pause
    pulse_up   <= btnU_pulse when sw(0) = '0' else '0';
    pulse_down <= btnD_pulse when sw(0) = '0' else '0';

    counter : entity work.updown_counter
        port map (
            clk        => clk,
            reset      => btnC_db,
            pulse_up   => pulse_up,
            pulse_down => pulse_down,
            count_out  => count_value
        );

    display : entity work.seven_seg_driver2
        generic map (
            DIGITS => 4
        )
        port map (
            clk     => clk,
            data_in => count_value,
            seg     => seg,
            dp      => dp,
            an      => an
        );

end Structural;