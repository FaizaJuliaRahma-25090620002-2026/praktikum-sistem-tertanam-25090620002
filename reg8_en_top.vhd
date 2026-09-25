library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8_en_top is
    Port (
        clk  : in  STD_LOGIC;
        btnC : in  STD_LOGIC;
        btnU : in  STD_LOGIC;
        sw   : in  STD_LOGIC_VECTOR (7 downto 0);
        led  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end reg8_en_top;

architecture Behavioral of reg8_en_top is

begin

    U1: entity work.reg8_en
        port map (
            clk => clk,
            rst => btnU,
            en  => btnC,
            d   => sw,
            q   => led
        );

end Behavioral;