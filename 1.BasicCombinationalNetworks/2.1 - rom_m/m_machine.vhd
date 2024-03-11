
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity m_machine is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           z : out STD_LOGIC_VECTOR (3 downto 0));
end m_machine;

architecture Dataflow of m_machine is
    begin    
        z(0) <= (x(0) and x(1)) nor x(2);
        z(1) <= (x(2) and x(3)) nor x(4);
        z(2) <= (x(4) and x(5)) nor x(6);
        z(3) <= (x(6) and x(7)) nor x(0);
end Dataflow;
