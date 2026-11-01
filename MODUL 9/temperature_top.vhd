
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temperature_top is
    Port (
        clk : in  STD_LOGIC;
        sw  : in  STD_LOGIC_VECTOR(11 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0);
        dp  : out STD_LOGIC;
        an  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end temperature_top;

architecture Behavioral of temperature_top is
    signal adc_value : unsigned(11 downto 0);
    signal temp_c    : unsigned(6 downto 0);
    signal disp_value : unsigned(10 downto 0);
begin
    adc_value <= unsigned(sw);

    process(adc_value)
        variable temp_int : integer range 0 to 409500;
    begin
        temp_int := to_integer(adc_value) * 100;
        temp_c <= to_unsigned(temp_int / 4095, 7);
    end process;

    -- Tampilkan suhu sebagai angka bulat, misalnya 25 = 25°C
    disp_value <= resize(temp_c, 11);

    U_DISPLAY : entity work.seven_seg_temperature
        port map (
            clk   => clk,
            value => disp_value,
            seg   => seg,
            an    => an,
            dp    => dp
        );
end Behavioral;
