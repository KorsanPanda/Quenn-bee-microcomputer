library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IR is
    Port (
        clk        : in  std_logic;
        clr        : in  std_logic;
        LD         : in  std_logic;
		  t0         : in std_logic;
		  t1         : in std_logic;
		  t2         : in std_logic;
        opc_out    : out std_logic_vector(2 downto 0);   -- Bit 13-11
        addr_out   : out std_logic_vector(10 downto 0);  -- Bit 10-0
        reg_cmd    : out std_logic_vector(10 downto 0);  -- D7 komutu iin
        is_d7      : out std_logic;                      -- D7 m? (flag)
        addr_mode  : out std_logic_vector(1 downto 0)    -- Bit 15-14
		  
    );
end IR;

architecture Behavioral of IR is

    signal LD_s : std_logic;
	 signal INR_s : std_logic;
	 type memory_array is array (0 to 19) of std_logic_vector(15 downto 0);
    signal memory : memory_array := (others => (others => '0'));

    signal rd_data_pc, rd_data_ar : std_logic_vector(10 downto 0);
    signal instruction      : std_logic_vector(15 downto 0);
    signal opc              : std_logic_vector(2 downto 0);

    signal ld_pc  : std_logic := '0';
    signal inr_pc : std_logic := '0';
    signal ld_ar  : std_logic := '0';
	 signal wr_data_pc :std_logic_vector(10 downto 0);

    signal t0_s, t1_s, t2_s: std_logic;

    component PC is
        port(clk     : in std_logic;
             CLR     : in std_logic;
             LD      : in std_logic;
             INR     : in std_logic;
             wr_data : in std_logic_vector(10 downto 0);
             rd_data : out std_logic_vector(10 downto 0));
    end component;

    component AR is
        port(clk     : in std_logic;
             CLR     : in std_logic;
             LD      : in std_logic;
             INR     : in std_logic;
             wr_data : in std_logic_vector(10 downto 0);
             rd_data : out std_logic_vector(10 downto 0));
    end component;



begin
    t0_s <= t0;
	 t1_s <= t1;
	 t2_s <= t2;
	 
    pc_inst : PC
    port map (
        clk      => clk,
        CLR      => clr,
        LD       => ld_pc,
        INR      => inr_pc,
        wr_data  => (others => '1'),
        rd_data  => rd_data_pc
    );

    ar_inst : AR
    port map (
        clk      => clk,
        CLR      => clr,
        LD       => ld_ar,
        INR      => '0',
        wr_data  => wr_data_pc,
        rd_data  => rd_data_ar
    );

    process(clk)
    begin
        if rising_edge(clk) then
		  
				LD_s <= t1_s;
            if LD_s = '1' then
                if t0_s = '1' then 
                    ld_ar <= '1';
                end if;
                if t1_s = '1' then
                    instruction <= memory(to_integer(unsigned(rd_data_ar)));
                    inr_pc <= '1';
						  ld_pc <= '1';
                end if;

                if t2_s = '1' then 
                    opc <= instruction(13 downto 11);
                    opc_out <= opc;
                    addr_mode <= instruction(15 downto 14);

                    if opc < "111" then --1.GRUP' u belli etme 
                        addr_out <= instruction(10 downto 0);
                        reg_cmd  <= (others => '0');
                        is_d7    <= '0';
                    elsif opc = "111" then -- 2.GRUP ' u belli etme
                        addr_out <= (others => '0');
                        reg_cmd  <= instruction(10 downto 0);
                        is_d7    <= '1';
                    else
                        addr_out <= (others => '0');
                        reg_cmd  <= (others => '0');
                        is_d7    <= '0';
                    end if;
                else
                    ld_ar    <= '0';
                    inr_pc   <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
