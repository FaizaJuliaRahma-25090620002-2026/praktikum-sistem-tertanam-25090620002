library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_temperature is
end tb_temperature;

architecture sim of tb_temperature is

    signal clk : STD_LOGIC := '0';
    signal sw  : STD_LOGIC_VECTOR(11 downto 0)
        := (others => '0');

    signal seg : STD_LOGIC_VECTOR(6 downto 0);
    signal an  : STD_LOGIC_VECTOR(3 downto 0);
    signal dp  : STD_LOGIC;

begin

    clk <= not clk after 5 ns;

    uut: entity work.temperature_top
        port map (
            clk => clk,
            sw  => sw,
            seg => seg,
            an  => an,
            dp  => dp
        );

    process
    begin
        -- ADC = 0, suhu 0 derajat Celsius
        sw <= std_logic_vector(to_unsigned(0, 12));
        wait for 20 ns;

        -- ADC = 2048, suhu sekitar 50 derajat Celsius
        sw <= std_logic_vector(to_unsigned(2048, 12));
        wait for 20 ns;

        -- ADC = 4095, suhu 100 derajat Celsius
        sw <= std_logic_vector(to_unsigned(4095, 12));
        wait for 20 ns;

        report "Simulasi konversi suhu selesai."
            severity note;

        wait;
    end process;

end sim;
