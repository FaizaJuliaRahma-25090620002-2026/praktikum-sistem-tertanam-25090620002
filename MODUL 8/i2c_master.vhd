library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_master is
    generic (
        CLK_FREQ_HZ : positive := 100_000_000;
        I2C_FREQ_HZ : positive := 100_000
    );
    port (
        clk        : in    std_logic;
        rst        : in    std_logic;
        start      : in    std_logic;
        slave_addr : in    std_logic_vector(6 downto 0);
        data_in    : in    std_logic_vector(7 downto 0);
        scl        : out   std_logic;
        sda        : inout std_logic;
        busy       : out   std_logic;
        done       : out   std_logic;
        ack_error  : out   std_logic
    );
end entity i2c_master;

architecture rtl of i2c_master is

    type i2c_state is (
        S_IDLE,
        S_START,
        S_ADDR,
        S_ADDR_ACK,
        S_DATA,
        S_DATA_ACK,
        S_STOP
    );

    signal state : i2c_state := S_IDLE;

    constant C_HALF_PERIOD : positive :=
        CLK_FREQ_HZ / (2 * I2C_FREQ_HZ);

    signal clk_div_count :
        natural range 0 to C_HALF_PERIOD - 1 := 0;

    signal scl_reg       : std_logic := '1';
    signal sda_drive_low : std_logic := '0';

    signal shift_reg : std_logic_vector(7 downto 0)
        := (others => '0');

    signal bit_index : integer range 0 to 7 := 7;

    signal busy_reg      : std_logic := '0';
    signal done_reg      : std_logic := '0';
    signal ack_error_reg : std_logic := '0';

begin

    scl       <= scl_reg;
    busy      <= busy_reg;
    done      <= done_reg;
    ack_error <= ack_error_reg;

    -- Open-drain: master hanya menarik SDA LOW
    -- atau melepas jalur dengan nilai Z.
    sda <= '0' when sda_drive_low = '1' else 'Z';

    process (clk)
    begin
        if rising_edge(clk) then

            done_reg <= '0';

            if rst = '1' then

                state          <= S_IDLE;
                clk_div_count  <= 0;
                scl_reg        <= '1';
                sda_drive_low  <= '0';
                shift_reg      <= (others => '0');
                bit_index      <= 7;
                busy_reg       <= '0';
                done_reg       <= '0';
                ack_error_reg  <= '0';

            elsif clk_div_count = C_HALF_PERIOD - 1 then

                clk_div_count <= 0;

                case state is

                    when S_IDLE =>
                        scl_reg       <= '1';
                        sda_drive_low <= '0';
                        busy_reg      <= '0';

                        if start = '1' then
                            -- Alamat 7-bit + bit WRITE = 0
                            shift_reg <= slave_addr & '0';
                            bit_index <= 7;

                            -- START condition
                            sda_drive_low <= '1';
                            busy_reg      <= '1';
                            ack_error_reg <= '0';

                            state <= S_START;
                        end if;

                    when S_START =>
                        -- Mulai pengiriman alamat
                        scl_reg       <= '0';
                        sda_drive_low <= not shift_reg(7);

                        state <= S_ADDR;

                    when S_ADDR =>
                        if scl_reg = '0' then

                            scl_reg <= '1';

                        else

                            scl_reg <= '0';

                            if bit_index = 0 then

                                -- Lepas SDA untuk ACK slave
                                sda_drive_low <= '0';
                                state <= S_ADDR_ACK;

                            else

                                bit_index <= bit_index - 1;
                                sda_drive_low <=
                                    not shift_reg(bit_index - 1);

                            end if;
                        end if;

                    when S_ADDR_ACK =>
                        if scl_reg = '0' then

                            scl_reg <= '1';

                        else

                            -- Periksa ACK dari slave
                            if sda /= '0' then
                                ack_error_reg <= '1';
                            end if;

                            scl_reg   <= '0';
                            shift_reg <= data_in;
                            bit_index <= 7;

                            sda_drive_low <= not data_in(7);
                            state <= S_DATA;

                        end if;

                    when S_DATA =>
                        if scl_reg = '0' then

                            scl_reg <= '1';

                        else

                            scl_reg <= '0';

                            if bit_index = 0 then

                                -- Lepas SDA untuk ACK slave
                                sda_drive_low <= '0';
                                state <= S_DATA_ACK;

                            else

                                bit_index <= bit_index - 1;
                                sda_drive_low <=
                                    not shift_reg(bit_index - 1);

                            end if;
                        end if;

                    when S_DATA_ACK =>
                        if scl_reg = '0' then

                            scl_reg <= '1';

                        else

                            -- Periksa ACK setelah data
                            if sda /= '0' then
                                ack_error_reg <= '1';
                            end if;

                            scl_reg       <= '0';
                            sda_drive_low <= '1';

                            state <= S_STOP;

                        end if;

                    when S_STOP =>
                        if scl_reg = '0' then

                            scl_reg       <= '1';
                            sda_drive_low <= '1';

                        else

                            -- STOP condition
                            scl_reg       <= '1';
                            sda_drive_low <= '0';

                            busy_reg <= '0';
                            done_reg <= '1';

                            state <= S_IDLE;

                        end if;

                end case;

            else

                clk_div_count <= clk_div_count + 1;

            end if;
        end if;
    end process;

end architecture rtl;