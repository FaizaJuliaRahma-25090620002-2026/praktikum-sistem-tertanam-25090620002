library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer_2ff_top is
    Port (
        clk  : in  STD_LOGIC;
        btnC : in  STD_LOGIC;
        led  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end synchronizer_2ff_top;

architecture Behavioral of synchronizer_2ff_top is

    signal sync_out : STD_LOGIC;
    signal sync_prev : STD_LOGIC := '0';
    signal led_state : STD_LOGIC := '0';

begin

    U1: entity work.synchronizer_2ff
        port map (
            clk      => clk,
            async_in => btnC,
            sync_out => sync_out
        );

    process(clk)
    begin
        if rising_edge(clk) then

            if sync_out = '1' and sync_prev = '0' then
                led_state <= not led_state;
            end if;

            sync_prev <= sync_out;

        end if;
    end process;

    led(0) <= led_state;
    led(7 downto 1) <= (others => '0');

end Behavioral;