library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LED_Switch_Controller is
    Port (
        clk       : in  std_logic;
        led       : out std_logic_vector(7 downto 0);
        sw        : in  std_logic_vector(7 downto 0);
        btn       : in  std_logic_vector(3 downto 0);
        seg       : out std_logic_vector(7 downto 0);
        an        : out std_logic_vector(3 downto 0)
    );
end LED_Switch_Controller;

architecture Behavioral of LED_Switch_Controller is

    -- Signal declaration
    signal out_register : std_logic_vector(7 downto 0);

begin

    -- Process to drive the output register
    process(clk)
    begin
        if rising_edge(clk) then
            out_register <= led; -- LED'ler register'a yazýlýr
        end if;
    end process;

    -- Çýkýþ pin baðlantýlarý
    LED_0 <= out_register(0);
    LED_1 <= out_register(1);
    LED_2 <= out_register(2);
    LED_3 <= out_register(3);
    LED_4 <= out_register(4);
    LED_5 <= out_register(5);
    LED_6 <= out_register(6);
    LED_7 <= out_register(7);

    -- Burada switch ve butonlarý kullanarak iþlem yapabilirsiniz
    -- Örnek: butonlara göre LED'leri kontrol etme

end Behavioral;
