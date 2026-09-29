library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_dff_sync_reset is
end tb_dff_sync_reset;

architecture Behavioral of tb_dff_sync_reset is

    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal d   : STD_LOGIC := '0';
    signal q   : STD_LOGIC;

begin

    uut: entity work.dff_sync_reset
        port map (
            clk => clk,
            rst => rst,
            d   => d,
            q   => q
        );

    -- Clock periode 20 ns
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Variasi input
    stimulus: process
    begin
        d <= '0';
        rst <= '0';
        wait for 15 ns;

        d <= '1';
        wait for 10 ns;

        d <= '0';
        wait for 10 ns;

        rst <= '1';
        wait for 20 ns;

        rst <= '0';
        d <= '1';
        wait for 20 ns;

        d <= '0';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;