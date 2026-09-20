library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signed_top is
    Port (
        sw  : in  STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0)
    );
end signed_top;

architecture Behavioral of signed_top is

    signal result_s   : STD_LOGIC_VECTOR (3 downto 0);
    signal overflow_s : STD_LOGIC;

begin

    U1 : entity work.alu4_signed
        port map (
            a        => sw(3 downto 0),
            b        => sw(7 downto 4),
            opcode   => "00",
            result   => result_s,
            overflow => overflow_s
        );

    -- LED0-LED3 = hasil
    led(3 downto 0) <= result_s;

    -- LED4 = overflow
    led(4) <= overflow_s;

    -- LED lainnya dimatikan
    led(15 downto 5) <= (others => '0');

end Behavioral;