
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_bar_pattern_2 is
    Port (
        h_count : in integer range 0 to 799;
        v_count : in integer range 0 to 524;
        sw      : in STD_LOGIC_VECTOR(3 downto 0);
        rgb     : out STD_LOGIC_VECTOR(11 downto 0)
    );
end color_bar_pattern_2;

architecture Behavioral of color_bar_pattern_2 is
begin

    process(h_count, v_count, sw)

        variable box_x : integer;
        variable box_y : integer;

    begin

        -- Posisi kotak berdasarkan switch
        box_x := 20 + to_integer(unsigned(sw)) * 35;
        box_y := 200;

        -- Kotak merah
        if (h_count >= box_x) and
           (h_count < box_x + 60) and
           (v_count >= box_y) and
           (v_count < box_y + 60) then

            rgb <= "111100000000";

        -- Pola papan catur
        elsif (((h_count / 80) mod 2) =
               ((v_count / 60) mod 2)) then

            rgb <= "111111111111";

        else

            rgb <= "000000000000";

        end if;

    end process;

end Behavioral;
