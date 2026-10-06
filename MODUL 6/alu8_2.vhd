library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu8_2 is
    Port (
        a      : in  STD_LOGIC_VECTOR(7 downto 0);
        b      : in  STD_LOGIC_VECTOR(7 downto 0);
        opcode : in  STD_LOGIC_VECTOR(1 downto 0);
        result : out STD_LOGIC_VECTOR(15 downto 0);
        carry  : out STD_LOGIC
    );
end alu8_2;

architecture Behavioral of alu8_2 is
begin

    process(a, b, opcode)
        variable a_u      : unsigned(7 downto 0);
        variable b_u      : unsigned(7 downto 0);
        variable add_u    : unsigned(8 downto 0);
        variable result_u : unsigned(15 downto 0);
    begin

        a_u := unsigned(a);
        b_u := unsigned(b);

        result_u := (others => '0');
        carry <= '0';

        case opcode is

            -- ADD
            when "00" =>
                add_u := ('0' & a_u) + ('0' & b_u);
                result_u(8 downto 0) := add_u;
                carry <= add_u(8);

            -- SUBTRACT
            when "01" =>
                result_u(7 downto 0) := a_u - b_u;

            -- MULTIPLY
            when "10" =>
                result_u := a_u * b_u;

            -- DIVIDE
            when "11" =>
                if b_u = 0 then
                    result_u := (others => '0');
                else
                    result_u(7 downto 0) := a_u / b_u;
                end if;

            when others =>
                result_u := (others => '0');
                carry <= '0';

        end case;

        result <= std_logic_vector(result_u);

    end process;

end Behavioral;