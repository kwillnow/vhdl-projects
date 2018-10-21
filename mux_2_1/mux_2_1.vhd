library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2_1 is
    generic (
        WIDTH : positive := 8
    );
    port (
        input1 : in std_logic_vector(WIDTH-1 downto 0);
        input2 : in std_logic_vector(WIDTH-1 downto 0);
        sel : in std_logic;

        output : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of mux_2_1 is
begin
    process (input1, input2, sel)
    begin
        case sel is
            when '0' =>
                output <= input1;
            when '1' =>
                output <= input2;
            when others => null;
        end case;
    end process;
end architecture;