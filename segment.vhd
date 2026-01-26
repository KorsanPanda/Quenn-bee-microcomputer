
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity segment is
port(
        sw     : in  STD_LOGIC;           -- Buton/switch input
        an     : out STD_LOGIC_vector(3 downto 0);
        seg    : out STD_LOGIC_VECTOR(6 downto 0);
        dp : out STD_LOGIC
);
end segment;

architecture Behavioral of segment is
component OUTR is

    Port (
        clk      : in  STD_LOGIC;                      -- Saat sinyali
        LD      : in  STD_LOGIC;                      -- Yükleme kontrol sinyali
        wr_data  : in  STD_LOGIC_VECTOR(7 downto 0);   -- Yazýlacak veri (giriþ)
        rd_data : out STD_LOGIC_VECTOR(7 downto 0)
    );
	 
end component;

--OUTR SÝNYALLERÝ 
signal rd_data_outr : std_logic_vector(7 downto 0);
signal ld_outr      : std_logic := '0';

begin


-- OUTR bileþeni
OUTR_U : OUTR
    port map (
        clk      => clk,
        LD       => ld_outr,
        wr_data  => wr_data_outr,
        rd_data => rd_data_outr
    );
	 
process(sw(0), rd_data_outr )
    begin
        if sw(0) = '1' then
            -- Butona basýldýysa display'i kapat (program "kapatýlmýþ" gibi)
            an(0) <= '0'; 
            an(1) <= '0'; 
            an(2) <= '0'; 
            an(3) <= '0';
       -- tüm anode kapalý
            seg(0) <= '1';
            seg(1) <= '1';
            seg(2) <= '1';
            seg(3) <= '1';
            seg(4) <= '1';
            seg(5) <= '1';
            seg(6) <= '1';    -- tüm segment kapalý
        else
            an(0) <= '1'; 
            an(1) <= '0'; 
            an(2) <= '0'; 
            an(3) <= '0';
				 dp <= rd_data_outr(0);
            seg(0) <= rd_data_outr(1);--a
            seg(1) <= rd_data_outr(2);--b
            seg(2)<= rd_data_outr(3);--c
            seg(3) <= rd_data_outr(4);--d
				seg(4) <= rd_data_outr(5);--e
				seg(5)<= rd_data_outr(6);--f
				seg(6)<= rd_data_outr(7);--g
				


end if;
end process;

end Behavioral;

