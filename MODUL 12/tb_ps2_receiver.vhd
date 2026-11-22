library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ps2_receiver is
end tb_ps2_receiver;

architecture sim of tb_ps2_receiver is
    constant CLK_PERIOD : time := 10 ns;     -- 100 MHz
    constant PS2_HALF   : time := 30 us;     -- periode PS/2 clock 60 us (~16,7 kHz)

    signal clk        : std_logic := '0';
    signal ps2_clk    : std_logic := '1';
    signal ps2_data   : std_logic := '1';
    signal scan_code  : std_logic_vector(7 downto 0);
    signal data_ready : std_logic;

    signal got_code   : std_logic_vector(7 downto 0) := (others => '0');
    signal got_count  : integer := 0;
begin
    clk <= not clk after CLK_PERIOD/2;

    dut : entity work.ps2_receiver
        port map (clk => clk, ps2_clk => ps2_clk, ps2_data => ps2_data,
                  scan_code => scan_code, data_ready => data_ready);

    -- monitor: tangkap setiap pulsa data_ready
    process(clk)
    begin
        if rising_edge(clk) then
            if data_ready = '1' then
                got_code  <= scan_code;
                got_count <= got_count + 1;
            end if;
        end if;
    end process;

    stim : process
        procedure send_byte(b : in std_logic_vector(7 downto 0)) is
            variable frame : std_logic_vector(10 downto 0);
            variable ones  : integer := 0;
            variable par   : std_logic;
        begin
            for i in 0 to 7 loop
                if b(i) = '1' then ones := ones + 1; end if;
            end loop;
            if (ones mod 2) = 0 then par := '1'; else par := '0'; end if;  -- odd parity
            frame := '1' & par & b & '0';   -- (10)=stop (9)=parity (8..1)=data (0)=start
            for i in 0 to 10 loop
                ps2_data <= frame(i);       -- data stabil sebelum clock turun
                wait for PS2_HALF/2;
                ps2_clk  <= '0';            -- tepi turun -> FPGA sampling
                wait for PS2_HALF;
                ps2_clk  <= '1';
                wait for PS2_HALF/2;
            end loop;
            ps2_data <= '1';
            wait for 100 us;                -- jeda antar byte
        end procedure;
    begin
        wait for 1 us;

        send_byte(x"1C");                   -- tombol 'A'
        assert got_count = 1 report "Uji1 GAGAL: data_ready tidak berpulsa tepat 1x" severity failure;
        assert got_code = x"1C" report "Uji1 GAGAL: scan_code /= 0x1C" severity failure;
        report "Uji1 LULUS: A -> 0x1C";

        send_byte(x"F0");                   -- break code A
        assert got_count = 2 and got_code = x"F0" report "Uji2a GAGAL" severity failure;
        send_byte(x"1C");
        assert got_count = 3 and got_code = x"1C" report "Uji2b GAGAL" severity failure;
        report "Uji2 LULUS: break code F0 1C";

        send_byte(x"32");
        assert got_code = x"32" report "Uji3a GAGAL (0x32)" severity failure;
        send_byte(x"45");
        assert got_code = x"45" report "Uji3b GAGAL (0x45)" severity failure;
        report "Uji3 LULUS: 0x32 dan 0x45";

        report "SEMUA UJI LULUS - ps2_receiver OK";
        std.env.finish;
    end process;
end sim;