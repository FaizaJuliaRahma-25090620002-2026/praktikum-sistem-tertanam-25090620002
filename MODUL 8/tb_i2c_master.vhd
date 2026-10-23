library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;

entity tb_i2c_master is
end entity tb_i2c_master;

architecture sim of tb_i2c_master is

    constant CLK_PERIOD : time := 10 ns;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal start      : std_logic := '0';

    signal slave_addr : std_logic_vector(6 downto 0)
                       := "1010000";

    signal data_in    : std_logic_vector(7 downto 0)
                       := std_logic_vector(to_unsigned(165, 8));

    signal scl        : std_logic;
    signal sda_bus    : std_logic;
    signal slave_sda  : std_logic := 'Z';

    signal busy       : std_logic;
    signal done       : std_logic;
    signal ack_error  : std_logic;

begin

    -- Clock FPGA 100 MHz
    clk <= not clk after CLK_PERIOD / 2;

    -- Jalur SDA:
    -- 'H' mewakili pull-up lemah
    -- slave_sda mewakili respons slave
    sda_bus <= 'H';
    sda_bus <= slave_sda;

    -- Unit Under Test: I2C Master
    uut: entity work.i2c_master
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            I2C_FREQ_HZ => 100_000
        )
        port map (
            clk        => clk,
            rst        => rst,
            start      => start,
            slave_addr => slave_addr,
            data_in    => data_in,
            scl        => scl,
            sda        => sda_bus,
            busy       => busy,
            done       => done,
            ack_error  => ack_error
        );

    -- Slave tiruan untuk memberikan ACK
    slave_ack: process
    begin
        slave_sda <= 'Z';

        -- Menunggu 8 bit alamat beserta bit WRITE
        for i in 1 to 8 loop
            wait until rising_edge(scl);
        end loop;

        -- ACK setelah alamat
        wait until falling_edge(scl);
        slave_sda <= '0';

        wait until rising_edge(scl);
        wait until falling_edge(scl);
        slave_sda <= 'Z';

        -- Menunggu 8 bit data
        for i in 1 to 8 loop
            wait until rising_edge(scl);
        end loop;

        -- ACK setelah data
        wait until falling_edge(scl);
        slave_sda <= '0';

        wait until rising_edge(scl);
        wait until falling_edge(scl);
        slave_sda <= 'Z';

        wait;
    end process;

    -- Proses stimulus dan verifikasi
    stimulus: process
    begin
        rst   <= '1';
        start <= '0';

        wait for 100 ns;

        wait until falling_edge(clk);
        rst <= '0';

        -- Memulai transaksi I2C
        wait until falling_edge(clk);
        start <= '1';

        wait until busy = '1';

        wait until falling_edge(clk);
        start <= '0';

        -- Menunggu transaksi selesai
        wait until done = '1';
        wait for 1 ns;

        assert ack_error = '0'
            report "GAGAL: ACK tidak diterima"
            severity failure;

        assert busy = '0'
            report "GAGAL: busy masih aktif"
            severity failure;

        report
            "PASS: transaksi I2C WRITE berhasil, ACK diterima"
            severity note;

        stop;
        wait;
    end process;

end architecture sim;