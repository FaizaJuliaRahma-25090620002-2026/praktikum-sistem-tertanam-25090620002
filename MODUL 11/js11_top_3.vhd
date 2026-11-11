
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js11_top_3 is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        sw        : in  STD_LOGIC_VECTOR(3 downto 0);

        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;

        vga_red   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_green : out STD_LOGIC_VECTOR(3 downto 0);
        vga_blue  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end js11_top_3;

architecture Behavioral of js11_top_3 is

    signal pixel_clk : STD_LOGIC;
    signal locked    : STD_LOGIC;

    signal h_count   : INTEGER range 0 to 1055;
    signal v_count   : INTEGER range 0 to 627;
    signal video_on  : STD_LOGIC;

    signal rgb       : STD_LOGIC_VECTOR(11 downto 0);

begin

    -- Clocking Wizard 40 MHz
    clk_wiz_inst : entity work.clk_wiz_1
    port map (
        clk_in1  => clk,
        reset    => reset,
        clk_out1 => pixel_clk,
        locked   => locked
    );

    -- VGA Sync 800x600
    vga_sync_inst : entity work.vga_sync_3
    port map (
        pixel_clk => pixel_clk,
        reset     => reset,
        hsync     => hsync,
        vsync     => vsync,
        h_count   => h_count,
        v_count   => v_count,
        video_on  => video_on
    );

    -- Color Pattern
    color_pattern_inst : entity work.color_bar_pattern_3
    port map (
        h_count => h_count,
        v_count => v_count,
        sw      => sw,
        rgb     => rgb
    );

    -- VGA RGB Output
    process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            if locked = '1' and video_on = '1' then
                vga_red   <= rgb(11 downto 8);
                vga_green <= rgb(7 downto 4);
                vga_blue  <= rgb(3 downto 0);
            else
                vga_red   <= (others => '0');
                vga_green <= (others => '0');
                vga_blue  <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
