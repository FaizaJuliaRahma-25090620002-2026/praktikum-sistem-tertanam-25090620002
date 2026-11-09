library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Custom AXI4-Lite GPIO IP
-- Register map:
--   0x00 : reg0, GPIO output / LED (read-write)
--   0x04 : reg1, switch input       (read-only)
--   0x08 : reg2, reserved            (read-write)
--   0x0C : reg3, reserved            (read-write)

entity axi_lite_gpio_v1_0 is
    generic (
        C_S_AXI_DATA_WIDTH : integer := 32;
        C_S_AXI_ADDR_WIDTH : integer := 4
    );
    port (
        S_AXI_ACLK    : in  std_logic;
        S_AXI_ARESETN : in  std_logic;

        -- AXI4-Lite write address channel
        S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWVALID : in  std_logic;
        S_AXI_AWREADY : out std_logic;

        -- AXI4-Lite write data channel
        S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WVALID  : in  std_logic;
        S_AXI_WREADY  : out std_logic;

        -- AXI4-Lite write response channel
        S_AXI_BRESP   : out std_logic_vector(1 downto 0);
        S_AXI_BVALID  : out std_logic;
        S_AXI_BREADY  : in  std_logic;

        -- AXI4-Lite read address channel
        S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARVALID : in  std_logic;
        S_AXI_ARREADY : out std_logic;

        -- AXI4-Lite read data channel
        S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP   : out std_logic_vector(1 downto 0);
        S_AXI_RVALID  : out std_logic;
        S_AXI_RREADY  : in  std_logic;

        -- GPIO interface
        gpio_out      : out std_logic_vector(15 downto 0);
        sw            : in  std_logic_vector(15 downto 0)
    );
end axi_lite_gpio_v1_0;

architecture arch_imp of axi_lite_gpio_v1_0 is

    -- Internal READY signals. These avoid reading output ports internally,
    -- which is not permitted by the VHDL language mode used by Vivado here.
    signal axi_awready_i : std_logic := '0';
    signal axi_wready_i  : std_logic := '0';
    signal axi_arready_i : std_logic := '0';

    -- Write channel registers
    signal axi_awaddr_reg : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
    signal axi_wdata_reg  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal aw_captured    : std_logic := '0';
    signal w_captured     : std_logic := '0';
    signal axi_bvalid_reg : std_logic := '0';

    -- Read channel registers
    signal axi_rdata_reg  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal axi_rvalid_reg : std_logic := '0';

    -- Memory-mapped registers
    signal slv_reg0 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg1 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg2 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal slv_reg3 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

begin

    -- AXI4-Lite READY and response signals
    axi_awready_i <= '1' when (aw_captured = '0' and axi_bvalid_reg = '0') else '0';
    axi_wready_i  <= '1' when (w_captured = '0' and axi_bvalid_reg = '0') else '0';
    axi_arready_i <= not axi_rvalid_reg;

    S_AXI_AWREADY <= axi_awready_i;
    S_AXI_WREADY  <= axi_wready_i;
    S_AXI_ARREADY <= axi_arready_i;

    S_AXI_BVALID <= axi_bvalid_reg;
    S_AXI_BRESP  <= "00"; -- OKAY

    S_AXI_RVALID <= axi_rvalid_reg;
    S_AXI_RDATA  <= axi_rdata_reg;
    S_AXI_RRESP  <= "00"; -- OKAY

    -- Lower 16 bits of reg0 drive the LED/GPIO output.
    gpio_out <= slv_reg0(15 downto 0);

    -- AXI4-Lite register access and switch sampling
    process (S_AXI_ACLK)
        variable read_value : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    begin
        if rising_edge(S_AXI_ACLK) then
            if S_AXI_ARESETN = '0' then
                axi_awaddr_reg <= (others => '0');
                axi_wdata_reg  <= (others => '0');
                aw_captured    <= '0';
                w_captured     <= '0';
                axi_bvalid_reg <= '0';

                axi_rdata_reg  <= (others => '0');
                axi_rvalid_reg <= '0';

                slv_reg0 <= (others => '0');
                slv_reg1 <= (others => '0');
                slv_reg2 <= (others => '0');
                slv_reg3 <= (others => '0');
            else
                -- reg1 samples the 16-bit switch input. Upper 16 bits are zero.
                slv_reg1 <= (others => '0');
                slv_reg1(15 downto 0) <= sw;

                ------------------------------------------------------------
                -- WRITE CHANNEL
                -- Address and data are accepted independently.
                ------------------------------------------------------------
                if axi_bvalid_reg = '1' then
                    if S_AXI_BREADY = '1' then
                        axi_bvalid_reg <= '0';
                    end if;
                else
                    if (S_AXI_AWVALID = '1') and (axi_awready_i = '1') then
                        axi_awaddr_reg <= S_AXI_AWADDR;
                        aw_captured <= '1';
                    end if;

                    if (S_AXI_WVALID = '1') and (axi_wready_i = '1') then
                        axi_wdata_reg <= S_AXI_WDATA;
                        w_captured <= '1';
                    end if;

                    -- Execute the write after address and data have been captured.
                    if (aw_captured = '1') and (w_captured = '1') then
                        case axi_awaddr_reg(C_S_AXI_ADDR_WIDTH-1 downto 2) is
                            when "00" =>
                                slv_reg0 <= axi_wdata_reg;
                            when "01" =>
                                -- reg1 is read-only; writes are ignored.
                                null;
                            when "10" =>
                                slv_reg2 <= axi_wdata_reg;
                            when others =>
                                slv_reg3 <= axi_wdata_reg;
                        end case;

                        aw_captured <= '0';
                        w_captured <= '0';
                        axi_bvalid_reg <= '1';
                    end if;
                end if;

                ------------------------------------------------------------
                -- READ CHANNEL
                ------------------------------------------------------------
                if axi_rvalid_reg = '1' then
                    if S_AXI_RREADY = '1' then
                        axi_rvalid_reg <= '0';
                    end if;
                elsif (S_AXI_ARVALID = '1') and (axi_arready_i = '1') then
                    read_value := (others => '0');
                    case S_AXI_ARADDR(C_S_AXI_ADDR_WIDTH-1 downto 2) is
                        when "00" =>
                            read_value := slv_reg0;
                        when "01" =>
                            read_value := slv_reg1;
                        when "10" =>
                            read_value := slv_reg2;
                        when others =>
                            read_value := slv_reg3;
                    end case;

                    axi_rdata_reg <= read_value;
                    axi_rvalid_reg <= '1';
                end if;
            end if;
        end if;
    end process;

end arch_imp;
