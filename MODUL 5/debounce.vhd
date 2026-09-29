library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    generic (
        CLK_FREQ_HZ : integer := 100_000_000;
        STABLE_MS   : integer := 10
    );

    port (
        clk     : in  STD_LOGIC;
        btn_in  : in  STD_LOGIC;   -- Sinyal mentah dari tombol
        btn_out : out STD_LOGIC    -- Sinyal yang sudah debounced
    );
end debounce;


architecture Behavioral of debounce is

    -- Jumlah clock yang diperlukan agar tombol dianggap stabil
    constant LIMIT : integer :=
        (CLK_FREQ_HZ / 1000) * STABLE_MS;

    -- Synchronizer 2 tingkat
    signal ff1 : STD_LOGIC := '0';
    signal ff2 : STD_LOGIC := '0';

    -- Counter debounce
    signal cnt : integer range 0 to LIMIT := 0;

    -- Kondisi tombol yang sudah stabil
    signal stable : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            --------------------------------------------------------
            -- Synchronizer 2 tingkat
            --------------------------------------------------------
            ff1 <= btn_in;
            ff2 <= ff1;


            --------------------------------------------------------
            -- Debounce
            --------------------------------------------------------
            if ff2 /= stable then

                -- Input berubah dari kondisi stabil.
                -- Mulai menghitung waktu kestabilan.
                if cnt < LIMIT then
                    cnt <= cnt + 1;
                else
                    -- Sudah stabil selama LIMIT clock
                    stable <= ff2;
                    cnt <= 0;
                end if;

            else

                -- Input kembali sama dengan kondisi stabil.
                -- Tidak ada perubahan, counter direset.
                cnt <= 0;

            end if;

        end if;
    end process;


    ------------------------------------------------------------
    -- Output debounce
    ------------------------------------------------------------
    btn_out <= stable;

end Behavioral;
