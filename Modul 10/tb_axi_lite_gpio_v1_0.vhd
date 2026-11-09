library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_axi_lite_gpio_v1_0 is
end tb_axi_lite_gpio_v1_0;

architecture sim of tb_axi_lite_gpio_v1_0 is
    constant CLK_PERIOD : time := 10 ns;

    signal S_AXI_ACLK     : std_logic := '0';
    signal S_AXI_ARESETN  : std_logic := '0';

    signal S_AXI_AWADDR  : std_logic_vector(3 downto 0) := (others => '0');
    signal S_AXI_AWVALID : std_logic := '0';
    signal S_AXI_AWREADY : std_logic;

    signal S_AXI_WDATA   : std_logic_vector(31 downto 0) := (others => '0');
    signal S_AXI_WVALID  : std_logic := '0';
    signal S_AXI_WREADY  : std_logic;

    signal S_AXI_BRESP   : std_logic_vector(1 downto 0);
    signal S_AXI_BVALID  : std_logic;
    signal S_AXI_BREADY  : std_logic := '0';

    signal S_AXI_ARADDR  : std_logic_vector(3 downto 0) := (others => '0');
    signal S_AXI_ARVALID : std_logic := '0';
    signal S_AXI_ARREADY : std_logic;

    signal S_AXI_RDATA   : std_logic_vector(31 downto 0);
    signal S_AXI_RRESP   : std_logic_vector(1 downto 0);
    signal S_AXI_RVALID  : std_logic;
    signal S_AXI_RREADY  : std_logic := '0';

    signal gpio_out : std_logic_vector(15 downto 0);
    signal sw       : std_logic_vector(15 downto 0) := (others => '0');
    signal sim_done : std_logic := '0';

begin
    -- Clock 100 MHz (period 10 ns); stop when all checks have completed.
    CLOCK_GEN : process
    begin
        while sim_done = '0' loop
            S_AXI_ACLK <= '0';
            wait for CLK_PERIOD / 2;
            S_AXI_ACLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Device Under Test
    DUT : entity work.axi_lite_gpio_v1_0
        generic map (
            C_S_AXI_ADDR_WIDTH => 4,
            C_S_AXI_DATA_WIDTH => 32
        )
        port map (
            S_AXI_ACLK     => S_AXI_ACLK,
            S_AXI_ARESETN  => S_AXI_ARESETN,

            S_AXI_AWADDR   => S_AXI_AWADDR,
            S_AXI_AWVALID  => S_AXI_AWVALID,
            S_AXI_AWREADY  => S_AXI_AWREADY,

            S_AXI_WDATA    => S_AXI_WDATA,
            S_AXI_WVALID   => S_AXI_WVALID,
            S_AXI_WREADY   => S_AXI_WREADY,

            S_AXI_BRESP    => S_AXI_BRESP,
            S_AXI_BVALID   => S_AXI_BVALID,
            S_AXI_BREADY   => S_AXI_BREADY,

            S_AXI_ARADDR   => S_AXI_ARADDR,
            S_AXI_ARVALID  => S_AXI_ARVALID,
            S_AXI_ARREADY  => S_AXI_ARREADY,

            S_AXI_RDATA    => S_AXI_RDATA,
            S_AXI_RRESP    => S_AXI_RRESP,
            S_AXI_RVALID  => S_AXI_RVALID,
            S_AXI_RREADY  => S_AXI_RREADY,

            gpio_out       => gpio_out,
            sw             => sw
        );

    STIMULUS : process
    begin
        report "TEST START: AXI-Lite GPIO standalone testbench" severity note;

        -- 1. Reset
        S_AXI_ARESETN <= '0';
        wait for 3 * CLK_PERIOD;
        wait until falling_edge(S_AXI_ACLK);
        S_AXI_ARESETN <= '1';
        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        assert gpio_out = x"0000"
            report "FAIL: gpio_out is not zero after reset" severity failure;
        report "PASS: reset" severity note;

        -- 2. Write 0x0000A55A to register 0 (address 0x0).
        -- AW and W channels are presented together and accepted independently.
        wait until falling_edge(S_AXI_ACLK);
        S_AXI_AWADDR  <= x"0";
        S_AXI_WDATA   <= x"0000A55A";
        S_AXI_AWVALID <= '1';
        S_AXI_WVALID  <= '1';

        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        S_AXI_AWVALID <= '0';
        S_AXI_WVALID  <= '0';

        -- The DUT stores address/data first, then executes the write on the next clock.
        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        assert S_AXI_BVALID = '1'
            report "FAIL: write response BVALID was not asserted" severity failure;
        assert S_AXI_BRESP = "00"
            report "FAIL: write response BRESP is not OKAY" severity failure;
        assert gpio_out = x"A55A"
            report "FAIL: gpio_out does not match written value 0xA55A" severity failure;
        report "PASS: AXI-Lite write register 0; gpio_out = 0xA55A" severity note;

        -- Complete write response handshake.
        wait until falling_edge(S_AXI_ACLK);
        S_AXI_BREADY <= '1';
        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        S_AXI_BREADY <= '0';
        assert S_AXI_BVALID = '0'
            report "FAIL: BVALID did not clear after BREADY handshake" severity failure;

        -- 3. Read register 0 (address 0x0), expect 0x0000A55A.
        wait until falling_edge(S_AXI_ACLK);
        S_AXI_ARADDR  <= x"0";
        S_AXI_ARVALID <= '1';
        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        S_AXI_ARVALID <= '0';
        assert S_AXI_RVALID = '1'
            report "FAIL: read response RVALID was not asserted for register 0" severity failure;
        assert S_AXI_RRESP = "00"
            report "FAIL: read response RRESP is not OKAY" severity failure;
        assert S_AXI_RDATA = x"0000A55A"
            report "FAIL: register 0 readback does not match 0x0000A55A" severity failure;
        report "PASS: AXI-Lite read register 0 = 0x0000A55A" severity note;

        wait until falling_edge(S_AXI_ACLK);
        S_AXI_RREADY <= '1';
        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        S_AXI_RREADY <= '0';
        assert S_AXI_RVALID = '0'
            report "FAIL: RVALID did not clear after RREADY handshake" severity failure;

        -- 4. Set switches and allow reg1 to sample them.
        sw <= x"A35C";
        wait until rising_edge(S_AXI_ACLK);
        wait until rising_edge(S_AXI_ACLK);

        -- Read register 1 (address 0x4), expect zero-extended switch value.
        wait until falling_edge(S_AXI_ACLK);
        S_AXI_ARADDR  <= x"4";
        S_AXI_ARVALID <= '1';
        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        S_AXI_ARVALID <= '0';
        assert S_AXI_RVALID = '1'
            report "FAIL: read response RVALID was not asserted for register 1" severity failure;
        assert S_AXI_RDATA = x"0000A35C"
            report "FAIL: register 1 readback does not match switch value 0xA35C" severity failure;
        report "PASS: AXI-Lite read register 1; switch value = 0xA35C" severity note;

        wait until falling_edge(S_AXI_ACLK);
        S_AXI_RREADY <= '1';
        wait until rising_edge(S_AXI_ACLK);
        wait for 1 ns;
        S_AXI_RREADY <= '0';

        report "ALL TESTS PASSED: AXI-Lite GPIO read/write checks completed" severity note;
        sim_done <= '1';
        wait;
    end process;
end sim;
