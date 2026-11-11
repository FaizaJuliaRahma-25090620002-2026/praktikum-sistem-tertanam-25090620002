library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js11_top is
    Port (
        clk     : in STD_LOGIC;

        vgaRed   : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue  : out STD_LOGIC_VECTOR(3 downto 0);

        Hsync : out STD_LOGIC;
        Vsync : out STD_LOGIC
    );
end js11_top;

architecture Behavioral of js11_top is

    signal pixel_clk : STD_LOGIC;
    signal locked    : STD_LOGIC;

    signal h_count : integer range 0 to 799;
    signal v_count : integer range 0 to 524;

    signal video_on : STD_LOGIC;
    signal rgb      : STD_LOGIC_VECTOR(11 downto 0);

begin

    clk_gen: entity work.clk_wiz_0
        port map (
            clk_in1  => clk,
            reset    => '0',
            clk_out1 => pixel_clk,
            locked   => locked
        );

    sync_gen: entity work.vga_sync
        port map (
            pclk     => pixel_clk,
            rst      => not locked,
            hsync    => Hsync,
            vsync    => Vsync,
            video_on => video_on,
            h_count  => h_count,
            v_count  => v_count
        );

    pattern_gen: entity work.color_bar_pattern
        port map (
            h_count => h_count,
            rgb     => rgb
        );

    vgaRed <= rgb(11 downto 8) when video_on = '1'
              else "0000";

    vgaGreen <= rgb(7 downto 4) when video_on = '1'
                else "0000";

    vgaBlue <= rgb(3 downto 0) when video_on = '1'
               else "0000";

end Behavioral;
