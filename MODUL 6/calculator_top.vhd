library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculator_top is
    Port (
        clk  : in STD_LOGIC;

        sw   : in STD_LOGIC_VECTOR(7 downto 0);

        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        btnL : in STD_LOGIC;
        btnR : in STD_LOGIC;
        btnC : in STD_LOGIC;

        seg  : out STD_LOGIC_VECTOR(6 downto 0);
        an   : out STD_LOGIC_VECTOR(3 downto 0);
        dp   : out STD_LOGIC
    );
end calculator_top;

architecture Behavioral of calculator_top is

    signal clk_1mhz : STD_LOGIC;

    signal btnU_db : STD_LOGIC;
    signal btnD_db : STD_LOGIC;
    signal btnL_db : STD_LOGIC;
    signal btnR_db : STD_LOGIC;
    signal btnC_db : STD_LOGIC;

    signal btnU_edge : STD_LOGIC;
    signal btnD_edge : STD_LOGIC;
    signal btnL_edge : STD_LOGIC;
    signal btnR_edge : STD_LOGIC;
    signal btnC_edge : STD_LOGIC;

    signal result : STD_LOGIC_VECTOR(15 downto 0);
    signal carry  : STD_LOGIC;
    signal opcode : STD_LOGIC_VECTOR(1 downto 0);

    signal state_led : STD_LOGIC_VECTOR(3 downto 0);

begin

    ------------------------------------------------------------
    -- CLOCK
    -- Input Basys 3 = 100 MHz
    -- Internal clock = 10 MHz
    ------------------------------------------------------------

    clock_div : entity work.clock_divider_1mhz
        port map (
            clk_100mhz => clk,
            clk_1mhz   => clk_1mhz
        );


    ------------------------------------------------------------
    -- DEBOUNCE
    ------------------------------------------------------------

    debounce_U : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk     => clk_1mhz,
            btn_in  => btnU,
            btn_out => btnU_db
        );


    debounce_D : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk     => clk_1mhz,
            btn_in  => btnD,
            btn_out => btnD_db
        );


    debounce_L : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk     => clk_1mhz,
            btn_in  => btnL,
            btn_out => btnL_db
        );


    debounce_R : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk     => clk_1mhz,
            btn_in  => btnR,
            btn_out => btnR_db
        );


    debounce_C : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 10_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk     => clk_1mhz,
            btn_in  => btnC,
            btn_out => btnC_db
        );


    ------------------------------------------------------------
    -- EDGE DETECTOR
    ------------------------------------------------------------

    edge_U : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnU_db,
            pulse     => btnU_edge
        );


    edge_D : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnD_db,
            pulse     => btnD_edge
        );


    edge_L : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnL_db,
            pulse     => btnL_edge
        );


    edge_R : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnR_db,
            pulse     => btnR_edge
        );


    edge_C : entity work.edge_detect
        port map (
            clk       => clk_1mhz,
            signal_in => btnC_db,
            pulse     => btnC_edge
        );


    ------------------------------------------------------------
    -- CALCULATOR FSM
    ------------------------------------------------------------

    calculator : entity work.calculator_fsm
        port map (
            clk       => clk_1mhz,
            rst       => '0',

            btnU      => btnU_edge,
            btnD      => btnD_edge,
            btnL      => btnL_edge,
            btnR      => btnR_edge,
            btnC      => btnC_edge,

            sw        => sw,

            result    => result,
            carry     => carry,
            opcode    => opcode,
            state_led => state_led
        );


    ------------------------------------------------------------
    -- SEVEN SEGMENT
    ------------------------------------------------------------

    display : entity work.seven_seg_driver
        generic map (
            CLK_FREQ_HZ => 10_000_000
        )
        port map (
            clk   => clk_1mhz,
            value => result,
            seg   => seg,
            an    => an,
            dp    => dp
        );

end Behavioral;