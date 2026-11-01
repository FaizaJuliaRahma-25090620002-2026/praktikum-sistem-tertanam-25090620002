
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_top3 is
    Port (
        clk : in  STD_LOGIC;
        sw  : in  STD_LOGIC_VECTOR(7 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0);
        dp  : out STD_LOGIC;
        an  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end fixed_mul_top3;

architecture Behavioral of fixed_mul_top3 is
    signal a_q88 : STD_LOGIC_VECTOR(15 downto 0);
    signal b_q88 : STD_LOGIC_VECTOR(15 downto 0);
    signal result_q88 : STD_LOGIC_VECTOR(15 downto 0);
    signal disp_value : unsigned(10 downto 0);
begin
    -- Dua input Q2.2 dikonversi ke format Q8.8
    a_q88 <= std_logic_vector(
        shift_left(resize(unsigned(sw(3 downto 0)), 16), 6)
    );

    b_q88 <= std_logic_vector(
        shift_left(resize(unsigned(sw(7 downto 4)), 16), 6)
    );

    U_PIPE3 : entity work.fixed_mul_pipe3
        port map (
            clk    => clk,
            a      => a_q88,
            b      => b_q88,
            result => result_q88
        );

    -- Ubah hasil Q8.8 menjadi angka dengan dua digit desimal
    disp_value <= to_unsigned(
        (to_integer(unsigned(result_q88)) * 25) / 64,
        11
    );

    U_DISPLAY : entity work.seven_seg_unsigned
        port map (
            clk   => clk,
            value => disp_value,
            seg   => seg,
            an    => an,
            dp    => dp
        );
end Behavioral;
