
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_sync_3 is
    Port (
        pixel_clk : in  STD_LOGIC;
        reset     : in  STD_LOGIC;

        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;

        h_count   : out INTEGER range 0 to 1055;
        v_count   : out INTEGER range 0 to 627;

        video_on  : out STD_LOGIC
    );
end vga_sync_3;

architecture Behavioral of vga_sync_3 is

    constant H_DISPLAY : INTEGER := 800;
    constant H_FRONT   : INTEGER := 40;
    constant H_SYNC    : INTEGER := 128;
    constant H_BACK    : INTEGER := 88;
    constant H_TOTAL   : INTEGER := 1056;

    constant V_DISPLAY : INTEGER := 600;
    constant V_FRONT   : INTEGER := 1;
    constant V_SYNC    : INTEGER := 4;
    constant V_BACK    : INTEGER := 23;
    constant V_TOTAL   : INTEGER := 628;

    signal h_pos : INTEGER range 0 to 1055 := 0;
    signal v_pos : INTEGER range 0 to 627 := 0;

begin

    process(pixel_clk, reset)
    begin
        if reset = '1' then
            h_pos <= 0;
            v_pos <= 0;

        elsif rising_edge(pixel_clk) then

            if h_pos = H_TOTAL - 1 then
                h_pos <= 0;

                if v_pos = V_TOTAL - 1 then
                    v_pos <= 0;
                else
                    v_pos <= v_pos + 1;
                end if;

            else
                h_pos <= h_pos + 1;
            end if;

        end if;
    end process;

    -- HSync aktif HIGH
    hsync <= '1' when
        h_pos >= H_DISPLAY + H_FRONT and
        h_pos < H_DISPLAY + H_FRONT + H_SYNC
        else '0';

    -- VSync aktif HIGH
    vsync <= '1' when
        v_pos >= V_DISPLAY + V_FRONT and
        v_pos < V_DISPLAY + V_FRONT + V_SYNC
        else '0';

    -- Area tampilan aktif
    video_on <= '1' when
        h_pos < H_DISPLAY and
        v_pos < V_DISPLAY
        else '0';

    h_count <= h_pos;
    v_count <= v_pos;

end Behavioral;
