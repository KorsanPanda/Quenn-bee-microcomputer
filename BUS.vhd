ibrary IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity veriyolu is 
	port (
		S:  in std_logic_vector(3 downto 0);
		data_out: out std_logic_vector(15 downto 0);
		clk      : in std_logic;
      rst      : in std_logic;
      wr_en    : in std_logic;
		wr_data  : in std_logic_vector(15 downto 0)
		
	);
end veriyolu;
		
architecture Behavioral of veriyolu is
	  signal temp0,temp1, temp2 , temp3, temp4, temp5, temp6, temp7,temp8, temp9 : std_logic_vector( 15 downto 0);
	  
	 component  INPR is
    Port (
        clk      : in std_logic;
        wr_data  : in std_logic_vector(15 downto 0);
        rd_data  : out std_logic_vector(15 downto 0)
    );
end component ;


 component IR is
    Port (
        instr     : in  std_logic_vector(15 downto 0);  -- 16 bitlik komut
        clk       : in  std_logic;
        LD        : in  std_logic;                      -- Komutu yükle sinyali
        opc_out   : out std_logic_vector(2 downto 0);   -- Bit 13-11
        addr_out  : out std_logic_vector(10 downto 0);  -- Bit 10-0
        reg_cmd   : out std_logic_vector(10 downto 0);  -- D7 komutu için
        is_d7     : out std_logic                       -- D7 mý? (flag)
    );
end component;

component OUTR is

    Port (
        clk      : in  STD_LOGIC;                      -- Saat sinyali
        LD      : in  STD_LOGIC;                      -- Yükleme kontrol sinyali
        wr_data  : in  STD_LOGIC_VECTOR(7 downto 0);   -- Yazýlacak veri (giriþ)
        rd_data  : out STD_LOGIC_VECTOR(7 downto 0)    -- Okunacak veri (çýkýþ)
    );
	 
end  component ;

  component AC is
    port(
        clk      : in std_logic;
        CLR      : in std_logic;
        LD       : in std_logic;
        INR      : in std_logic;
        wr_data  : in std_logic_vector(15 downto 0);
        rd_data  : out std_logic_vector(15 downto 0)
    );
end component ;

component  AR is
    port(
        clk      : in std_logic;
        CLR      : in std_logic;
        LD       : in std_logic;
        INR      : in std_logic;
        wr_data  : in std_logic_vector(10 downto 0);
        rd_data  : out std_logic_vector(10 downto 0)
    );
end component;

component  PC is
port(clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     INR : in std_logic;
     wr_data  : in std_logic_vector(10 downto 0);
     rd_data  : out std_logic_vector(10 downto 0)
);
end component ;

	component mux is
		port(S:in std_logic_vector(3 downto 0);
			  A:in std_logic_vector(9 downto 0);
			  Q:out std_logic);
		end component ;
begin 

reg0: INPR
port map(
	clk => clk,
	wr_data => wr_data,
	rd_data => temp0
);

reg1: AC
port map(
	clk => clk,
	CLR => rst,
	LD => wr_en,
	INR => '0',
	wr_data => wr_data,
	rd_data => temp1
);

reg2: PC
port map(
	clk => clk,
	CLR => rst,
	LD => wr_en,
	INR => '0',
	wr_data => wr_data(10 downto 0), -- PC 11 bit
	rd_data => temp2(10 downto 0)
);
temp2(15 downto 11) <= (others => '0');  -- 11 bit'i 16 bit'e geniþletme

reg3: AR
port map(
	clk => clk,
	CLR => rst,
	LD => wr_en,
	INR => '0',
	wr_data => wr_data(10 downto 0), -- AR 11 bit
	rd_data => temp3(10 downto 0)
);
temp3(15 downto 11) <= (others => '0');  -- 11 bit'i 16 bit'e geniþletme

reg4: OUTR
port map(
	clk => clk,
	LD => wr_en,
	wr_data => wr_data(7 downto 0),
	rd_data => temp4(7 downto 0)
);
temp4(15 downto 8) <= (others => '0'); -- 8 bit'i 16 bit'e geniþletme

reg5: IR
port map(
	instr => wr_data,
	clk => clk,
	LD => wr_en,
	opc_out => temp5(15 downto 13),         -- 3 bit
	addr_out => temp5(10 downto 0),         -- 11 bit
	reg_cmd => open,                        -- kullanýlmýyor
	is_d7 => open                           -- kullanýlmýyor
);
