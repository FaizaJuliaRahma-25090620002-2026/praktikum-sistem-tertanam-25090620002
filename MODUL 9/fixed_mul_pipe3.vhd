library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_pipe3 is
    Port (
        clk    : in  STD_LOGIC;
        a      : in  STD_LOGIC_VECTOR(15 downto 0);
        b      : in  STD_LOGIC_VECTOR(15 downto 0);
        result : out STD_LOGIC_VECTOR(15 downto 0)
    );
end fixed_mul_pipe3;

architecture Behavioral of fixed_mul_pipe3 is

    signal p_ll_reg, p_lh_reg : unsigned(15 downto 0)
        := (others => '0');

    signal p_hl_reg, p_hh_reg : unsigned(15 downto 0)
        := (others => '0');

    signal product_sum_reg : unsigned(31 downto 0)
        := (others => '0');

    signal result_reg : STD_LOGIC_VECTOR(15 downto 0)
        := (others => '0');

begin
    process(clk)
        variable a_low, a_high : unsigned(7 downto 0);
        variable b_low, b_high : unsigned(7 downto 0);
    begin
        if rising_edge(clk) then

            -- Tahap 1: empat perkalian parsial
            a_low  := unsigned(a(7 downto 0));
            a_high := unsigned(a(15 downto 8));

            b_low  := unsigned(b(7 downto 0));
            b_high := unsigned(b(15 downto 8));

            p_ll_reg <= a_low * b_low;
            p_lh_reg <= a_low * b_high;
            p_hl_reg <= a_high * b_low;
            p_hh_reg <= a_high * b_high;

            -- Tahap 2: penjumlahan hasil parsial
            product_sum_reg <=
                resize(p_ll_reg, 32) +
                shift_left(resize(p_lh_reg, 32), 8) +
                shift_left(resize(p_hl_reg, 32), 8) +
                shift_left(resize(p_hh_reg, 32), 16);

            -- Tahap 3: scaling menjadi Q8.8
            result_reg <=
                std_logic_vector(product_sum_reg(23 downto 8));

        end if;
    end process;

    result <= result_reg;
end Behavioral;