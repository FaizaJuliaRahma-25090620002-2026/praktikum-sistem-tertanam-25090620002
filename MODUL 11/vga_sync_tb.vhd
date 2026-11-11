
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_sync_tb is
end vga_sync_tb;

architecture Simulation of vga_sync_tb is

    signal pclk     : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '1';
    signal hsync    : STD_LOGIC;
    signal vsync    : STD_LOGIC;
    signal video_on : STD_LOGIC;

    signal h_count : integer range 0 to 799;
    signal v_count : integer range 0 to 524;

begin

    uut: entity work.vga_sync
        port map (
            pclk     => pclk,
            rst      => rst,
            hsync    => hsync,
            vsync    => vsync,
            video_on => video_on,
            h_count  => h_count,
            v_count  => v_count
        );

    pclk <= not pclk after 20 ns;

    process
    begin
        wait for 100 ns;
        rst <= '0';

        wait for 40 us;

        assert h_count < 800
            report "Horizontal counter error"
            severity error;

        assert v_count < 525
            report "Vertical counter error"
            severity error;

        report "SIMULASI BERHASIL"
            severity note;

        wait;
    end process;

end Simulation;
