library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js03_top is
    Port (
        sw  : in  STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0)
    );
end js03_top;

architecture Behavioral of js03_top is

    signal result_s : STD_LOGIC_VECTOR (7 downto 0);
    signal carry_s  : STD_LOGIC;

begin

    U1 : entity work.alu4
        port map (
            a      => sw(3 downto 0),
            b      => sw(7 downto 4),
            opcode => sw(9 downto 8),
            result => result_s,
            carry  => carry_s
        );

    -- Hasil ALU ditampilkan pada LED0 sampai LED7
    led(7 downto 0) <= result_s;

    -- Carry ditampilkan pada LED8
    led(8) <= carry_s;

    -- LED lainnya dimatikan
    led(15 downto 9) <= (others => '0');

end Behavioral;