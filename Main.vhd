library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;             

library std;
use std.textio.all;     

entity MAIN is
    Port (
        clk : in std_logic;
        instr : in std_logic_vector(15 downto 0);  -- Komut girisi
        ld_ir : in std_logic;
        clr : in std_logic;
        LD : in std_logic;
		 -- bellek
        address    : in std_logic_vector(4 downto 0);           -- 5 bit (0-19 aras)
        write_en   : in std_logic;
        mem_enable : in std_logic
    );
end MAIN;

architecture Behavioral of MAIN is

-- COMPONENT TANIMLARI
component ALU is
    Port (
		wr_data_ALU_TR:std_logic_vector(3 downto 0);
		wr_data_ALU_INPR:std_logic_vector(3 downto 0);
		wr_data_ALU_AC:std_logic_vector(3 downto 0);
		rd_data_ALU:std_logic_vector(3 downto 0);
		secim:std_logic_vector(1 downto 0)
		 );
end component;

component veriyolu is 
	port (
	   S         :in std_logic_vector(2 downto 0);
		data_out: out std_logic_vector(15 downto 0);
		clk      : in std_logic;
      rst      : in std_logic;
      wr_en    : in std_logic;
		wr_data  : in std_logic_vector(15 downto 0)
		
	);
end component ;


Component RAM_with_Random is
    Port (
        clk         : in  std_logic;
        addr        : in  std_logic_vector(10 downto 0);
        data_out    : out std_logic_vector(15 downto 0);
        write_enable: in  std_logic;
        data_in     : in  std_logic_vector(15 downto 0)
    );
end component;


component  SAYAC is
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

component TR is
port(
	  clk : in std_logic;
     CLR : in std_logic;
     LD  : in std_logic;
     wr_data  : in std_logic_vector(3 downto 0);
     rd_data  : out std_logic_vector(3 downto 0)
);
end component;

component AR is
    port (
        clk     : in std_logic;
        CLR     : in std_logic;
        LD      : in std_logic;
        INR     : in std_logic;
		  t0		 : in std_logic;
        wr_data : in std_logic_vector(10 downto 0);
        rd_data : out std_logic_vector(10 downto 0)
    );
end component;

component PC is
    port (
        clk     : in std_logic;
        CLR     : in std_logic;
        LD      : in std_logic;
        INR     : in std_logic;
        wr_data : in std_logic_vector(10 downto 0);
        rd_data : out std_logic_vector(10 downto 0)
    );
end component;

component IR is
    Port (
        clk       : in  std_logic;
        LD        : in  std_logic;
		  t0         : in std_logic;
		  t1         : in std_logic;
		  t2         : in std_logic;
        opc_out   : out std_logic_vector(2 downto 0);
        addr_out  : out std_logic_vector(10 downto 0);
        reg_cmd   : out std_logic_vector(10 downto 0);
        is_d7     : out std_logic;
		  addr_mode  : out std_logic_vector(1 downto 0) 
		  
    );
end component;

component AC is
    port (
        clk     : in std_logic;
        CLR     : in std_logic;
        LD      : in std_logic;
        INR     : in std_logic;
        wr_data : in std_logic_vector(3 downto 0);
        rd_data : out std_logic_vector(3 downto 0)
    );
end component;

component INPR is
    Port (
        clk      : in  std_logic;
        wr_data  : in  std_logic_vector(3 downto 0);
        rd_data  : out std_logic_vector(3 downto 0) 
    );
end component;

component OUTR is
    Port (
        clk      : in  std_logic;
        LD       : in  std_logic;
        wr_data  : in  std_logic_vector(7 downto 0);
        rd_data  : out std_logic_vector(7 downto 0)
    );
end component;

-- SNYALLER
--IR SNYALLER 
signal opc_out  : std_logic_vector(2 downto 0);
signal addr_out : std_logic_vector(10 downto 0);
signal reg_cmd  : std_logic_vector(10 downto 0);
signal is_d7    : std_logic;
signal addr_mode : std_logic_vector(1 downto 0);
-- INPR SNYALLER 
signal rd_data_inpr : std_logic_vector(3 downto 0);
signal wr_data_inpr : std_logic_vector(3 downto 0);

--OUTR SNYALLER 
signal wr_data_outr : std_logic_vector(7 downto 0);
signal ld_outr      : std_logic := '0';
--AC SNYALLER 
signal rd_data_ac  : std_logic_vector(3 downto 0);
signal wr_data_ac : std_logic_vector(3 downto 0);
signal inr_ac : std_logic := '0';
signal ld_ac : std_logic :='0';
--AR SNYALLER
signal rd_data_ar: std_logic_vector(10 downto 0);
signal wr_data_ar: std_logic_vector(10 downto 0);
signal inr_ar : std_logic := '0';
signal ld_ar      : std_logic := '0';
--PC SNYALLER
signal rd_data_pc : std_logic_vector(10 downto 0);
signal wr_data_pc : std_logic_vector(10 downto 0) := (others => '0');
signal ld_pc      : std_logic := '0';
signal inr_pc : std_logic := '0';

signal temp : std_logic; -- rnd temp atamas 
signal ien : std_logic := '0';
signal SC  : std_logic := '0';


--VERYOLU SNYALLER
signal rst : std_logic ;
signal S   : std_logic_vector(2 downto 0);


--TR SNYALLER
signal ld_TR     : std_logic := '0';
signal wr_data_TR : std_logic_vector(3 downto 0) := (others => '0');
signal rd_data_TR: std_logic_vector(3 downto 0);

signal t0, t1, t2, t3, t4, t5 : std_logic;

signal temp5: std_logic_vector( 15 downto 0);-- bus 

signal veriyolu_data: std_logic_vector(15 downto 0);


--RAM  
signal addr     :std_logic_vector(10 downto 0);
signal ram      :std_logic_vector(15 downto 0);
signal wr_en  	 : std_logic :='1';
signal data_in  : std_logic_vector(15 downto 0);
--ALU
signal wr_data_ALU_TR     : std_logic_vector(3 downto 0);
signal wr_data_ALU_INPR   : std_logic_vector(3 downto 0);
signal wr_data_ALU_AC     : std_logic_vector(3 downto 0);
signal rd_data_ALU        : std_logic_vector(3 downto 0);
signal secim				  : std_logic_vector(1 downto 0);

-- RAM rnei (M bellek)
--type mem_type is array (0 to 2047) of std_logic_vector(15 downto 0);
--signal ram : mem_type := (others => (others => '0'));
--file mem_file : text open read_mode is "MEMORY.mem";
--signal data_val : std_logic_vector(15 downto 0);

begin

-- IR bileeni


ALU_instance : ALU
port map (
    wr_data_ALU_TR    => wr_data_ALU_TR,
    wr_data_ALU_INPR  => wr_data_ALU_INPR,
    wr_data_ALU_AC    => wr_data_ALU_AC,
    rd_data_ALU       => rd_data_ALU,
	 secim             => secim
);

IR_U : IR
    port map (
        clk      => clk,
        LD       => ld_ir,
		  t0       => t0,
		  t1       => t1,
   	  t2       => t2,
        opc_out  => opc_out,
        addr_out => addr_out,
        reg_cmd  => reg_cmd,
        is_d7    => is_d7,
		  addr_mode=> addr_mode
    );
	 
-- veriyolu bileseni 
VERYOLU_U : veriyolu
	 port map ( 
		S => S,
		data_out => temp5, 
		clk => clk ,
      rst => rst ,
      wr_en => wr_en, 
		wr_data => veriyolu_data
);			

-- INPR bileeni

INPR_U : INPR
    port map (
        clk      => clk,
        wr_data  => wr_data_inpr,
        rd_data  => rd_data_inpr
    );

-- OUTR bileeni
OUTR_U : OUTR
    port map (
        clk      => clk,
        LD       => ld_outr,
        wr_data  => wr_data_outr
    );

-- AC bileeni
AC_U : AC
    port map (
        clk      => clk,
        CLR      => clr,
        LD       => ld_ac,
        INR      => inr_ac,
        wr_data  => wr_data_ac,
        rd_data  => rd_data_ac
    );
	
-- AR bileeni
AR_U : AR
    port map (
        clk     => clk,
        CLR     => clr,
        LD      => ld_ar,
        INR     => inr_ar,
		  t0      => t0,
        wr_data => wr_data_ar,
        rd_data => rd_data_ar
    );

-- PC bileeni
PC_U : PC
    port map (
        clk     => clk,
        CLR     => clr,
        LD      => ld_pc,
        INR     => inr_pc,
        wr_data => wr_data_pc,
        rd_data => rd_data_pc
    );

-- TR bileeni
TR_U : TR
    port map (
        clk     => clk,
        CLR     => clr,
        LD      => ld_TR,
        wr_data => wr_data_TR,
        rd_data => rd_data_TR
    );
	 
--sayac bileeni 
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
	 
	 
--RAM
RAM_with_Random_U :RAM_with_Random 
    port map (
        clk         =>clk,
        addr        =>addr,
        data_out    => ram,
        write_enable => wr_en,
        data_in     => data_in
    );
	
-- PROCESS BLOU 

 process(t0,t1,t2,t3,t4,t5,opc_out,reg_cmd)
    begin
        S <= "ZZZ"; -- Varsaylan: seimsiz
        --veriyolu_data <= (others => 'Z'); -- Tri-state

        -- MemoryOut iin D0, D1, D5, D6 ve T4
        if (t4 = '1') and ( opc_out = "000" or  opc_out = "001" or  opc_out = "101" or  opc_out = "110") then
            S <= "101";
             veriyolu_data <= ram;

        -- PC iin T0
        elsif (t0 = '1') then
            S <= "010";
             veriyolu_data(10 downto 0) <= rd_data_pc ;

        -- AC iin D7, rB3 ve T3
        elsif (t3 = '1') and  opc_out = "111" and reg_cmd = "011" then
            S <= "011";
             veriyolu_data(3 downto 0) <= rd_data_ac;

        -- AR iin D3 ve T4
        elsif (t4 = '1') and opc_out = "011" then
            S <= "001";
             veriyolu_data(10 downto 0) <= rd_data_ar;

        -- IR iin T2
        elsif (t2 = '1') then
            S <= "100";
             veriyolu_data (13 downto 11 ) <= opc_out; 
				 veriyolu_data (10 downto 0 ) <= addr_out; 
				 veriyolu_data (15 downto 14 ) <= addr_mode ;
        end if;
    end process;




process(clk)
begin
    if rising_edge(clk) then
        -- Her saat darbesinde kontrol sinyalleri sfrlanr
        ld_pc <= '0';
        ld_outr <= '0';
        ld_TR <= '0';
			

        if is_d7 = '0' then
		  
            case addr_mode is
                when "00" =>  -- Doğrudan adresleme
                    case opc_out is
                        when "000" =>  -- D0: AND
                            if t4 = '1' then
                                wr_data_TR <= ram(3 downto 0);
                                ld_TR <= '1';
                            else
                                ld_TR <= '0';
                            end if;
                            if t5 = '1' then
                                rd_data_ac <= std_logic_vector(unsigned(rd_data_ac) and unsigned(rd_data_TR));
                                SC <= '0';
                            end if;

                        when "001" =>  -- D1: OR
                            if t4 = '1' then
                                wr_data_TR <= ram(3 downto 0);
                                ld_TR <= '1';
                            else
                                ld_TR <= '0';
                            end if;
                            if t5 = '1' then
                                rd_data_ac <= std_logic_vector(unsigned(rd_data_ac) or unsigned(rd_data_TR));
                                SC <= '0';
                            end if;

                        when "010" =>  -- D2: STA
                            if t4 = '1' then
                                ram <= (others => '0');
                                ram(3 downto 0) <= rd_data_ac;
                                SC <= '0';
                            end if;

                        when "011" =>  -- D3: BUN
                            if t4 = '1' then
                                wr_data_pc <= rd_data_ar;
                                ld_pc <= '1';
                                SC <= '0';
                            end if;

                        when "100" =>  -- D4: PCP
                            if t4 = '1' then
                                ld_pc <= '1';
										  inr_pc <= '1';
                                SC <= '0';
                            end if;

                        when "101" =>  -- D5: ADD
                            if t4 = '1' then
                                wr_data_TR <= ram(3 downto 0);
                                ld_TR <= '1';
										 
                            else
                                ld_TR<= '0';
                            end if;
									 if t5 = '1' then
										  rd_data_ac <= std_logic_vector(signed(rd_data_ac) + signed(rd_data_TR));
                                SC <= '0';
										  secim<="00";
									 end if;
									 

                        when "110" =>  -- D6: LDA
                            if t4 = '1' then
                                wr_data_TR <= ram(3 downto 0);
                                ld_TR <= '1';
                            else
                                ld_TR <= '0';
                            end if;
									 if t5 = '1' then
										  rd_data_ac  <= rd_data_TR;
                                SC <= '0';
									 end if ;

                        when others =>
                            null;
                    end case;

                   

                when "01" =>  -- Dolaylı adresleme LDA
                    if opc_out = "110" then
                        if t4 = '1' then
                            addr <= ram(10 downto 0);
									 wr_data_TR <= ram(3 downto 0);
                            ld_TR <= '1';
                        else
                            ld_TR <= '0';
                        end if;
                        if t5 = '1' then
                            rd_data_ac  <= rd_data_TR;
                            SC <= '0';
                        end if;
                    end if;

                when "10" =>  -- Hemen adresleme  ADD 
					 
						if opc_out = "101" then
							  if t5 = '1' then
									rd_data_ac  <= std_logic_vector(signed(rd_data_ac) + signed(addr_out(3 downto 0)));
									SC <= '0';
									secim<="01";
							  end if;
						end if;
                when "11" =>  -- Kayt adresleme (D7 islemleri)
                    if t3 = '1' then
                        if reg_cmd(3) = '1' then  -- RND
                            wr_data_TR(3) <= rd_data_TR(2);
									 wr_data_TR(2) <= rd_data_TR(1);
									 wr_data_TR(1) <= rd_data_TR(0);
                            ld_TR <= '1';
                            temp <= rd_data_TR(3) xor rd_data_TR(1);
                            wr_data_ac <= (others => '0');
                            wr_data_ac <= rd_data_tr;
									 wr_data_ac(0) <= temp;
                            wr_data_ac(3) <= '0';
                            ld_ac <= '1';
									 secim<="11";

                        elsif reg_cmd(4) = '1' then  -- IOF
                            ien <= '0';

                        elsif reg_cmd(5) = '1' then  -- ION
                            ien <= '1';

                        elsif reg_cmd(6) = '1' then  -- OUT
                            wr_data_outr (3 downto 0) <= rd_data_ac ;
                            ld_outr <= '1';

                        elsif reg_cmd(7) = '1' then  -- INP
                            rd_data_ac (3 downto 0) <= rd_data_inpr;

                        elsif reg_cmd(8) = '1' then  -- HLT
                            t0 <= '1';

                        elsif reg_cmd(9) = '1' then  -- STP
								
                            if signed(rd_data_ac)  = "0000" then
									 
                                wr_data_outr <= "01000011";  -- 'd'
                                ld_outr <= '1';
										  
                            elsif signed(rd_data_ac) <  "0000" then
									 
                                wr_data_outr <= "00000111";  -- 'b'
                                ld_outr <= '1';
										  ld_pc <= '1';
										  inr_pc <= '1';

										  
                            else
									 
                                wr_data_outr <= "00101101";  -- 'k'
                                ld_outr <= '1';
										  ld_pc <= '1';
										  inr_pc <= '1';

                            end if;

                        elsif reg_cmd(10) = '1' then  -- CMA
                            rd_data_ac <= not rd_data_ac ;
									 secim<="10";
                        end if;
                    else
                        ld_TR <= '0';
                        ld_ar <= '0';
								ld_pc <= '0';
                        ld_outr <= '0';
                    end if;

                when others =>
                    null;
            end case;
        end if;
		  -- AR register'a veriyolu üzerinden veri gndermek
			wr_data_ar <= temp5(10 downto 0);
			--OUTR register'a veriyolu üzerinden veri gndermek
			wr_data_outr <= temp5(7 downto 0);
			--TR  register'a veriyolu üzerinden veri gndermek
			wr_data_TR <= temp5(3 downto 0);
			--PC register'a veriyolu üzerinden veri gndermek
			wr_data_pc <= temp5(10 downto 0);
    end if;
end process;

end Behavioral;
