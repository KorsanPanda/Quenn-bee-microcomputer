library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
		wr_data_ALU_TR: in std_logic_vector(3 downto 0);
		wr_data_ALU_INPR: in std_logic_vector(3 downto 0);
		wr_data_ALU_AC: in std_logic_vector(3 downto 0);
		rd_data_ALU:out std_logic_vector(3 downto 0);
		secim: in std_logic_vector(1 downto 0)
		 );
end ALU;

architecture Behavioral of ALU is

signal clk : std_logic;
signal wr_data_ALU_TR_signal   : std_logic_vector(3 downto 0);
signal wr_data_ALU_INPR_signal : std_logic_vector(3 downto 0);
signal wr_data_ALU_AC_signal   : std_logic_vector(3 downto 0);
signal rd_data_ALU_signal : std_logic_vector(3 downto 0);

-- INPR SNYALLER 
signal rd_data_inpr : std_logic_vector(3 downto 0);
signal wr_data_inpr : std_logic_vector(3 downto 0);

--TR SNYALLER
signal ld_TR     : std_logic := '0';
signal clr_TR : std_logic := '0';
signal wr_data_TR : std_logic_vector(3 downto 0) := (others => '0');
signal rd_data_TR: std_logic_vector(3 downto 0);

--AC SNYALLER
signal ld_AC     : std_logic := '0'; 
signal inr_AC    : std_logic := '0';
signal clr_AC : std_logic := '0';
signal rd_data_ac  : std_logic_vector(3 downto 0);
signal wr_data_ac  : std_logic_vector(3 downto 0);



component TR is
port(clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     wr_data  : in std_logic_vector(3 downto 0);
     rd_data  : out std_logic_vector(3 downto 0)
);
end  component;

component INPR is
Port (
        clk      : in  STD_LOGIC;                      -- Saat sinyali
        wr_data  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Yazlacak veri (giri)
        rd_data  : out STD_LOGIC_VECTOR(3 downto 0)    -- Okunacak veri (k)
    );
	 
end component;
  
component AC is
    port(
        clk      : in std_logic;
        CLR      : in std_logic;
        LD       : in std_logic;
        INR      : in std_logic;
        wr_data  : in std_logic_vector(3 downto 0);
        rd_data  : out std_logic_vector(3 downto 0)
    );
end component;
begin
-- INPR bileeni
INPR_U : INPR
    port map (
        clk      => clk,
        wr_data  => wr_data_inpr,
        rd_data  => rd_data_inpr
    );
	 
-- AC bileeni
AC_U : AC
    port map (
        clk      => clk,
        CLR      => clr_AC,
        LD       => ld_AC,
        INR      => inr_AC,
        wr_data  => wr_data_ac,
        rd_data  => rd_data_ac
    );
	 
-- TR bileeni
TR_U : TR
    port map (
        clk     => clk,
        CLR     => clr_TR,
        LD      => ld_TR,
        wr_data => wr_data_TR,
        rd_data => rd_data_TR
    );
	 
		wr_data_ALU_INPR_signal <= rd_data_inpr;
	   wr_data_ALU_AC_signal <= rd_data_ac;
		wr_data_ALU_TR_signal <= rd_data_TR;
process(wr_data_ALU_INPR_signal , wr_data_ALU_AC_signal , wr_data_ALU_TR_signal , secim)
    begin
		if secim= "00" then
			rd_data_ALU_signal <= std_logic_vector(signed(wr_data_ALU_TR) + signed(wr_data_ALU_AC));
		elsif secim = "01" then
			 rd_data_ALU_signal <= std_logic_vector(signed(wr_data_ALU_AC) + 1);
		elsif secim = "10" then
			rd_data_ALU_signal <= std_logic_vector(not signed(wr_data_ALU_INPR)); 
		elsif secim="11" then
			rd_data_ALU_signal(0) <= (not wr_data_ALU_TR(3) and wr_data_ALU_TR(1)) or (wr_data_ALU_TR(3) and not wr_data_ALU_TR(1));
         rd_data_ALU_signal(3) <= '0';
		end if;
end process;
		
		         rd_data_ALU <=rd_data_ALU_signal;         
					wr_data_ac <= rd_data_ALU_signal;
					ld_AC <= '1';
		
			

end Behavioral;
