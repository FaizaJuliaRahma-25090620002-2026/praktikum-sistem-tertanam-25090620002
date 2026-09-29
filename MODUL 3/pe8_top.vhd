library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pe8_top is
    Port (
        sw  : in  STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0)
    );
end pe8_top;

architecture Behavioral of pe8_top is

    signal position_s : STD_LOGIC_VECTOR (2 downto 0);
    signal valid_s    : STD_LOGIC;

begin

    U1 : entity work.priority_encoder8
        port map (
            input_data => sw(7 downto 0),
            position   => position_s,
            valid      => valid_s
        );

    -- LED0 = bit posisi 0
    -- LED1 = bit posisi 1
    -- LED2 = bit posisi 2
    -- LED3 = valid

    led(2 downto 0) <= position_s;
    led(3) <= valid_s;

    -- LED lainnya dimatikan
    led(15 downto 4) <= (others => '0');

end Behavioral;