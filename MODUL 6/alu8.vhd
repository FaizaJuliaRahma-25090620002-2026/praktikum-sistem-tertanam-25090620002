library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu8 is
    Port (
        a      : in  STD_LOGIC_VECTOR(7 downto 0);
        b      : in  STD_LOGIC_VECTOR(7 downto 0);
        opcode : in  STD_LOGIC_VECTOR(1 downto 0);

        result : out STD_LOGIC_VECTOR(15 downto 0);
        carry  : out STD_LOGIC
    );
end alu8;

architecture Behavioral of alu8 is

    signal a_u : unsigned(7 downto 0);
    signal b_u : unsigned(7 downto 0);

    signal temp : unsigned(15 downto 0);

begin

    a_u <= unsigned(a);
    b_u <= unsigned(b);

    process(a_u, b_u, opcode)
    begin

        temp  <= (others => '0');
        carry <= '0';

        case opcode is

            --------------------------------------------------------
            -- 00 = ADD
            --------------------------------------------------------

            when "00" =>

                temp(8 downto 0) <=
                    ('0' & a_u) + ('0' & b_u);

                carry <= temp(8);


            --------------------------------------------------------
            -- 01 = SUBTRACT
            --------------------------------------------------------

            when "01" =>

                temp(7 downto 0) <=
                    a_u - b_u;

                carry <= '0';


            --------------------------------------------------------
            -- 10 = MULTIPLY
            --------------------------------------------------------

            when "10" =>

                temp <= a_u * b_u;

                carry <= '0';


            --------------------------------------------------------
            -- 11 = UNUSED
            --------------------------------------------------------

            when others =>

                temp  <= (others => '0');
                carry <= '0';

        end case;

    end process;

    result <= std_logic_vector(temp);

end Behavioral;