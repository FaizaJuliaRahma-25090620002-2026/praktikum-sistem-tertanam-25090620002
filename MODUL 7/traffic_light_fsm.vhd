library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity traffic_light_fsm is
    Generic ( GREEN_SEC  : integer := 10;
              YELLOW_SEC : integer := 3 );
    Port ( clk  : in  STD_LOGIC;
           rst  : in  STD_LOGIC;
           tick : in  STD_LOGIC;                       -- pulsa 1 Hz
           led  : out STD_LOGIC_VECTOR(5 downto 0) );
    -- led(0)=NS hijau, led(1)=NS kuning, led(2)=NS merah
    -- led(3)=EW hijau, led(4)=EW kuning, led(5)=EW merah
end traffic_light_fsm;

architecture Behavioral of traffic_light_fsm is

    type state_t is (NS_GREEN, NS_YELLOW, EW_GREEN, EW_YELLOW);

    signal state_reg, state_next : state_t := NS_GREEN;
    signal timer_reg, timer_next : integer range 0 to 31 := GREEN_SEC - 1;

begin

    ---------------------------------------------------------------
    -- PROCESS 1: sequential (register state dan timer)
    ---------------------------------------------------------------
    seq_proc: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state_reg <= NS_GREEN;
                timer_reg <= GREEN_SEC - 1;
            else
                state_reg <= state_next;
                timer_reg <= timer_next;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------
    -- PROCESS 2: combinational (next-state, timer, output)
    ---------------------------------------------------------------
    comb_proc: process(state_reg, timer_reg, tick)
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
                        state_next <= EW_GREEN;
                        timer_next <= GREEN_SEC - 1;
                    when EW_GREEN =>
                        state_next <= EW_YELLOW;
                        timer_next <= YELLOW_SEC - 1;
                    when EW_YELLOW =>
                        state_next <= NS_GREEN;
                        timer_next <= GREEN_SEC - 1;
                end case;
            else
                timer_next <= timer_reg - 1;
            end if;
        end if;

        -- decoder output: tepat 1 LED menyala per arah
        case state_reg is
            when NS_GREEN  => led <= "100001";  -- NS hijau,  EW merah
            when NS_YELLOW => led <= "100010";  -- NS kuning, EW merah
            when EW_GREEN  => led <= "001100";  -- NS merah,  EW hijau
            when EW_YELLOW => led <= "010100";  -- NS merah,  EW kuning
        end case;
    end process;

end Behavioral;