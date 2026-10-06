library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_driver is
    generic (
        CLK_FREQ_HZ : integer := 10_000_000
    );

    Port (
        clk  : in  STD_LOGIC;
        value : in STD_LOGIC_VECTOR(15 downto 0);

        seg  : out STD_LOGIC_VECTOR(6 downto 0);
        dp   : out STD_LOGIC;
        an   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_seg_driver;

architecture Behavioral of seven_seg_driver is

    signal digit0 : integer range 0 to 9 := 0;
    signal digit1 : integer range 0 to 9 := 0;
    signal digit2 : integer range 0 to 9 := 0;
    signal digit3 : integer range 0 to 9 := 0;

    signal refresh_counter : integer range 0 to 2499 := 0;
    signal digit_select : integer range 0 to 3 := 0;

    signal current_digit : integer range 0 to 9 := 0;

begin

    ------------------------------------------------------------
    -- KONVERSI HASIL KE DESIMAL
    ------------------------------------------------------------

    process(value)

        variable num : integer;

    begin

        num := to_integer(unsigned(value));

        digit0 <= num mod 10;
        digit1 <= (num / 10) mod 10;
        digit2 <= (num / 100) mod 10;
        digit3 <= (num / 1000) mod 10;

    end process;


    ------------------------------------------------------------
    -- REFRESH DISPLAY
    ------------------------------------------------------------

    process(clk)
    begin

        if rising_edge(clk) then

            if refresh_counter = 2499 then

                refresh_counter <= 0;

                if digit_select = 3 then
                    digit_select <= 0;
                else
                    digit_select <= digit_select + 1;
                end if;

            else

                refresh_counter <= refresh_counter + 1;

            end if;

        end if;

    end process;


    ------------------------------------------------------------
    -- PILIH DIGIT
    ------------------------------------------------------------

    process(digit_select, digit0, digit1, digit2, digit3)
    begin

        case digit_select is

            when 0 =>
                current_digit <= digit0;
                an <= "1110";

            when 1 =>
                current_digit <= digit1;
                an <= "1101";

            when 2 =>
                current_digit <= digit2;
                an <= "1011";

            when 3 =>
                current_digit <= digit3;
                an <= "0111";

            when others =>
                current_digit <= 0;
                an <= "1111";

        end case;

    end process;


    ------------------------------------------------------------
    -- DECODER DESIMAL
    -- ACTIVE LOW - BASYS 3
    ------------------------------------------------------------

    process(current_digit)
    begin

        case current_digit is

            when 0 =>
                seg <= "1000000";

            when 1 =>
                seg <= "1111001";

            when 2 =>
                seg <= "0100100";

            when 3 =>
                seg <= "0110000";

            when 4 =>
                seg <= "0011001";

            when 5 =>
                seg <= "0010010";

            when 6 =>
                seg <= "0000010";

            when 7 =>
                seg <= "1111000";

            when 8 =>
                seg <= "0000000";

            when 9 =>
                seg <= "0010000";

            when others =>
                seg <= "1111111";

        end case;

    end process;


    ------------------------------------------------------------
    -- DECIMAL POINT MATI
    ------------------------------------------------------------

    dp <= '1';

end Behavioral;