library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AR is
    port(
        clk      : in std_logic;
        CLR      : in std_logic;
        LD       : in std_logic;
        INR      : in std_logic;
		  t0       : in std_logic;
        wr_data  : in std_logic_vector(10 downto 0);
        rd_data  : out std_logic_vector(10 downto 0)
    );
end AR;

architecture Behavioral of AR is
    signal reg : std_logic_vector(10 downto 0) := (others => '0');
	 signal LD_s : std_logic;
	 signal INR_s : std_logic;
    signal t0_s : std_logic;

begin
    t0_s <= t0;
	 process(clk, CLR)
    begin
        if CLR = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
		  	   LD_s <= t0_s;
            if LD_s = '1' then
                reg <= wr_data;
            elsif INR_s = '1' then
                reg <= std_logic_vector(unsigned(reg) + 1);
            end if;
        end if;
    end process;

    rd_data <= reg;

end Behavioral;
