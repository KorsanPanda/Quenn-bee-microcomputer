library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity veriyolu is 
	port (
		S:  in std_logic_vector(2 downto 0);
		data_out: out std_logic_vector(15 downto 0);
		clk      : in std_logic;
      rst      : in std_logic;
      wr_en    : in std_logic;
		wr_data  : in std_logic_vector(15 downto 0)
		
	);
end veriyolu;
		
architecture Behavioral of veriyolu is
	  signal temp0: std_logic_vector( 15 downto 0);
	  signal temp2 : std_logic_vector(3 downto 0);
	  signal temp3, temp4 : std_logic_vector (10 downto 0);
	  type ram_type is array (0 to 19) of std_logic_vector(15 downto 0); 
	  signal memory : ram_type;
	  signal temp1 : std_logic_vector (15 downto 0);
	  signal wr_data_ac : std_logic_vector(3 downto 0);


Component IR is
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
end component IR;



  component AC is
    port(
        clk      : in std_logic;
        CLR      : in std_logic;
        LD       : in std_logic;
        INR      : in std_logic;
        wr_data  : in std_logic_vector(3 downto 0);
        rd_data  : out std_logic_vector(3 downto 0)
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
		port(S:in std_logic_vector(2 downto 0);
			  A:in std_logic_vector(4 downto 0);
			  Q:out std_logic);
		end component ;
begin 



reg1: AC
port map(
	clk => clk,
	CLR => rst,
	LD => wr_en,
	INR => '0',
	wr_data => wr_data_ac,
	rd_data => temp2
);

reg2: PC
port map(
	clk => clk,
	CLR => rst,
	LD => wr_en,
	INR => '0',
	wr_data => wr_data(10 downto 0), -- PC 11 bit
	rd_data => temp3(10 downto 0)
);
temp2(3 downto 0) <= (others => '0');  -- 

reg3: AR
port map(
	clk => clk,
	CLR => rst,
	LD => wr_en,
	INR => '0',
	wr_data => wr_data(10 downto 0), -- AR 11 bit
	rd_data => temp4(10 downto 0)
);
temp1 <= memory(to_integer(unsigned(temp4)));
temp3(10 downto 0) <= (others => '0');  

reg4: IR
Port map( 
        clr        => rst,
        clk        => clk, 
        LD         => wr_en, 
        opc_out    => temp0(13 downto 11),
        addr_out   => temp0(10 downto 0),
        reg_cmd    => open, 
        is_d7      => open,              
        addr_mode  => temp0(15 downto 14) 
);

mux0: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> '0' ,
	A(2)=> '0' ,
	A(3)=> temp0(0),
	A(4)=> temp1(0),
	Q => data_out(0) 
);

mux1: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> '0' ,
	A(2)=> '0' ,
	A(3)=> temp0(1),
	A(4)=> temp1(1),
	Q => data_out(1) 
);

mux2: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> '0' ,
	A(2)=> '0' ,
	A(3)=> temp0(2),
	A(4)=> temp1(2),
	Q => data_out(2) 
);

mux3: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> '0' ,
	A(2)=> '0' ,
	A(3)=> temp0(3),
	A(4)=> temp1(3),
	Q => data_out(3) 
);

mux4: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> '0' ,
	A(2)=> '0' ,
	A(3)=> temp0(4),
	A(4)=> temp1(4),
	Q => data_out(4) 
);

mux5: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> temp4(0) ,
	A(2)=> temp3(0) ,
	A(3)=> temp0(5),
	A(4)=> temp1(5),
	Q => data_out(5) 
);

mux6: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> temp4(1) ,
	A(2)=> temp3(1) ,
	A(3)=> temp0(6),
	A(4)=> temp1(6),
	Q => data_out(6) 
);

mux7: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> temp4(2),
	A(2)=> temp3(2) ,
	A(3)=> temp0(7),
	A(4)=> temp1(7),
	Q => data_out(7) 
);

mux8: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> temp4(3) ,
	A(2)=> temp3(3) ,
	A(3)=> temp0(8),
	A(4)=> temp1(8),
	Q => data_out(8) 
);

mux9: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> temp4(4) ,
	A(2)=> temp3(4) ,
	A(3)=> temp0(9),
	A(4)=> temp1(9),
	Q => data_out(9) 
);

mux10: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> temp4(5) ,
	A(2)=> temp3(5) ,
	A(3)=> temp0(10),
	A(4)=> temp1(10),
	Q => data_out(10) 
);

mux11: mux
port map(
	S => S,
	A(0)=> '0' ,
	A(1)=> temp4(6) ,
	A(2)=> temp3(6) ,
	A(3)=> temp0(11),
	A(4)=> temp1(11),
	Q => data_out(11) 
);

mux12: mux
port map(
	S => S,
	A(0)=> temp2(0) ,
	A(1)=> temp4(7) ,
	A(2)=> temp3(7) ,
	A(3)=> temp0(12),
	A(4)=> temp1(12),
	Q => data_out(12) 
);

mux13: mux
port map(
	S => S,
	A(0)=> temp2(1) ,
	A(1)=> temp4(8) ,
	A(2)=> temp3(8) ,
	A(3)=> temp0(13),
	A(4)=> temp1(13),
	Q => data_out(13) 
);

mux14: mux
port map(
	S => S,
	A(0)=> temp2(2) ,
	A(1)=> temp4(9) ,
	A(2)=> temp3(9) ,
	A(3)=> temp0(14),
	A(4)=> temp1(14),
	Q => data_out(14) 
);

mux15: mux
port map(
	S => S,
	A(0)=> temp2(3) ,
	A(1)=> temp4(10) ,
	A(2)=> temp3(10) ,
	A(3)=> temp0(15),
	A(4)=> temp1(15),
	Q => data_out(15) 
);




end Behavioral;

