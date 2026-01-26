library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
port(
    S: in std_logic_vector(2 downto 0);
    A: in std_logic_vector(4 downto 0);
    Q: out std_logic
);
end mux;

architecture Behavioral of mux is
begin

Q <= (not S(2) and not S(1) and not S(0) and A(0)) or
     (not S(2) and not S(1) and     S(0) and A(1)) or
     (not S(2) and     S(1) and not S(0) and A(2)) or
     (not S(2) and     S(1) and     S(0) and A(3)) or
     (    S(2) and not S(1) and not S(0) and A(4));

end Behavioral;
