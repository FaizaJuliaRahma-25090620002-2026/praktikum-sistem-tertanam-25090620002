library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculator_fsm_3 is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;

        btnU      : in  STD_LOGIC;
        btnD      : in  STD_LOGIC;
        btnL      : in  STD_LOGIC;
        btnR      : in  STD_LOGIC;
        btnC      : in  STD_LOGIC;

        sw        : in  STD_LOGIC_VECTOR(9 downto 0);

        result    : out STD_LOGIC_VECTOR(15 downto 0);
        carry     : out STD_LOGIC;
        opcode    : out STD_LOGIC_VECTOR(1 downto 0);
        state_led : out STD_LOGIC_VECTOR(3 downto 0)
    );
end calculator_fsm_3;

architecture Behavioral of calculator_fsm_3 is

    type state_type is (
        WAIT_A,
        WAIT_B,
        CALCULATING,
        SHOW_RESULT
    );

    signal current_state : state_type := WAIT_A;
    signal next_state    : state_type := WAIT_A;

    signal a_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal b_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    signal op_reg : STD_LOGIC_VECTOR(1 downto 0) := "00";

    signal alu_result : STD_LOGIC_VECTOR(15 downto 0);
    signal alu_carry  : STD_LOGIC;

    signal result_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal carry_reg  : STD_LOGIC := '0';

begin

    ----------------------------------------------------------------
    -- ALU
    ----------------------------------------------------------------
    alu_inst : entity work.alu8_2
        port map (
            a      => a_reg,
            b      => b_reg,
            opcode => op_reg,
            result => alu_result,
            carry  => alu_carry
        );

    ----------------------------------------------------------------
    -- STATE REGISTER AND DATA REGISTER
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then

                current_state <= WAIT_A;

                a_reg <= (others => '0');
                b_reg <= (others => '0');
                op_reg <= "00";

                result_reg <= (others => '0');
                carry_reg <= '0';

            else

                current_state <= next_state;

                ----------------------------------------------------
                -- Simpan operand A
                ----------------------------------------------------
                if current_state = WAIT_A then
                    if btnU = '1' then
                        a_reg <= sw(7 downto 0);
                    end if;
                end if;

                ----------------------------------------------------
                -- Simpan operand B
                ----------------------------------------------------
                if current_state = WAIT_B then
                    if btnD = '1' then
                        b_reg <= sw(7 downto 0);
                    end if;
                end if;

                ----------------------------------------------------
                -- Mealy:
                -- Operasi dipilih ketika BTN_L ditekan.
                ----------------------------------------------------
                if current_state = WAIT_B then
                    if btnL = '1' then
                        op_reg <= sw(9 downto 8);
                    end if;
                end if;

                ----------------------------------------------------
                -- Simpan hasil
                ----------------------------------------------------
                if current_state = CALCULATING then
                    result_reg <= alu_result;
                    carry_reg <= alu_carry;
                end if;

            end if;

        end if;
    end process;


    ----------------------------------------------------------------
    -- NEXT STATE LOGIC
    ----------------------------------------------------------------
    process(current_state, btnU, btnL)
    begin

        next_state <= current_state;

        case current_state is

            --------------------------------------------------------
            -- WAIT A
            --------------------------------------------------------
            when WAIT_A =>

                if btnU = '1' then
                    next_state <= WAIT_B;
                else
                    next_state <= WAIT_A;
                end if;


            --------------------------------------------------------
            -- WAIT B
            --------------------------------------------------------
            when WAIT_B =>

                if btnL = '1' then
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

                if btnU = '1' then
                    next_state <= WAIT_A;
                else
                    next_state <= SHOW_RESULT;
                end if;


            when others =>

                next_state <= WAIT_A;

        end case;

    end process;


    ----------------------------------------------------------------
    -- MEALY OUTPUT LOGIC
    ----------------------------------------------------------------
    process(current_state, btnL)
    begin

        -- Default
        state_led <= "0000";

        case current_state is

            when WAIT_A =>
                state_led <= "0001";

            when WAIT_B =>
                state_led <= "0010";

            when CALCULATING =>
                state_led <= "0100";

            when SHOW_RESULT =>
                state_led <= "1000";

            when others =>
                state_led <= "0000";

        end case;

        ------------------------------------------------------------
        -- Mealy output condition
        -- Output tambahan aktif berdasarkan state + input.
        ------------------------------------------------------------
        if current_state = WAIT_B and btnL = '1' then
            state_led <= "0110";
        end if;

    end process;


    ----------------------------------------------------------------
    -- OUTPUT
    ----------------------------------------------------------------
    result <= result_reg;
    carry  <= carry_reg;
    opcode <= op_reg;

end Behavioral;