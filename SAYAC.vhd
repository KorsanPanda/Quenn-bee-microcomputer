library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SAYAC is
    Port (
        clk : in  STD_LOGIC;
        clr : in  STD_LOGIC;
        t0  : out STD_LOGIC;
        t1  : out STD_LOGIC;
        t2  : out STD_LOGIC;
        t3  : out STD_LOGIC;
        t4  : out STD_LOGIC;
        t5  : out STD_LOGIC
    );
end SAYAC;

architecture Behavioral of SAYAC is
    type state_type is (s0, s1, s2, s3, s4, s5);
    signal state : state_type := s0;
begin

    process(clk, clr)
    begin
        if clr = '1' then
            state <= s0;
        elsif rising_edge(clk) then
            case state is
                when s0 => state <= s1;
                when s1 => state <= s2;
                when s2 => state <= s3;
                when s3 => state <= s4;
                when s4 => state <= s5;
                when s5 => state <= s0;
            end case;
        end if;
    end process;

    -- zamanlar
    t0 <= '1' when state = s0 else '0';
    t1 <= '1' when state = s1 else '0';
    t2 <= '1' when state = s2 else '0';
    t3 <= '1' when state = s3 else '0';
    t4 <= '1' when state = s4 else '0';
    t5 <= '1' when state = s5 else '0';

end Behavioral;