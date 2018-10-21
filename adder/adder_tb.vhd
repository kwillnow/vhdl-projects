library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_tb is
end entity;

architecture testbench of adder_tb is
    constant TEST_WIDTH : positive := 8;

    signal input1 : std_logic_vector(TEST_WIDTH-1 downto 0);
    signal input2 : std_logic_vector(TEST_WIDTH-1 downto 0);

    signal output : std_logic_vector(TEST_WIDTH-1 downto 0);

begin
    UUT : entity work.adder
        generic map (
            WIDTH => TEST_WIDTH
        )
        port map (
            input1 => input1,
            input2 => input2,
            output => output
        );

        process
        begin
            for i in 0 to 10 loop
                for j in 0 to 10 loop
                    input1 <= std_logic_vector(to_unsigned(i, TEST_WIDTH));
                    input2 <= std_logic_vector(to_unsigned(j, TEST_WIDTH));
                    wait for 1 ns;
                    assert (output = std_logic_vector(to_unsigned(i + j, TEST_WIDTH))) report integer'image(i) &
                            " + " & integer'image(j) severity FAILURE;
                end loop;
            end loop;
            
            report "All tests passed!";
            wait;
        end process;
end architecture;