library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    generic (
        WIDTH : positive := 8
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        input : in std_logic_vector(WIDTH-1 downto 0);
        enable : in std_logic;

        output : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture behavioral of reg is
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            output <= (others => '0');
        else
            if (rising_edge(clk)) then
                if (enable = '1') then
                    output <= input;
                end if;
            end if;
        end if;
    end process;
end architecture;