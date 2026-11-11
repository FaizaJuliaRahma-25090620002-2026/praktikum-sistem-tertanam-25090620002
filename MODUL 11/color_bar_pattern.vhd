library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity color_bar_pattern is
    Port (
        h_count : in integer range 0 to 799;
        rgb     : out STD_LOGIC_VECTOR(11 downto 0)
    );
end color_bar_pattern;

architecture Behavioral of color_bar_pattern is
begin

    process(h_count)
    begin
        if h_count < 80 then
            rgb <= "111100000000"; -- Merah

        elsif h_count < 160 then
            rgb <= "111111110000"; -- Kuning

        elsif h_count < 240 then
            rgb <= "000011110000"; -- Hijau

        elsif h_count < 320 then
            rgb <= "000011111111"; -- Cyan

        elsif h_count < 400 then
            rgb <= "000000001111"; -- Biru

        elsif h_count < 480 then
            rgb <= "111100001111"; -- Magenta

        elsif h_count < 560 then
            rgb <= "111111111111"; -- Putih

        else
            rgb <= "000000000000"; -- Hitam
        end if;
    end process;

end Behavioral;
