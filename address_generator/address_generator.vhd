library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_generator is
    generic (
        ADDR_WIDTH : positive := 32;
        WORD_WIDTH : positive := 4
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        go : in std_logic;
        rdy : in std_logic;

        start_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        num_words : in std_logic_vector(ADDR_WIDTH-1 downto 0);

        addr_valid : out std_logic;
        out_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of address_generator is
    signal running : std_logic;

    signal word_cnt : unsigned(ADDR_WIDTH-1 downto 0);
    signal num_words_reg : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal int_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            running <= '0';
            word_cnt <= (others => '0');
            num_words_reg <= (others => '0');
            int_addr <= (others => '0');
        else
            if (rising_edge(clk)) then
                if (go = '1' and running = '0') then
                    -- Starting a new run
                    int_addr <= start_addr;
                    num_words_reg <= num_words;
                    running <= '1';
                elsif (running = '1' and rdy = '1')then
                    if (word_cnt = unsigned(num_words_reg)) then
                        -- Finished address generation
                        running <= '0';
                    else
                        -- Continuing a run
                        int_addr <= std_logic_vector(unsigned(int_addr) + to_unsigned(WORD_WIDTH, int_addr'length));
                        word_cnt <= word_cnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Assignments
    addr_valid <= running;
    out_addr <= int_addr;
end architecture;