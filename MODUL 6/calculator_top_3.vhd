library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculator_top_3 is
    Port (
        clk  : in  STD_LOGIC;

        sw   : in  STD_LOGIC_VECTOR(9 downto 0);

        btnU : in  STD_LOGIC;
        btnD : in  STD_LOGIC;
        btnL : in  STD_LOGIC;
        btnR : in  STD_LOGIC;
        btnC : in  STD_LOGIC;

        seg  : out STD_LOGIC_VECTOR(6 downto 0);
        dp   : out STD_LOGIC;
        an   : out STD_LOGIC_VECTOR(3 downto 0);

        led  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end calculator_top_3;

architecture Behavioral of calculator_top_3 is

    signal clk_1mhz : STD_LOGIC;

    signal btnU_db : STD_LOGIC;
    signal btnD_db : STD_LOGIC;
    signal btnL_db : STD_LOGIC;
    signal btnR_db : STD_LOGIC;

    signal btnU_pulse : STD_LOGIC;
    signal btnD_pulse : STD_LOGIC;
    signal btnL_pulse : STD_LOGIC;
    signal btnR_pulse : STD_LOGIC;

    signal result : STD_LOGIC_VECTOR(15 downto 0);
    signal carry  : STD_LOGIC;
    signal opcode : STD_LOGIC_VECTOR(1 downto 0);

begin

    ----------------------------------------------------------------
    -- CLOCK DIVIDER
    ----------------------------------------------------------------
    clock_div : entity work.clock_divider_1mhz
        port map (
            clk_100mhz => clk,
            clk_1mhz   => clk_1mhz
        );


    ----------------------------------------------------------------
    -- DEBOUNCE BTN_U
    ----------------------------------------------------------------
    debounce_U : entity work.debounce_2
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk        => clk_1mhz,
            button_in  => btnU,
            button_out => btnU_db
        );


    ----------------------------------------------------------------
    -- DEBOUNCE BTN_D
    ----------------------------------------------------------------
    debounce_D : entity work.debounce_2
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk        => clk_1mhz,
            button_in  => btnD,
            button_out => btnD_db
        );


    ----------------------------------------------------------------
    -- DEBOUNCE BTN_L
    ----------------------------------------------------------------
    debounce_L : entity work.debounce_2
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk        => clk_1mhz,
            button_in  => btnL,
            button_out => btnL_db
        );


    ----------------------------------------------------------------
    -- DEBOUNCE BTN_R
    -- BTN_R = RESET
    ----------------------------------------------------------------
    debounce_R : entity work.debounce_2
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk        => clk_1mhz,
            button_in  => btnR,
            button_out => btnR_db
        );


    ----------------------------------------------------------------
    -- EDGE DETECTOR BTN_U
    ----------------------------------------------------------------
    edge_U : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnU_db,
            pulse     => btnU_pulse
        );


    ----------------------------------------------------------------
    -- EDGE DETECTOR BTN_D
    ----------------------------------------------------------------
    edge_D : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnD_db,
            pulse     => btnD_pulse
        );


    ----------------------------------------------------------------
    -- EDGE DETECTOR BTN_L
    ----------------------------------------------------------------
    edge_L : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnL_db,
            pulse     => btnL_pulse
        );


    ----------------------------------------------------------------
    -- EDGE DETECTOR BTN_R
    -- BTN_R = RESET
    ----------------------------------------------------------------
    edge_R : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnR_db,
            pulse     => btnR_pulse
        );


    ----------------------------------------------------------------
    -- MEALY CALCULATOR FSM
    ----------------------------------------------------------------
    calculator : entity work.calculator_fsm_3
        port map (
            clk       => clk_1mhz,

            rst       => btnR_pulse,

            btnU      => btnU_pulse,
            btnD      => btnD_pulse,
            btnL      => btnL_pulse,
            btnR      => btnR_pulse,
            btnC      => '0',

            sw        => sw,

            result    => result,
            carry     => carry,
            opcode    => opcode,

            state_led => led
        );


    ----------------------------------------------------------------
    -- SEVEN SEGMENT DISPLAY
    ----------------------------------------------------------------
    display : entity work.seven_seg_driver
        generic map (
            CLK_FREQ_HZ => 10_000_000
        )
        port map (
            clk   => clk_1mhz,
            value => result,
            seg   => seg,
            dp    => dp,
            an    => an
        );

end Behavioral;