
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_1 is
    Generic ( N : integer := 2 ); 
    Port ( a0 : in STD_LOGIC_VECTOR (N-1 downto 0);
           a1 : in STD_LOGIC_VECTOR (N-1 downto 0);
           s : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (N-1 downto 0));
end mux2_1;

architecture Dataflow of mux2_1 is
begin
    y <=    a0 when s = '0' else
            a1 when s = '1' else
            (others => '-');
end Dataflow
;


