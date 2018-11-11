library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_generator_tb is
end entity;

architecture testbench of address_generator_tb is
    constant ADDR_WIDTH : positive := 32;
    constant WORD_WIDTH : positive := 4;

    constant TEST_RANGE : integer := 65536;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal go : std_logic := '0';
    signal rdy : std_logic := '0';

    signal start_addr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal num_words : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal addr_valid : std_logic;
    signal out_addr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');

    signal sim_done : std_logic := '0';
begin
    UUT : entity work.address_generator
        generic map (
            ADDR_WIDTH => ADDR_WIDTH,
            WORD_WIDTH => WORD_WIDTH
        )
        port map (
            clk => clk,
            rst => rst,
            go => go,
            rdy => rdy,
            start_addr => start_addr,
            num_words => num_words,
            addr_valid => addr_valid,
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
        assert (addr_valid = '0') report "Reset failed, addr_valid non-zero" severity error;
        assert (out_addr = std_logic_vector(to_unsigned(0, ADDR_WIDTH))) report "Reset failed, out_addr non-zero" severity error;

        -- Test reading a stream without pause
        start_addr <= (others => '0');
        num_words <= std_logic_vector(to_unsigned(TEST_RANGE, ADDR_WIDTH));
        rdy <= '1';
        go <= '1';
        for i in 0 to TEST_RANGE-1 loop

            wait until rising_edge(clk);
            wait for 1 ns;
            go <= '0';
            assert (addr_valid = '1') report "Address not valid!" severity error;
            assert (unsigned(out_addr) = unsigned(start_addr) + to_unsigned(i*4, ADDR_WIDTH))
                    report "Address incorrect! Expected " & integer'image(to_integer(unsigned(start_addr) +
                    to_unsigned(i*4, ADDR_WIDTH))) severity error;
        end loop;

        report "All tests passed";
        sim_done <= '1';
    end process;
end architecture;