library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce_2 is
    generic (
        CLK_FREQ_HZ : integer := 10_000_000;
        STABLE_MS   : integer := 10
    );

    Port (
        clk        : in  STD_LOGIC;
        button_in  : in  STD_LOGIC;
        button_out : out STD_LOGIC
    );
end debounce_2;

architecture Behavioral of debounce_2 is

    constant COUNT_MAX : integer :=
        (CLK_FREQ_HZ / 1000) * STABLE_MS;

    signal counter : integer range 0 to COUNT_MAX := 0;
    signal button_sync : STD_LOGIC := '0';
    signal button_state : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- Synchronizer sederhana
            button_sync <= button_in;

            -- Jika kondisi tombol berbeda dari kondisi stabil
            if button_sync /= button_state then

                if counter < COUNT_MAX then
                    counter <= counter + 1;
                else
                    button_state <= button_sync;
                    counter <= 0;
                end if;

            else
                counter <= 0;
            end if;

        end if;
    end process;

    button_out <= button_state;

end Behavioral;