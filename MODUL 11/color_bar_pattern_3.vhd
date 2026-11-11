
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_bar_pattern_3 is
    Port (
        h_count : in  INTEGER range 0 to 1055;
        v_count : in  INTEGER range 0 to 627;
        sw      : in  STD_LOGIC_VECTOR(3 downto 0);

        rgb     : out STD_LOGIC_VECTOR(11 downto 0)
    );
end color_bar_pattern_3;

architecture Behavioral of color_bar_pattern_3 is

    signal box_x : INTEGER;

begin

    -- Posisi horizontal kotak merah
    box_x <= 20 + to_integer(unsigned(sw)) * 45;

    process(h_count, v_count, box_x)
    begin

        -- Kotak merah
        if h_count >= box_x and
           h_count < box_x + 60 and
           v_count >= 250 and
           v_count < 310 then

            rgb <= "111100000000";

        -- Delapan kolom warna
        else
            case h_count / 100 is

                when 0 =>
                    rgb <= "111111110000"; -- Kuning

                when 1 =>
                    rgb <= "111100001111"; -- Magenta

                when 2 =>
                    rgb <= "000011111111"; -- Cyan

                when 3 =>
                    rgb <= "111111111111"; -- Putih

                when 4 =>
                    rgb <= "111100000000"; -- Merah

                when 5 =>
                    rgb <= "000011110000"; -- Hijau

                when 6 =>
                    rgb <= "000000001111"; -- Biru

                when others =>
                    rgb <= "000000000000"; -- Hitam

            end case;
        end if;

    end process;

end Behavioral;
