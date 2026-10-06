library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider_1mhz is
    Port (
        clk_100mhz : in  STD_LOGIC;
        clk_1mhz   : out STD_LOGIC
    );
end clock_divider_1mhz;

architecture Behavioral of clock_divider_1mhz is

    signal counter : integer range 0 to 4 := 0;
    signal clk_reg : STD_LOGIC := '0';

begin

    process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then

            if counter = 4 then
                counter <= 0;
                clk_reg <= not clk_reg;
            else
                counter <= counter + 1;
            end if;

        end if;
    end process;

    clk_1mhz <= clk_reg;

end Behavioral;