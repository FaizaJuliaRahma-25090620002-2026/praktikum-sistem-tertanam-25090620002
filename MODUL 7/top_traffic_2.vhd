library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_traffic_2 is
    Generic ( CLK_FREQ_HZ : integer := 100_000_000 );
    Port ( clk  : in  STD_LOGIC;
           btnC : in  STD_LOGIC;                      -- reset
           sw   : in  STD_LOGIC_VECTOR(3 downto 0);   -- pengatur durasi hijau
           led  : out STD_LOGIC_VECTOR(5 downto 0) );
end top_traffic_2;

architecture Structural of top_traffic_2 is
    signal tick : std_logic;
begin
    u_tick: entity work.tick_1hz
        generic map ( CLK_FREQ_HZ => CLK_FREQ_HZ )
        port map ( clk => clk, rst => btnC, tick => tick );

    u_fsm: entity work.traffic_light_fsm_2
        port map ( clk  => clk,
                   rst  => btnC,
                   tick => tick,
                   sw   => sw,
                   led  => led );
end Structural;