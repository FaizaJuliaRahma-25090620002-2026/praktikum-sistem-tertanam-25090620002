
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bram_1024x8 is
end tb_bram_1024x8;

architecture Behavioral of tb_bram_1024x8 is

    constant CLK_PERIOD : time := 10 ns;

    signal clk  : STD_LOGIC := '0';
    signal we   : STD_LOGIC := '0';
    signal addr : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal din  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal dout : STD_LOGIC_VECTOR(7 downto 0);

begin

    uut : entity work.bram_1024x8
        port map (
            clk  => clk,
            we   => we,
            addr => addr,
            din  => din,
            dout => dout
        );

    -- Clock 100 MHz
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Percobaan 1: tulis dan baca alamat 0
    stimulus_process : process
    begin
        -- Tulis data 0x12 ke alamat 0
        wait until falling_edge(clk);
        addr <= std_logic_vector(to_unsigned(0, 10));
        din  <= x"12";
        we   <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Matikan write
        wait until falling_edge(clk);
        we <= '0';

        -- Baca data dari alamat 0
        wait until rising_edge(clk);
        wait for 1 ns;

        assert dout = x"12"
            report "FAIL: Data pada alamat 0 tidak sesuai"
            severity error;

        report "PASS: Alamat 0, data = 0x12"
            severity note;

        wait;
    end process;

end Behavioral;
