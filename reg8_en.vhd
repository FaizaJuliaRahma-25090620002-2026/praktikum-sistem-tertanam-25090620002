library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8_en is
    Port (
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        en  : in  STD_LOGIC;
        d   : in  STD_LOGIC_VECTOR (7 downto 0);
        q   : out STD_LOGIC_VECTOR (7 downto 0)
    );
end reg8_en;

architecture Behavioral of reg8_en is
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= (others => '0');
            elsif en = '1' then
                q <= d;
            end if;
        end if;
    end process;

end Behavioral;