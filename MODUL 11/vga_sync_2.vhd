
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync_2 is
    Port (
        pclk     : in STD_LOGIC;
        rst      : in STD_LOGIC;
        hsync    : out STD_LOGIC;
        vsync    : out STD_LOGIC;
        video_on : out STD_LOGIC;
        h_count  : out integer range 0 to 799;
        v_count  : out integer range 0 to 524
    );
end vga_sync_2;

architecture Behavioral of vga_sync_2 is

    constant H_DISPLAY : integer := 640;
    constant H_FPORCH  : integer := 16;
    constant H_SYNC    : integer := 96;
    constant H_TOTAL   : integer := 800;

    constant V_DISPLAY : integer := 480;
    constant V_FPORCH  : integer := 10;
    constant V_SYNC    : integer := 2;
    constant V_TOTAL   : integer := 525;

    signal hc : integer range 0 to 799 := 0;
    signal vc : integer range 0 to 524 := 0;

begin

    process(pclk)
    begin
        if rising_edge(pclk) then

            if rst = '1' then
                hc <= 0;
                vc <= 0;

            elsif hc = H_TOTAL-1 then
                hc <= 0;

                if vc = V_TOTAL-1 then
                    vc <= 0;
                else
                    vc <= vc + 1;
                end if;

            else
                hc <= hc + 1;
            end if;

        end if;
    end process;

    hsync <= '0' when
        (hc >= H_DISPLAY + H_FPORCH) and
        (hc < H_DISPLAY + H_FPORCH + H_SYNC)
        else '1';

    vsync <= '0' when
        (vc >= V_DISPLAY + V_FPORCH) and
        (vc < V_DISPLAY + V_FPORCH + V_SYNC)
        else '1';

    video_on <= '1' when
        (hc < H_DISPLAY) and
        (vc < V_DISPLAY)
        else '0';

    h_count <= hc;
    v_count <= vc;

end Behavioral;
