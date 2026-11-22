library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ps2_keydec is
    Generic ( TARGET : STD_LOGIC_VECTOR (7 downto 0) := x"1C" );  -- default: tombol 'A'
    Port ( clk         : in  STD_LOGIC;
           scan_code   : in  STD_LOGIC_VECTOR (7 downto 0);
           data_ready  : in  STD_LOGIC;
           target_down : out STD_LOGIC );
end ps2_keydec;

architecture Behavioral of ps2_keydec is
    signal brk  : STD_LOGIC := '0';   -- '1' = byte berikutnya adalah kode tombol yang DILEPAS
    signal down : STD_LOGIC := '0';
begin
    target_down <= down;

    process(clk)
    begin
        if rising_edge(clk) then
            if data_ready = '1' then
                if scan_code = x"F0" then
                    brk <= '1';                         -- awalan break code
                elsif scan_code = x"E0" then
                    null;                               -- awalan extended key: abaikan
                else
                    if scan_code = TARGET then
                        down <= not brk;                -- brk=0: ditekan, brk=1: dilepas
                    end if;
                    brk <= '0';                         -- kode tombol sudah diproses
                end if;
            end if;
        end if;
    end process;
end Behavioral;