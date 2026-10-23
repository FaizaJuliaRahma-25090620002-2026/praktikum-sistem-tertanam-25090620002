library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bram_256x8 is
end tb_bram_256x8;

architecture Behavioral of tb_bram_256x8 is

    signal clk  : STD_LOGIC := '0';
    signal we   : STD_LOGIC := '0';
    signal addr : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal din  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal dout : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: entity work.bram_256x8
        port map (
            clk  => clk,
            we   => we,
            addr => addr,
            din  => din,
            dout => dout
        );

    -- Pembangkitan clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Pengujian satu kali
    stimulus_process: process
    begin

        -- Menulis data 0x55 ke alamat 10
        wait until falling_edge(clk);
        we   <= '1';
        addr <= std_logic_vector(to_unsigned(10, addr'length));
        din  <= x"55";

        wait until rising_edge(clk);

        -- Beralih ke mode baca
        wait until falling_edge(clk);
        we <= '0';

        -- Membaca data dari alamat 10
        wait until rising_edge(clk);
        wait for 1 ns;

        -- Memverifikasi hasil pembacaan
        assert dout = x"55"
            report "ERROR: Data yang dibaca tidak sesuai!"
            severity error;

        report "PASS: Data 0x55 berhasil dibaca dari alamat 10."
            severity note;

        wait;
    end process;

end Behavioral;