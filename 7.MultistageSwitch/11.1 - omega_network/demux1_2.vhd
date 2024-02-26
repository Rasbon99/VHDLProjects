library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux1_2 is
    Generic ( N : integer := 2 ); 
    Port ( a : in STD_LOGIC_VECTOR (N-1 downto 0);
           s : in STD_LOGIC;
           y0 : out STD_LOGIC_VECTOR (N-1 downto 0);
           y1 : out STD_LOGIC_VECTOR (N-1 downto 0));
end demux1_2;

architecture Dataflow of demux1_2 is
begin
        y0 <= a when s = '0' else (others => '0');
        y1 <= a when s = '1' else (others => '0');
end Dataflow;
