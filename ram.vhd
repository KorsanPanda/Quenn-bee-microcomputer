library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_with_Random is
    Port (
        clk         : in  std_logic;
        addr        : in  std_logic_vector(10 downto 0);
        data_out    : out std_logic_vector(15 downto 0);
        write_enable: in  std_logic;
        data_in     : in  std_logic_vector(15 downto 0)
    );
end RAM_with_Random;

architecture Behavioral of RAM_with_Random is
    type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
    signal RAM : ram_type;

    -- Bellek balang iin .mem dosyasndan ykleme (sentez aralar destekliyorsa)
begin
    -- RAM yklemesi baz simlatrlerde farkldr,
    -- rnein ModelSim iin:
    -- process
    -- begin
    --   file_open("memory_init.mem", ...)
    --   -- buraya dosya okuma kodu (simlatr destekliyorsa)
    -- end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                RAM(to_integer(unsigned(addr))) <= data_in;
            end if;
            data_out <= RAM(to_integer(unsigned(addr)));
        end if;
    end process;

end Behavioral;