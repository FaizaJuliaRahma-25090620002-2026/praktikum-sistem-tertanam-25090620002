
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_q8_8 is
    Port (
        a   : in  unsigned(15 downto 0);
        b   : in  unsigned(15 downto 0);
        res : out unsigned(15 downto 0)
    );
end fixed_mul_q8_8;

architecture Behavioral of fixed_mul_q8_8 is
    signal product : unsigned(31 downto 0);
begin
    product <= a * b;

    -- Q8.8 x Q8.8 menghasilkan Q16.16.
    -- Ambil bit 23 downto 8 untuk kembali ke Q8.8.
    res <= product(23 downto 8);
end Behavioral;
