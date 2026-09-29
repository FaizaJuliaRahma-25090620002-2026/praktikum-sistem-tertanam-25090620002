library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce is
end tb_debounce;

architecture Behavioral of tb_debounce is

    signal clk     : std_logic := '0';
    signal btn_in  : std_logic := '0';
    signal btn_out : std_logic;

begin

    -- Clock 100 MHz
    clk <= not clk after 5 ns;

    -- Unit Under Test
    uut : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            DEBOUNCE_MS => 5
        )
        port map (
            clk     => clk,
            btn_in  => btn_in,
            btn_out => btn_out
        );

    -- Test stimulus
    process
    begin

        -- Kondisi awal
        btn_in <= '0';
        wait for 10 ms;

        -- Bouncing tombol
        btn_in <= '1';
        wait for 1 ms;

        btn_in <= '0';
        wait for 0.5 ms;

        btn_in <= '1';
        wait for 0.3 ms;

        btn_in <= '0';
        wait for 0.4 ms;

        btn_in <= '1';
        wait for 0.7 ms;

        btn_in <= '0';
        wait for 0.2 ms;

        btn_in <= '1';

        -- Tunggu sampai stabil
        wait for 10 ms;

        -- Tombol dilepas
        btn_in <= '0';

        -- Bouncing saat dilepas
        wait for 0.5 ms;

        btn_in <= '1';
        wait for 0.2 ms;

        btn_in <= '0';
        wait for 0.3 ms;

        btn_in <= '1';
        wait for 0.2 ms;

        btn_in <= '0';

        -- Tunggu debounce
        wait for 10 ms;

        wait;

    end process;

end Behavioral;