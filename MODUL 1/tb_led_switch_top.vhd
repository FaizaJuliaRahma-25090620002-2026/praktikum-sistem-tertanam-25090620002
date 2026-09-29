library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_led_switch_top is
end tb_led_switch_top;

architecture Behavioral of tb_led_switch_top is
    component led_switch_top
        Port (
            sw  : in  STD_LOGIC_VECTOR (7 downto 0);
            led : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal sw_tb  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal led_tb : STD_LOGIC_VECTOR (7 downto 0);

begin
    uut: led_switch_top Port Map (
        sw  => sw_tb,
        led => led_tb
    );

    stim_proc: process
    begin
        sw_tb <= "00000000"; wait for 100 ns;
        sw_tb <= "11111111"; wait for 100 ns;
        sw_tb <= "10101010"; wait for 100 ns;
        sw_tb <= "00001111"; wait for 100 ns;
        wait;
    end process;
end Behavioral;