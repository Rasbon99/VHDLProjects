
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switch is
    Generic(N: integer := 2);
    Port(   x1, x2: in STD_LOGIC_VECTOR(N-1 downto 0);
            y1, y2: out STD_LOGIC_VECTOR(N-1 downto 0);
            src : in STD_LOGIC;
            dst : in STD_LOGIC);
end switch;

architecture Behavioral of switch is

    component mux2_1 is
        Generic(N : integer := 2 ); 
        Port (  a0 : in STD_LOGIC_VECTOR (N-1 downto 0);
                a1 : in STD_LOGIC_VECTOR (N-1 downto 0);
                s : in STD_LOGIC;
                y : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component;
    
    component demux1_2 is
        Generic(N : integer := 2 ); 
        Port (  a : in STD_LOGIC_VECTOR (N-1 downto 0);
                s : in STD_LOGIC;
                y0 : out STD_LOGIC_VECTOR (N-1 downto 0);
                y1 : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component;
    
    signal switch_wire : STD_LOGIC_VECTOR (N-1 downto 0);

    begin
    
    MUX: mux2_1 port map(
        a0 => x1,
        a1 => x2,
        s => src,
        y => switch_wire);
        
    DEMUX: demux1_2 port map(
        a => switch_wire,
        s => dst,
        y0 => y1,
        y1 => y2);


end Behavioral;
