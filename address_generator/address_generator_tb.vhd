library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_generator_tb is
end entity;

architecture testbench of address_generator_tb is
    constant ADDR_WIDTH : positive := 32;
    constant WORD_WIDTH : positive := 4;
    constant CYCLES_PER_ADDR : positive := 1;

    constant TEST_RANGE : integer := 65536;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal enable : std_logic := '0';

    signal start_addr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal num_words : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal out_addr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');

    signal sim_done : std_logic := '0';
begin
    UUT : entity work.address_generator
        generic map (
            ADDR_WIDTH => ADDR_WIDTH,
            WORD_WIDTH => WORD_WIDTH,
            CYCLES_PER_ADDR => CYCLES_PER_ADDR
        )
        port map (
            clk => clk,
            rst => rst,
            enable => enable,
            start_addr => start_addr,
            num_words => num_words,
            out_addr => out_addr
        );

    -- Simulation clock generation
    clk <= clk when sim_done = '1' else not clk after 5 ns;

    process
    begin
        -- Reset to default values
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);
        wait for 0 ns;
        assert (out_addr = std_logic_vector(to_unsigned(0, ADDR_WIDTH))) report "Reset failed" severity error;

        -- Test various values
        for test_start_addr in 0 to TEST_RANGE loop
            for test_num_words in 1 to TEST_RANGE loop
                start_addr <= std_logic_vector(to_unsigned(test_start_addr, ADDR_WIDTH));
                num_words <= std_logic_vector(to_unsigned(test_num_words, ADDR_WIDTH));
                enable <= '1';
                wait until rising_edge(clk);
                wait for 0 ns;
                enable <= '0';
                for expected_words in 0 to test_num_words loop
                    -- Wait for generator to output data
                    for i in 0 to CYCLES_PER_ADDR loop
                        wait until rising_edge(clk);
                        wait for 0 ns;
                    end loop;
                    assert (out_addr = std_logic_vector(to_unsigned(test_start_addr + expected_words*4, ADDR_WIDTH)))
                            report "Bad address" severity error;
                end loop;
            end loop;
        end loop;

        report "All tests passed";
        sim_done <= '1';
    end process;
end architecture;