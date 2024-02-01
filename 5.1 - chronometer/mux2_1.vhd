
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_1 is
    Port ( a : in STD_LOGIC_VECTOR (1 downto 0);
           s : in STD_LOGIC;
           y : out STD_LOGIC);
end mux2_1;

-- Conditional signal assignament
architecture Dataflow of mux2_1 is
    begin
        y <=    a(0) when s = '0' else
                a(1) when s = '1' else
                '-';
end Dataflow;


