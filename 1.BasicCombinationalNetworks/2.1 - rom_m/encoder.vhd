
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           z : out STD_LOGIC_VECTOR (3 downto 0));
end encoder;

architecture Dataflow of encoder is
    begin    
        z(0) <= '0' when x(0) = '1' else '1';
        z(1) <= '0' when x(1) = '1' else '1';
        z(2) <= '0' when x(2) = '1' else '1';
        z(3) <= '0' when x(3) = '1' else '1';
end Dataflow;
