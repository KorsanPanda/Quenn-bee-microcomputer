library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AC is
    port(
        clk      : in std_logic;
        CLR      : in std_logic;
        LD       : in std_logic;
        INR      : in std_logic;
        wr_data  : in std_logic_vector(3 downto 0);
        rd_data  : out std_logic_vector(3 downto 0)
    );
end AC;

architecture Behavioral of AC is
    signal reg : std_logic_vector(3 downto 0) := (others => '0');
begin
    process(clk, CLR)
    begin
        if CLR = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if LD = '1' then
                reg <= wr_data;
            elsif INR = '1' then
                reg <= std_logic_vector(signed(reg) + 1);
					 reg(3) <= '0';
            end if;
        end if;
    end process;

    rd_data <= reg;
end Behavioral;
