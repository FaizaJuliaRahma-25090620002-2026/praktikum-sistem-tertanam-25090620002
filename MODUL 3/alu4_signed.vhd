library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu4_signed is
    Port (
        a      : in  STD_LOGIC_VECTOR (3 downto 0);
        b      : in  STD_LOGIC_VECTOR (3 downto 0);
        opcode : in  STD_LOGIC_VECTOR (1 downto 0);
        result : out STD_LOGIC_VECTOR (3 downto 0);
        overflow : out STD_LOGIC
    );
end alu4_signed;

architecture Behavioral of alu4_signed is

    signal a_s : signed(3 downto 0);
    signal b_s : signed(3 downto 0);

begin

    a_s <= signed(a);
    b_s <= signed(b);

    process(a_s, b_s, opcode)

        variable temp : signed(4 downto 0);

    begin

        temp := (others => '0');
        overflow <= '0';

        case opcode is

            -- Penjumlahan
            when "00" =>

                temp := resize(a_s, 5) + resize(b_s, 5);

                result <= STD_LOGIC_VECTOR(temp(3 downto 0));

                -- Overflow:
                -- positif + positif = negatif
                -- negatif + negatif = positif

                if (a_s(3) = b_s(3)) and
                   (temp(3) /= a_s(3)) then

                    overflow <= '1';

                else
                    overflow <= '0';

                end if;

            -- Pengurangan
            when "01" =>

                temp := resize(a_s, 5) - resize(b_s, 5);

                result <= STD_LOGIC_VECTOR(temp(3 downto 0));

                -- Overflow pengurangan
                if (a_s(3) /= b_s(3)) and
                   (temp(3) /= a_s(3)) then

                    overflow <= '1';

                else
                    overflow <= '0';

                end if;

            when others =>

                result <= (others => '0');
                overflow <= '0';

        end case;

    end process;

end Behavioral;