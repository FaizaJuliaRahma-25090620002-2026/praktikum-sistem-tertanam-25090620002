library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_tick_1hz is
end tb_tick_1hz;

architecture sim of tb_tick_1hz is
    constant CLK_PERIOD : time := 10 ns;
    constant FREQ_TEST  : integer := 10;   -- diperkecil agar simulasi cepat

    signal clk  : std_logic := '0';
    signal rst  : std_logic := '1';
    signal tick : std_logic;
begin
    uut: entity work.tick_1hz
        generic map ( CLK_FREQ_HZ => FREQ_TEST )
        port map ( clk => clk, rst => rst, tick => tick );

    clk <= not clk after CLK_PERIOD/2;

    stim: process
        variable t_prev, t_now : time;
    begin
        wait for 3*CLK_PERIOD;
        rst <= '0';

        wait until rising_edge(tick);
        t_prev := now;
        for i in 1 to 5 loop
            wait until rising_edge(tick);
            t_now := now;
            assert (t_now - t_prev) = FREQ_TEST * CLK_PERIOD
                report "Periode tick salah: " & time'image(t_now - t_prev)
                severity error;
            t_prev := t_now;
        end loop;

        report "Simulasi tick_1hz selesai, periode benar." severity note;
        wait;
    end process;
end sim;