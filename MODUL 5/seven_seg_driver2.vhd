library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_driver2 is
    generic (
        DIGITS : integer := 4
    );

    port (
        clk     : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR(15 downto 0);
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        dp      : out STD_LOGIC;
        an      : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_seg_driver2;

architecture Behavioral of seven_seg_driver2 is

    constant REFRESH_COUNT : integer := 100_000;

    signal refresh_counter : integer range 0 to REFRESH_COUNT - 1 := 0;
    signal digit_select    : unsigned(1 downto 0) := "00";
    signal current_digit   : unsigned(3 downto 0);

    function hex_to_seg(
        digit : unsigned(3 downto 0)
    ) return STD_LOGIC_VECTOR is
    begin
        case digit is
            when "0000" => return "1000000"; -- 0
            when "0001" => return "1111001"; -- 1
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when "0101" => return "0010010"; -- 5
            when "0110" => return "0000010"; -- 6
            when "0111" => return "1111000"; -- 7
            when "1000" => return "0000000"; -- 8
            when "1001" => return "0010000"; -- 9
            when "1010" => return "0001000"; -- A
            when "1011" => return "0000011"; -- B
            when "1100" => return "1000110"; -- C
            when "1101" => return "0100001"; -- D
            when "1110" => return "0000110"; -- E
            when "1111" => return "0001110"; -- F
            when others => return "1111111";
        end case;
    end function;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = REFRESH_COUNT - 1 then
                refresh_counter <= 0;
                digit_select <= digit_select + 1;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    process(data_in, digit_select)
    begin
        case digit_select is
            when "00" =>
                current_digit <= unsigned(data_in(3 downto 0));

            when "01" =>
                current_digit <= unsigned(data_in(7 downto 4));

            when "10" =>
                current_digit <= unsigned(data_in(11 downto 8));

            when "11" =>
                current_digit <= unsigned(data_in(15 downto 12));

            when others =>
                current_digit <= "0000";
        end case;
    end process;

    seg <= hex_to_seg(current_digit);

    dp <= '1';

    process(digit_select)
    begin
        case digit_select is
            when "00" =>
                an <= "1110";

            when "01" =>
                an <= "1101";

            when "10" =>
                an <= "1011";

            when "11" =>
                an <= "0111";

            when others =>
                an <= "1111";
        end case;
    end process;

end Behavioral;