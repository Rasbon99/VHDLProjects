
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demux1_4 is
    Port ( a : in STD_LOGIC;
           s : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC_VECTOR (3 downto 0));
end demux1_4;

-- questa prima soluzione non tiene conto della variazione indefinita 
-- dello stato in quanto non ha una condizione di default
architecture dataflow_1 of demux1_4 is
    begin
        y(0) <= a when s = "00" else '0';
        y(1) <= a when s = "01" else '0';
        y(2) <= a when s = "10" else '0';
        y(3) <= a when s = "11" else '0';
end dataflow_1;

-- soluzione più robusta, prevede un caso di default
architecture dataflow_2 of demux1_4 is
begin
    with s select
        y <= ('0', '0', '0', a) when "00",
             ('0', '0', a, '0') when "01",
             ('0', a, '0', '0') when "10",
             (a, '0', '0', '0') when "11",
             (others => '0') when others;

end dataflow_2;