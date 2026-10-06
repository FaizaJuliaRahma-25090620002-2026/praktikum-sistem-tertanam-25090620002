library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calculator_fsm is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;

        btnU      : in  STD_LOGIC;
        btnD      : in  STD_LOGIC;
        btnL      : in  STD_LOGIC;
        btnR      : in  STD_LOGIC;
        btnC      : in  STD_LOGIC;

        sw        : in  STD_LOGIC_VECTOR(7 downto 0);

        result    : out STD_LOGIC_VECTOR(15 downto 0);
        carry     : out STD_LOGIC;
        opcode    : out STD_LOGIC_VECTOR(1 downto 0);

        state_led : out STD_LOGIC_VECTOR(3 downto 0)
    );
end calculator_fsm;

architecture Behavioral of calculator_fsm is

    ---------------------------------------------------------------
    -- STATE
    ---------------------------------------------------------------

    type state_type is (
        WAIT_A,
        WAIT_B,
        CALCULATING,
        SHOW_RESULT
    );

    signal state, next_state : state_type;


    ---------------------------------------------------------------
    -- REGISTER OPERAND
    ---------------------------------------------------------------

    signal a_reg :
        STD_LOGIC_VECTOR(7 downto 0) :=
        (others => '0');

    signal b_reg :
        STD_LOGIC_VECTOR(7 downto 0) :=
        (others => '0');


    ---------------------------------------------------------------
    -- REGISTER OPERATION
    ---------------------------------------------------------------

    signal op_reg :
        STD_LOGIC_VECTOR(1 downto 0) :=
        "00";


    ---------------------------------------------------------------
    -- REGISTER RESULT
    ---------------------------------------------------------------

    signal result_reg :
        STD_LOGIC_VECTOR(15 downto 0) :=
        (others => '0');

    signal carry_reg :
        STD_LOGIC := '0';


    ---------------------------------------------------------------
    -- ALU SIGNAL
    ---------------------------------------------------------------

    signal alu_result :
        STD_LOGIC_VECTOR(15 downto 0);

    signal alu_carry :
        STD_LOGIC;

begin

    ---------------------------------------------------------------
    -- ALU
    ---------------------------------------------------------------

    ALU_INST : entity work.alu8

        port map (
            a      => a_reg,
            b      => b_reg,
            opcode => op_reg,

            result => alu_result,
            carry  => alu_carry
        );


    ---------------------------------------------------------------
    -- PROCESS 1
    -- STATE REGISTER
    ---------------------------------------------------------------

    process(clk)
    begin

        if rising_edge(clk) then

            if rst = '1' then

                state <= WAIT_A;

            else

                state <= next_state;

            end if;

        end if;

    end process;


    ---------------------------------------------------------------
    -- PROCESS 2
    -- NEXT STATE LOGIC
    ---------------------------------------------------------------

    process(
        state,
        btnU,
        btnD,
        btnL,
        btnR,
        btnC
    )
    begin

        next_state <= state;

        case state is


            --------------------------------------------------------
            -- WAIT A
            --------------------------------------------------------

            when WAIT_A =>

                if btnU = '1' then

                    next_state <= WAIT_B;

                end if;


            --------------------------------------------------------
            -- WAIT B
            --------------------------------------------------------

            when WAIT_B =>

                -- ADD
                if btnL = '1' then

                    next_state <= CALCULATING;

                -- SUBTRACT
                elsif btnR = '1' then

                    next_state <= CALCULATING;

                -- MULTIPLY
                elsif btnC = '1' then

                    next_state <= CALCULATING;

                else

                    next_state <= WAIT_B;

                end if;


            --------------------------------------------------------
            -- CALCULATING
            --------------------------------------------------------

            when CALCULATING =>

                next_state <= SHOW_RESULT;


            --------------------------------------------------------
            -- SHOW RESULT
            --------------------------------------------------------

            when SHOW_RESULT =>

                -- Tekan btnU untuk mulai perhitungan baru
                if btnU = '1' then

                    next_state <= WAIT_A;

                end if;


        end case;

    end process;


    ---------------------------------------------------------------
    -- REGISTER OPERAND, OPERATION, RESULT
    ---------------------------------------------------------------

    process(clk)
    begin

        if rising_edge(clk) then

            if rst = '1' then

                a_reg      <= (others => '0');
                b_reg      <= (others => '0');
                op_reg     <= "00";

                result_reg <= (others => '0');
                carry_reg  <= '0';


            else

                case state is


                    ------------------------------------------------
                    -- WAIT A
                    ------------------------------------------------

                    when WAIT_A =>

                        if btnU = '1' then

                            a_reg <= sw;

                        end if;


                    ------------------------------------------------
                    -- WAIT B
                    ------------------------------------------------

                    when WAIT_B =>

                        -- Simpan B
                        if btnD = '1' then

                            b_reg <= sw;

                        end if;


                        -- ADD
                        if btnL = '1' then

                            op_reg <= "00";

                        end if;


                        -- SUBTRACT
                        if btnR = '1' then

                            op_reg <= "01";

                        end if;


                        -- MULTIPLY
                        if btnC = '1' then

                            op_reg <= "10";

                        end if;


                    ------------------------------------------------
                    -- CALCULATING
                    ------------------------------------------------

                    when CALCULATING =>

                        result_reg <= alu_result;

                        carry_reg <= alu_carry;


                    ------------------------------------------------
                    -- SHOW RESULT
                    ------------------------------------------------

                    when SHOW_RESULT =>

                        null;

                end case;

            end if;

        end if;

    end process;


    ---------------------------------------------------------------
    -- OUTPUT
    ---------------------------------------------------------------

    result <= result_reg;

    carry <= carry_reg;

    opcode <= op_reg;


    ---------------------------------------------------------------
    -- STATE LED
    ---------------------------------------------------------------

    with state select state_led <=

        "0001" when WAIT_A,

        "0010" when WAIT_B,

        "0100" when CALCULATING,

        "1000" when SHOW_RESULT,

        "0000" when others;

end Behavioral;