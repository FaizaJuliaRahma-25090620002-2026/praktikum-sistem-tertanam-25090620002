
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_unsigned is
    Port (
        clk   : in  STD_LOGIC;
        value : in  unsigned(10 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        an    : out STD_LOGIC_VECTOR(3 downto 0);
        dp    : out STD_LOGIC
    );
end seven_seg_unsigned;

architecture Behavioral of seven_seg_unsigned is
    signal refresh : unsigned(15 downto 0) := (others => '0');
    signal digit   : unsigned(1 downto 0);
    signal number  : integer range 0 to 9 := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            refresh <= refresh + 1;
        end if;
    end process;

    digit <= refresh(15 downto 14);

    process(value, digit)
        variable val : integer range 0 to 2047;
    begin
        val := to_integer(value);

        case to_integer(digit) is
            when 0 =>
                number <= val mod 10;
                an <= "1110";
                dp <= '1';

            when 1 =>
                number <= (val / 10) mod 10;
                an <= "1101";
                dp <= '1';

            when 2 =>
                number <= (val / 100) mod 10;
                an <= "1011";
                dp <= '0';

            when others =>
                number <= (val / 1000) mod 10;
                an <= "0111";
                dp <= '1';
        end case;
    end process;

    process(number)
    begin
        case number is
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
