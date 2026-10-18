library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light_fsm_2 is
    Generic ( YELLOW_SEC : integer := 3;
              ALLRED_SEC : integer := 1 );
    Port ( clk  : in  STD_LOGIC;
           rst  : in  STD_LOGIC;
           tick : in  STD_LOGIC;                       -- pulsa 1 Hz
           sw   : in  STD_LOGIC_VECTOR(3 downto 0);    -- durasi hijau = 5 + sw
           led  : out STD_LOGIC_VECTOR(5 downto 0) );
    -- led(0)=NS hijau, led(1)=NS kuning, led(2)=NS merah
    -- led(3)=EW hijau, led(4)=EW kuning, led(5)=EW merah
end traffic_light_fsm_2;

architecture Behavioral of traffic_light_fsm_2 is

    type state_t is (NS_GREEN, NS_YELLOW, ALL_RED_1,
                     EW_GREEN, EW_YELLOW, ALL_RED_2);

    signal state_reg, state_next : state_t := NS_GREEN;
    signal timer_reg, timer_next : integer range 0 to 31 := 9;
    signal green_sec : integer range 5 to 20;

begin

    -- durasi hijau dari switch: 5..20 detik
    green_sec <= 5 + to_integer(unsigned(sw));

    ---------------------------------------------------------------
    -- PROCESS 1: sequential (register state dan timer)
    ---------------------------------------------------------------
    seq_proc: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state_reg <= NS_GREEN;
                timer_reg <= green_sec - 1;
            else
                state_reg <= state_next;
                timer_reg <= timer_next;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------
    -- PROCESS 2: combinational (next-state, timer, output)
    ---------------------------------------------------------------
    comb_proc: process(state_reg, timer_reg, tick, green_sec)
    begin
        -- nilai default
        state_next <= state_reg;
        timer_next <= timer_reg;
        led        <= "100001";

        -- timer dikurangi setiap tick = '1'
        if tick = '1' then
            if timer_reg = 0 then
                -- timer mencapai nol: pindah state, muat durasi state baru
                case state_reg is
                    when NS_GREEN =>
                        state_next <= NS_YELLOW;
                        timer_next <= YELLOW_SEC - 1;
                    when NS_YELLOW =>
                        state_next <= ALL_RED_1;
                        timer_next <= ALLRED_SEC - 1;
                    when ALL_RED_1 =>
                        state_next <= EW_GREEN;
                        timer_next <= green_sec - 1;
                    when EW_GREEN =>
                        state_next <= EW_YELLOW;
                        timer_next <= YELLOW_SEC - 1;
                    when EW_YELLOW =>
                        state_next <= ALL_RED_2;
                        timer_next <= ALLRED_SEC - 1;
                    when ALL_RED_2 =>
                        state_next <= NS_GREEN;
                        timer_next <= green_sec - 1;
                end case;
            else
                timer_next <= timer_reg - 1;
            end if;
        end if;

        -- decoder output: tepat 1 LED menyala per arah
        case state_reg is
            when NS_GREEN  => led <= "100001";  -- NS hijau,  EW merah
            when NS_YELLOW => led <= "100010";  -- NS kuning, EW merah
            when ALL_RED_1 => led <= "100100";  -- semua merah
            when EW_GREEN  => led <= "001100";  -- NS merah,  EW hijau
            when EW_YELLOW => led <= "010100";  -- NS merah,  EW kuning
            when ALL_RED_2 => led <= "100100";  -- semua merah
        end case;
    end process;

end Behavioral;