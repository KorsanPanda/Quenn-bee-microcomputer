library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Kesme_Denetleyici is
    Port (
        saat        : in  STD_LOGIC;
        sifirla     : in  STD_LOGIC;
        veri_giris  : in  STD_LOGIC_VECTOR(7 downto 0);
        IEN     : in  STD_LOGIC;
        kesme       : out STD_LOGIC;
        led_uyari   : out STD_LOGIC
    );
end Kesme_Denetleyici;

architecture Davranissal of Kesme_Denetleyici is

    -- Component tanýmý
    component PC
        port(
            clk     : in  std_logic;
            CLR     : in  std_logic;
            LD      : in  std_logic;
            INR     : in  std_logic;
            wr_data : in  std_logic_vector(10 downto 0);
            rd_data : out std_logic_vector(10 downto 0)
        );
    end component;

    -- PC ile baðlantý için sinyaller
    signal pc_wr_data : std_logic_vector(10 downto 0) := (others => '0');
    signal pc_rd_data : std_logic_vector(10 downto 0);
    signal pc_ld      : std_logic := '0';

    -- Basit AC ve INPR tanýmý (register deðil, sinyal olarak)
    signal AC    : std_logic_vector(7 downto 0) := (others => '0');
    signal INPR  : std_logic_vector(7 downto 0) := (others => '0');

begin

    -- PC instance
    pc_inst : PC
        port map (
            clk     => saat,
            CLR     => sifirla,
            LD      => pc_ld,
            INR     => '0',
            wr_data => pc_wr_data,
            rd_data => pc_rd_data
        );

    -- LED kesme sinyalini izliyor
    led_uyari <= kesme;

    process(saat, sifirla)
    begin
        if sifirla = '1' then
            kesme   <= '0';
            pc_ld   <= '0';
            AC      <= (others => '0');
            INPR    <= (others => '0');
        elsif rising_edge(saat) then
            if IEN = '1' then
                INPR <= veri_giris;  -- Input'u INPR'ye al

                if unsigned(veri_giris) > 128 then --tek 
                    kesme       <= '1';
                    pc_wr_data  <= (others => '0'); -- PC'ye 0 yükle
                    pc_ld       <= '1';
                    SC <= 0; --Eðer SC varsa burada kontrol edilir
                else
                    kesme       <= '0';
                    pc_ld       <= '0';
                    AC          <= INPR; -- Kesme yoksa AC'ye aktar
                end if;
            else
                pc_ld <= '0';
            end if;
        end if;
    end process;

end Davranissal;
