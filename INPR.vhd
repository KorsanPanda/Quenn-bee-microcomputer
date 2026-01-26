library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity INPR is

    Port (
        clk      : in  STD_LOGIC;                      -- Saat sinyali
        wr_data  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Yazýlacak veri (giriþ)
        rd_data  : out STD_LOGIC_VECTOR(3 downto 0)    -- Okunacak veri (çýkýþ)
    );
	 
end INPR;

architecture Behavioral of INPR is

    signal reg : STD_LOGIC_VECTOR(3 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            reg <= wr_data;  -- Saat geldiðinde wr_data içeri yazýlýr
        end if;
    end process;
    
    rd_data <= reg;  -- Register içeriði çýkýþa baðlanýr
end Behavioral;
