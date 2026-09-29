library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity piso8 is
    Port (
        clk  : in  STD_LOGIC;
        load : in  STD_LOGIC;
        d    : in  STD_LOGIC_VECTOR (7 downto 0);
        sout : out STD_LOGIC
    );
end piso8;

architecture Behavioral of piso8 is
    signal shift_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                shift_reg <= d;
            else
                shift_reg <= shift_reg(6 downto 0) & '0';
            end if;
        end if;
    end process;

    sout <= shift_reg(7);

end Behavioral;