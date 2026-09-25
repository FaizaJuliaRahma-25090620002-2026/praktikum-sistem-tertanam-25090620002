library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer_2ff is
    Port (
        clk      : in  STD_LOGIC;
        async_in : in  STD_LOGIC;
        sync_out : out STD_LOGIC
    );
end synchronizer_2ff;

architecture Behavioral of synchronizer_2ff is
    signal sync_ff1 : STD_LOGIC := '0';
    signal sync_ff2 : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            sync_ff1 <= async_in;
            sync_ff2 <= sync_ff1;
        end if;
    end process;

    sync_out <= sync_ff2;

end Behavioral;