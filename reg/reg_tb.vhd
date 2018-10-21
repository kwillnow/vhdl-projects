library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_tb is
end entity;

architecture testbench of reg_tb is
    constant TEST_WIDTH : positive := 8;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal input : std_logic_vector(TEST_WIDTH-1 downto 0) := (others => '0');
    signal enable : std_logic := '0';
    signal output : std_logic_vector(TEST_WIDTH-1 downto 0) := (others => '0');

    signal sim_done : std_logic := '0';
begin
    UUT : entity work.reg
        generic map (
            WIDTH => TEST_WIDTH
        )
        port map (
            clk => clk,
            rst => rst,
            input => input,
            enable => enable,
            output => output
        );

    -- Simulation clock generation
    clk <= clk when sim_done = '1' else not clk after 5 ns;

    process
    begin
        -- Test the golden path
        enable <= '1';
        input <= std_logic_vector(to_unsigned(input'high, TEST_WIDTH));
        wait until rising_edge(clk);
        wait for 0 ns;
        assert (output = std_logic_vector(to_unsigned(input'high, TEST_WIDTH))) report "Golden path failed" severity failure;

        -- Make sure that the reg holds its value independent of enable
        enable <= '0';
        wait until rising_edge(clk);
        wait for 0 ns;
        assert (output = std_logic_vector(to_unsigned(input'high, TEST_WIDTH))) report "Golden path failed" severity failure;

        -- Validate that enable has to be set to load the reg
        input <= (others => '0');
        wait until rising_edge(clk);
        wait for 0 ns;
        assert (output = std_logic_vector(to_unsigned(input'high, TEST_WIDTH))) report "Loaded without enable" severity failure;

        -- Test reset
        enable <= '0';
        rst <= '1';
        wait until rising_edge(clk);
        wait for 0 ns;
        assert (output = std_logic_vector(to_unsigned(0, TEST_WIDTH))) report "Reset failed" severity failure;

        report "All tests passed";
        sim_done <= '1';
    end process;
end architecture;