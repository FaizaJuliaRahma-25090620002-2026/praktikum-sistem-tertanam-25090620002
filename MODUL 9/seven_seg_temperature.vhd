
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_temperature is
    Port (
        clk   : in  STD_LOGIC;
        value : in  unsigned(10 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        an    : out STD_LOGIC_VECTOR(3 downto 0);
        dp    : out STD_LOGIC
    );
end seven_seg_temperature;

architecture Behavioral of seven_seg_temperature is
    signal refresh : unsigned(15 downto 0) := (others => '0');
    signal digit_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal digit : integer range 0 to 9 := 0;
    signal num : integer range 0 to 9999 := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            refresh <= refresh + 1;
        end if;
    end process;

    digit_sel <= STD_LOGIC_VECTOR(refresh(15 downto 14));
    num <= to_integer(value);

    process(digit_sel, num)
    begin
        an <= "1111";
        dp <= '1';
        digit <= 0;

        case digit_sel is
            when "00" =>
                an <= "1110";
                digit <= (num mod 10);

            when "01" =>
                an <= "1101";
                digit <= (num / 10) mod 10;

            when "10" =>
                an <= "1011";
                digit <= (num / 100) mod 10;

            when others =>
                an <= "0111";
                digit <= (num / 1000) mod 10;
        end case;
    end process;

    process(digit)
    begin
        case digit is
            when 0 => seg <= "1000000";
            when 1 => seg <= "1111001";
            when 2 => seg <= "0100100";
            when 3 => seg <= "0110000";
            when 4 => seg <= "0011001";
            when 5 => seg <= "0010010";
            when 6 => seg <= "0000010";
            when 7 => seg <= "1111000";
            when 8 => seg <= "0000000";
            when 9 => seg <= "0010000";
            when others => seg <= "1111111";
        end case;
    end process;

end Behavioral;
