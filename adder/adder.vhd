library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    generic (
        WIDTH : positive := 8
    );
    port (
        input1 : in std_logic_vector(WIDTH-1 downto 0);
        input2 : in std_logic_vector(WIDTH-1 downto 0);

        output : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of adder is
begin
    process (input1, input2)
        variable tmp : unsigned(WIDTH-1 downto 0);
    begin
        tmp := unsigned(input1) + unsigned(input2);
        output <= std_logic_vector(tmp);
    end process;
end architecture;