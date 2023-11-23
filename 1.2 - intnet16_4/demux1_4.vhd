
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

architecture Behavioral of demux1_4 is
    begin
        process(s, a) is
            begin
                if (s = "00") then y(0) <= a; 
                elsif (s = "01") then y(1) <= a;
                elsif (s = "10") then y(2) <= a;
                elsif (s = "11") then y(3) <= a;
                else y <= "----"; 
                end if;
        end process;

end Behavioral;
