library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2_1_tb is
end entity;

architecture tb of mux_2_1_tb is
    constant TEST_WIDTH : positive := 8;

    signal input1 : std_logic_vector(TEST_WIDTH-1 downto 0);
    signal input2 : std_logic_vector(TEST_WIDTH-1 downto 0);
    signal sel : std_logic;

    signal output : std_logic_vector(TEST_WIDTH-1 downto 0);

begin
    UUT : entity work.mux_2_1
        generic map (
            WIDTH => TEST_WIDTH
        )
        port map (
            input1 => input1,
            input2 => input2,
            sel => sel,
            output => output
        );

        process
        begin
            sel <= '0';
            input1 <= std_logic_vector(to_unsigned(1, TEST_WIDTH));
            input2 <= std_logic_vector(to_unsigned(2, TEST_WIDTH));
            wait for 1 ns;
            assert (output = input1) report "Failed to select 1" severity FAILURE;

            sel <= '1';
            wait for 1 ns;
            assert (output = input2) report "Failed to select 2" severity FAILURE;

            input1 <= std_logic_vector(to_unsigned(3, TEST_WIDTH));
            wait for 1 ns;
            assert (output = input2) report "Out changed with other in" severity FAILURE;

            input1 <= std_logic_vector(to_unsigned(4, TEST_WIDTH));
            wait for 1 ns;
            assert (output = input2) report "Out didn't change with in" severity FAILURE;

            report "All tests passed!";
            wait;
        end process;
end architecture;