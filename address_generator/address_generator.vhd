library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_generator is
    generic (
        ADDR_WIDTH : positive := 32;
        WORD_WIDTH : positive := 4;
        CYCLES_PER_ADDR : positive := 1
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        enable : in std_logic;

        start_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        num_words : in std_logic_vector(ADDR_WIDTH-1 downto 0);

        out_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of address_generator is
    -- type state is (STATE_IDLE, STATE_HOLD_ADDR, STATE_INC_ADDR);
    type state is (STATE_IDLE, STATE_HOLD_ADDR);
    signal int_state : state;

    signal hold_cnt : unsigned(2 downto 0);
    signal word_cnt : unsigned(ADDR_WIDTH-1 downto 0);
    signal num_words_reg : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal int_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            int_state <= STATE_IDLE;
            hold_cnt <= (others => '0');
            word_cnt <= (others => '0');
            int_addr <= (others => '0');
        else
            if (rising_edge(clk)) then
                case int_state is
                    when STATE_IDLE =>
                        hold_cnt <= (others => '0');
                        word_cnt <= (others => '0');
                        int_addr <= (others => '0');
                        if (enable = '1') then
                            int_state <= STATE_HOLD_ADDR;
                            int_addr <= start_addr;
                            num_words_reg <= num_words;
                        end if;

                    when STATE_HOLD_ADDR =>
                        if (hold_cnt < CYCLES_PER_ADDR-1) then
                            hold_cnt <= hold_cnt + 1;
                        else
                            hold_cnt <= (others => '0');
                            -- int_state <= STATE_INC_ADDR;
                            if (word_cnt < unsigned(num_words_reg)-1) then
                                int_addr <= std_logic_vector(unsigned(int_addr) + to_unsigned(WORD_WIDTH, int_addr'length));
                                word_cnt <= word_cnt + 1;
                                int_state <= STATE_HOLD_ADDR;
                            else
                                word_cnt <= (others => '0');
                                int_state <= STATE_IDLE;
                            end if;
                        end if;

                    -- when STATE_INC_ADDR =>
                    --     if (word_cnt < unsigned(num_words_reg)) then
                    --         int_addr <= std_logic_vector(unsigned(int_addr) + to_unsigned(WORD_WIDTH, int_addr'length));
                    --         word_cnt <= word_cnt + 1;
                    --         int_state <= STATE_HOLD_ADDR;
                    --     else
                    --         word_cnt <= (others => '0');
                    --         int_state <= STATE_IDLE;
                    --     end if;

                end case;
            end if;
        end if;
    end process;

    -- Assignments
    out_addr <= int_addr;
end architecture;