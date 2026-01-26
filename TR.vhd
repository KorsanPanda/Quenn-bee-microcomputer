
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity TR is
port(clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     wr_data  : in std_logic_vector(3 downto 0);
     rd_data  : out std_logic_vector(3 downto 0)
);
end TR;

architecture Behavioral of TR is
signal reg : std_logic_vector(3 downto 0) := (others => '0');
signal t0, t1, t2, t3, t4, t5 : std_logic;
signal LD_s : std_logic;
--IR sinyalleri 
signal ld_ir: std_logic;
signal opc_out  : std_logic_vector(2 downto 0);
signal addr_out : std_logic_vector(10 downto 0);
signal reg_cmd  : std_logic_vector(10 downto 0);
signal is_d7    : std_logic;
signal addr_mode : std_logic_vector(1 downto 0);

component  IR is
    Port (
        clk        : in  std_logic;
        clr        : in  std_logic;
        LD         : in  std_logic;
        opc_out    : out std_logic_vector(2 downto 0);   -- Bit 13-11
        addr_out   : out std_logic_vector(10 downto 0);  -- Bit 10-0
        reg_cmd    : out std_logic_vector(10 downto 0);  -- D7 komutu için
        is_d7      : out std_logic;                      -- D7 mý? (flag)
        addr_mode  : out std_logic_vector(1 downto 0)    -- Bit 15-14
    );
end component ;

component SAYAC is
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
end component;
begin
SAYAC_U : SAYAC
    port map (
        clk => clk,
        clr => clr,
        t0  => t0,
        t1  => t1,
        t2  => t2,
        t3  => t3,
        t4  => t4,
        t5  => t5
    );
	 IR_U : IR
    port map (
        clk      => clk,
		  clr      => clr,
        LD       => ld_ir,
        opc_out  => opc_out,
        addr_out => addr_out,
        reg_cmd  => reg_cmd,
        is_d7    => is_d7,
		  addr_mode=> addr_mode
    );
	process(clk,CLR)
		begin
			if (CLR='1') then
				reg <= (others => '0');
			elsif (clk'event and clk='1') then
			if ( opc_out = "000" and t4='1') or ( opc_out = "001" and t4='1')or ( opc_out = "101" and t4='1') or ( opc_out = "110" and t4='1')or ( opc_out = "111" and reg_cmd = "011" and  t3='1' ) then
				    LD_s <= '1';
			 end if;		 
			if (LD_s = '1') then
					reg <= wr_data;
					
				end if;
			end if;
	 end process;
rd_data <= reg;

end Behavioral;
