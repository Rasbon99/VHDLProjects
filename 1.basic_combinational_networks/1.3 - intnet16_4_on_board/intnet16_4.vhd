
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity intnet16_4 is
    Port ( b : in STD_LOGIC_VECTOR (15 downto 0);
           t : in STD_LOGIC_VECTOR (5 downto 0);
           z : out STD_LOGIC_VECTOR (3 downto 0));
end intnet16_4;

architecture structural of intnet16_4 is

    signal u : STD_LOGIC := '0'; 

    component mux16_1 is
        Port(   c : in STD_LOGIC_VECTOR (15 downto 0);
                r : in STD_LOGIC_VECTOR (3 downto 0);
                w : out STD_LOGIC); 
        end component;
        
    component demux1_4 is
        Port (  a : in STD_LOGIC;
                s : in STD_LOGIC_VECTOR (1 downto 0);
                y : out STD_LOGIC_VECTOR (3 downto 0));
         end component;
         
    for all : demux1_4 use entity work.demux1_4(dataflow_2);

    begin
       mux16_1_0: mux16_1 port map(
            c => b,
            r(0) => t(2),
            r(1) => t(3),
            r(2) => t(4),
            r(3) => t(5),
            w => u);
        
        demux1_4_0: demux1_4 port map(
            a => u,
            s(0) => t(0),
            s(1) => t(1),
            y => z);

end structural;
