
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_1_n is
    Generic(N : integer := 4);
    Port(   a : in STD_LOGIC_VECTOR (N-1 downto 0);
            b : in STD_LOGIC_VECTOR (N-1 downto 0);
            s : in STD_LOGIC;
            y : out STD_LOGIC_VECTOR (N-1 downto 0));
end mux2_1_n;

architecture Dataflow of mux2_1_n is
    begin
        y <=    a when s = '0' else
                b when s = '1' else
                (others => '-');
end Dataflow;