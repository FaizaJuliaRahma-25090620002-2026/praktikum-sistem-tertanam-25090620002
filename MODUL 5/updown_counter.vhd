library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity updown_counter is
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        pulse_up   : in  std_logic;
        pulse_down : in  std_logic;
        count_out  : out std_logic_vector(15 downto 0)
    );
end updown_counter;

architecture Behavioral of updown_counter is

    signal count_reg : unsigned(15 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if reset = '1' then
                count_reg <= (others => '0');

            elsif pulse_up = '1' then
                count_reg <= count_reg + 1;

            elsif pulse_down = '1' then
                count_reg <= count_reg - 1;

            end if;

        end if;
    end process;

    count_out <= std_logic_vector(count_reg);

end Behavioral;