library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity priority_encoder8 is
    Port (
        input_data : in  STD_LOGIC_VECTOR (7 downto 0);
        position   : out STD_LOGIC_VECTOR (2 downto 0);
        valid      : out STD_LOGIC
    );
end priority_encoder8;

architecture Behavioral of priority_encoder8 is

begin

    process(input_data)
    begin

        position <= "000";
        valid <= '0';

        if input_data(7) = '1' then
            position <= "111";
            valid <= '1';

        elsif input_data(6) = '1' then
            position <= "110";
            valid <= '1';

        elsif input_data(5) = '1' then
            position <= "101";
            valid <= '1';

        elsif input_data(4) = '1' then
            position <= "100";
            valid <= '1';

        elsif input_data(3) = '1' then
            position <= "011";
            valid <= '1';

        elsif input_data(2) = '1' then
            position <= "010";
            valid <= '1';

        elsif input_data(1) = '1' then
            position <= "001";
            valid <= '1';

        elsif input_data(0) = '1' then
            position <= "000";
            valid <= '1';

        else
            position <= "000";
            valid <= '0';

        end if;

    end process;

end Behavioral;