
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_top is
    Port (
        clk : in  STD_LOGIC;
        sw  : in  STD_LOGIC_VECTOR(7 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0);
        an  : out STD_LOGIC_VECTOR(3 downto 0);
        dp  : out STD_LOGIC
    );
end fixed_mul_top;

architecture Behavioral of fixed_mul_top is
    signal a         : unsigned(3 downto 0);
    signal b         : unsigned(3 downto 0);
    signal product   : unsigned(7 downto 0);
    signal disp_value : unsigned(10 downto 0);
begin
    a <= unsigned(sw(3 downto 0));
    b <= unsigned(sw(7 downto 4));

    -- Q2.2 x Q2.2 menghasilkan Q4.4
    product <= a * b;

    -- Konversi ke angka desimal dengan dua digit pecahan.
    -- Nilai Q4.4 = product / 16.
    -- Tampilan dua desimal = product * 100 / 16.
    disp_value <= to_unsigned(
        (to_integer(product) * 25) / 4, 11
    );

    U_SEG : entity work.seven_seg_unsigned
        port map (
            clk   => clk,
            value => disp_value,
            seg   => seg,
            an    => an,
            dp    => dp
        );
end Behavioral;
