library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity scan2ascii is
    Port ( scan_code : in  STD_LOGIC_VECTOR (7 downto 0);
           ascii     : out STD_LOGIC_VECTOR (7 downto 0) );
end scan2ascii;

architecture Behavioral of scan2ascii is
begin
    process(scan_code)
    begin
        case scan_code is
            -- Huruf A-Z
            when x"1C" => ascii <= x"41";  -- A
            when x"32" => ascii <= x"42";  -- B
            when x"21" => ascii <= x"43";  -- C
            when x"23" => ascii <= x"44";  -- D
            when x"24" => ascii <= x"45";  -- E
            when x"2B" => ascii <= x"46";  -- F
            when x"34" => ascii <= x"47";  -- G
            when x"33" => ascii <= x"48";  -- H
            when x"43" => ascii <= x"49";  -- I
            when x"3B" => ascii <= x"4A";  -- J
            when x"42" => ascii <= x"4B";  -- K
            when x"4B" => ascii <= x"4C";  -- L
            when x"3A" => ascii <= x"4D";  -- M
            when x"31" => ascii <= x"4E";  -- N
            when x"44" => ascii <= x"4F";  -- O
            when x"4D" => ascii <= x"50";  -- P
            when x"15" => ascii <= x"51";  -- Q
            when x"2D" => ascii <= x"52";  -- R
            when x"1B" => ascii <= x"53";  -- S
            when x"2C" => ascii <= x"54";  -- T
            when x"3C" => ascii <= x"55";  -- U
            when x"2A" => ascii <= x"56";  -- V
            when x"1D" => ascii <= x"57";  -- W
            when x"22" => ascii <= x"58";  -- X
            when x"35" => ascii <= x"59";  -- Y
            when x"1A" => ascii <= x"5A";  -- Z
            -- Angka 0-9 (baris atas keyboard)
            when x"45" => ascii <= x"30";  -- 0
            when x"16" => ascii <= x"31";  -- 1
            when x"1E" => ascii <= x"32";  -- 2
            when x"26" => ascii <= x"33";  -- 3
            when x"25" => ascii <= x"34";  -- 4
            when x"2E" => ascii <= x"35";  -- 5
            when x"36" => ascii <= x"36";  -- 6
            when x"3D" => ascii <= x"37";  -- 7
            when x"3E" => ascii <= x"38";  -- 8
            when x"46" => ascii <= x"39";  -- 9
            when others => ascii <= x"00"; -- tidak dikenal (termasuk F0 / E0)
        end case;
    end process;
end Behavioral;