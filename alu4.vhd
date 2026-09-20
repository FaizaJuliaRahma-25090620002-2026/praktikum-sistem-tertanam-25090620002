library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu4 is
    Port (
        a      : in  STD_LOGIC_VECTOR (3 downto 0);
        b      : in  STD_LOGIC_VECTOR (3 downto 0);
        opcode : in  STD_LOGIC_VECTOR (1 downto 0);
        result : out STD_LOGIC_VECTOR (7 downto 0);
        carry  : out STD_LOGIC
    );
end alu4;

architecture Behavioral of alu4 is

    signal a_u : unsigned(3 downto 0);
    signal b_u : unsigned(3 downto 0);

begin

    a_u <= unsigned(a);
    b_u <= unsigned(b);

    process(a_u, b_u, opcode)
        variable temp : unsigned(7 downto 0);
    begin

        temp := (others => '0');
        carry <= '0';

        case opcode is

            -- 00 = Penjumlahan
            when "00" =>
                temp := resize(a_u, 8) + resize(b_u, 8);

                result <= STD_LOGIC_VECTOR(temp);

                if temp(4) = '1' then
                    carry <= '1';
                else
                    carry <= '0';
                end if;

            -- 01 = Pengurangan
            when "01" =>
                temp := resize(a_u, 8) - resize(b_u, 8);

                result <= STD_LOGIC_VECTOR(temp);

                if a_u >= b_u then
                    carry <= '0';
                else
                    carry <= '1';
                end if;

            -- 10 = Perkalian
            when "10" =>
                temp := a_u * b_u;

                result <= STD_LOGIC_VECTOR(temp);
                carry <= '0';

            -- 11 = Tidak digunakan
            when others =>
                result <= (others => '0');
                carry <= '0';

        end case;

    end process;

end Behavioral;