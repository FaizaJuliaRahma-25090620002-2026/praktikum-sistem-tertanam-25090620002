library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_calculator_fsm is
end tb_calculator_fsm;

architecture sim of tb_calculator_fsm is

    signal clk : STD_LOGIC := '0';

    signal rst : STD_LOGIC := '1';

    signal btnU : STD_LOGIC := '0';
    signal btnD : STD_LOGIC := '0';
    signal btnL : STD_LOGIC := '0';
    signal btnR : STD_LOGIC := '0';
    signal btnC : STD_LOGIC := '0';

    signal sw :
        STD_LOGIC_VECTOR(7 downto 0) :=
        (others => '0');

    signal result :
        STD_LOGIC_VECTOR(15 downto 0);

    signal carry :
        STD_LOGIC;

    signal opcode :
        STD_LOGIC_VECTOR(1 downto 0);

    signal state_led :
        STD_LOGIC_VECTOR(3 downto 0);

begin


    ---------------------------------------------------------------
    -- CLOCK 100 MHz
    ---------------------------------------------------------------

    clk <= not clk after 5 ns;


    ---------------------------------------------------------------
    -- DUT
    ---------------------------------------------------------------

    DUT : entity work.calculator_fsm

        port map (

            clk => clk,

            rst => rst,

            btnU => btnU,
            btnD => btnD,
            btnL => btnL,
            btnR => btnR,
            btnC => btnC,

            sw => sw,

            result => result,

            carry => carry,

            opcode => opcode,

            state_led => state_led
        );


    ---------------------------------------------------------------
    -- TEST
    ---------------------------------------------------------------

    STIM : process

        procedure pulse(
            signal p : out STD_LOGIC
        ) is
        begin

            p <= '1';

            wait for 20 ns;

            p <= '0';

            wait for 20 ns;

        end procedure;

    begin


        -----------------------------------------------------------
        -- RESET
        -----------------------------------------------------------

        rst <= '1';

        wait for 30 ns;

        rst <= '0';

        wait for 20 ns;


        -----------------------------------------------------------
        -- TEST 1
        -- 12H + 05H = 17H
        -----------------------------------------------------------

        report "TEST 1: ADD"
            severity note;


        -- A = 12H

        sw <= x"12";

        pulse(btnU);


        -- B = 05H

        sw <= x"05";

        pulse(btnD);


        -- ADD

        pulse(btnL);


        wait for 50 ns;


        assert result = x"0017"

            report "ERROR: 12H + 05H != 0017H"

            severity error;


        -----------------------------------------------------------
        -- KEMBALI KE WAIT_A
        -----------------------------------------------------------

        pulse(btnU);

        wait for 20 ns;


        -----------------------------------------------------------
        -- TEST 2
        -- 12H - 05H = 0DH
        -----------------------------------------------------------

        report "TEST 2: SUBTRACT"
            severity note;


        -- A

        sw <= x"12";

        pulse(btnU);


        -- B

        sw <= x"05";

        pulse(btnD);


        -- SUBTRACT

        pulse(btnR);


        wait for 50 ns;


        assert result = x"000D"

            report "ERROR: 12H - 05H != 000DH"

            severity error;


        -----------------------------------------------------------
        -- KEMBALI KE WAIT_A
        -----------------------------------------------------------

        pulse(btnU);

        wait for 20 ns;


        -----------------------------------------------------------
        -- TEST 3
        -- 0AH * 05H = 0032H
        -----------------------------------------------------------

        report "TEST 3: MULTIPLY"
            severity note;


        -- A = 0AH

        sw <= x"0A";

        pulse(btnU);


        -- B = 05H

        sw <= x"05";

        pulse(btnD);


        -- MULTIPLY

        pulse(btnC);


        wait for 50 ns;


        assert result = x"0032"

            report "ERROR: 0AH * 05H != 0032H"

            severity error;


        -----------------------------------------------------------
        -- SELESAI
        -----------------------------------------------------------

        report
            "SEMUA TEST BERHASIL"
            severity note;


        wait;

    end process;

end sim;