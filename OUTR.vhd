library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OUTR is

    Port (
        clk      : in  STD_LOGIC;                      -- Saat sinyali
        LD      : in  STD_LOGIC;                      -- Yükleme kontrol sinyali
        wr_data  : in  STD_LOGIC_VECTOR(7 downto 0);   -- Yazýlacak veri (giriþ)
        rd_data : out STD_LOGIC_VECTOR(7 downto 0)
    );
	 
end OUTR;

architecture Behavioral of OUTR is

    signal reg : STD_LOGIC_VECTOR(7 downto 0);
	 
    begin
    process(clk)
    begin
        if rising_edge(clk) then
            if LD = '1' then
                reg <= wr_data;  -- Sadece ld aktifse veri yazýlýr
            end if;
        end if;
    end process;

    rd_data <= reg;  -- Register içeriði dýþa aktarýlýr
	 
end Behavioral;
