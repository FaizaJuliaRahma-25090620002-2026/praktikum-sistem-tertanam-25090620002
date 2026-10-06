library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    generic (
        CLK_FREQ_HZ : integer := 10_000_000;
        STABLE_MS   : integer := 10
    );
    Port (
        clk     : in  STD_LOGIC;
        btn_in  : in  STD_LOGIC;
        btn_out : out STD_LOGIC
    );
end debounce;

architecture Behavioral of debounce is

    constant COUNT_MAX : integer :=
        (CLK_FREQ_HZ / 1000) * STABLE_MS;

    signal counter : integer range 0 to COUNT_MAX := 0;
    signal state   : STD_LOGIC := '0';

begin

    process(clk)
    begin

        if rising_edge(clk) then

            if btn_in = state then
                counter <= 0;

            elsif counter = COUNT_MAX then
                state <= btn_in;
                counter <= 0;

            else
                counter <= counter + 1;

            end if;

        end if;

    end process;

    btn_out <= state;

end Behavioral;