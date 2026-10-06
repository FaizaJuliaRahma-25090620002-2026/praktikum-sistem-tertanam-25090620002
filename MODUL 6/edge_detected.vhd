library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detect is
    Port (
        clk       : in  STD_LOGIC;
        signal_in : in  STD_LOGIC;
        pulse     : out STD_LOGIC
    );
end edge_detect;

architecture Behavioral of edge_detect is

    signal signal_prev : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            signal_prev <= signal_in;
        end if;
    end process;

    pulse <= signal_in and not signal_prev;

end Behavioral;