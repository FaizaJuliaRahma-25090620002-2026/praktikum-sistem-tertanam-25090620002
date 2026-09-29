library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_piso8 is
    Port (
        clk  : in  STD_LOGIC;
        btnC : in  STD_LOGIC;
        sw   : in  STD_LOGIC_VECTOR(7 downto 0);
        led  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end top_piso8;

architecture Behavioral of top_piso8 is

    signal slow_clk : STD_LOGIC := '0';
    signal counter  : unsigned(25 downto 0) := (others => '0');
    signal sout     : STD_LOGIC;

begin

    -- Clock divider 100 MHz menjadi sekitar 1 Hz
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = 49999999 then
                counter <= (others => '0');
                slow_clk <= not slow_clk;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- PISO
    U1: entity work.piso8
        port map (
            clk  => slow_clk,
            load => btnC,
            d    => sw,
            sout => sout
        );

    -- Output serial
    led(0) <= sout;

    -- LED lainnya dimatikan
    led(7 downto 1) <= (others => '0');

end Behavioral;