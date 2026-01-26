library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
port(clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     INR : in std_logic;
     wr_data  : in std_logic_vector(10 downto 0);
     rd_data  : out std_logic_vector(10 downto 0)
);
end PC;

architecture Behavioral of PC is

--IR
signal ld_IR       : std_logic;
signal clr_IR      : std_logic;
signal opc_out     : std_logic_vector(2 downto 0);
signal addr_out    : std_logic_vector(10 downto 0);
signal reg_cmd     : std_logic_vector(10 downto 0);
signal is_d7       : std_logic;
signal addr_mode   : std_logic_vector(1 downto 0);
--sayac
signal t0, t1, t2, t3, t4, t5 : std_logic;
--pc
signal ld_pc : std_logic;
signal inr_pc : std_logic;
signal reg : std_logic_vector(10 downto 0) := (others => '0');

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
component  IR is
    Port (
        clk        : in  std_logic;
        clr        : in  std_logic;
        LD         : in  std_logic;
        opc_out    : out std_logic_vector(2 downto 0);   -- Bit 13-11
        addr_out   : out std_logic_vector(10 downto 0);  -- Bit 10-0
        reg_cmd    : out std_logic_vector(10 downto 0);  -- D7 komutu iin
        is_d7      : out std_logic;                      -- D7 m? (flag)
        addr_mode  : out std_logic_vector(1 downto 0)    -- Bit 15-14
    );
end component ;

begin
ld_pc <= LD;
inr_pc <= INR;

IR_U : IR
port map (
    clk       => clk,
    clr       => clr_IR,
    LD        => ld_IR,
    opc_out   => opc_out,
    addr_out  => addr_out,
    reg_cmd   => reg_cmd,
    is_d7     => is_d7,
    addr_mode => addr_mode
);
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
process(clk, CLR)
begin
    if CLR = '1' then
        reg <= (others => '0');
    elsif clk'event and clk = '1' then
        if ((opc_out = "011" and t4 = '1') or (opc_out = "100" and t4 = '1')) then
            ld_pc <= '1';
        else
            ld_pc <= '0';
        end if;

        if ld_pc = '1' then
            reg <= wr_data;

            if (opc_out = "100" and t4 = '1') then
                inr_pc <= '1';
            else
                inr_pc <= '0';
            end if;

            if inr_pc = '1' then
                reg <= std_logic_vector(unsigned(wr_data) + 1);
            end if;
        end if;
    end if;
end process;
rd_data <= reg;

end Behavioral;