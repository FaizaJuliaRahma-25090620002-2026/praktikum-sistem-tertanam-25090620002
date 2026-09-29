library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detected is
    Port (
        clk   : in  STD_LOGIC;
        sig_in : in  STD_LOGIC;
        pulse : out STD_LOGIC
    );
end edge_detected;

architecture Behavioral of edge_detected is
    signal prev : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            prev <= sig_in;
        end if;
    end process;

    -- Pulsa 1 siklus saat terjadi rising edge
    pulse <= sig_in and not prev;

end Behavioral;