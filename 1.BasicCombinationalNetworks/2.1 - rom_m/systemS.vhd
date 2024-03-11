
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity systemS is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           y : out STD_LOGIC_VECTOR (3 downto 0));
end systemS;

architecture structural of systemS is

    signal u : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

    component rom_comb                  
        Port (  address : in STD_LOGIC_VECTOR (3 downto 0);
                data : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component encoder
        Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
               z : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    begin
        rom: rom_comb port map(
            address => a,
            data => u);
        
        enc: encoder port map(
            x => u,
            z => y);
            
end structural;
