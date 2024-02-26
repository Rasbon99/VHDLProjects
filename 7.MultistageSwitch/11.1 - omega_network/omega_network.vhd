
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;

entity omega_network is
    Port(   input_0 : in STD_LOGIC_VECTOR(1 downto 0);
            input_1 : in STD_LOGIC_VECTOR(1 downto 0);
            input_2 : in STD_LOGIC_VECTOR(1 downto 0);
            input_3 : in STD_LOGIC_VECTOR(1 downto 0);
            src_address: in STD_LOGIC_VECTOR(1 downto 0);
            dst_address : in STD_LOGIC_VECTOR(1 downto 0);
            output_0 : out STD_LOGIC_VECTOR(1 downto 0);
            output_1 : out STD_LOGIC_VECTOR(1 downto 0);
            output_2 : out STD_LOGIC_VECTOR(1 downto 0);
            output_3 : out STD_LOGIC_VECTOR(1 downto 0));
end omega_network;

architecture Behavioral of omega_network is
    
    type wire_array is array (3 downto 0) of STD_LOGIC_VECTOR (1 downto 0);
    signal wire : wire_array;
    
    component switch is
        Generic(N: integer := 2);
        Port(   x1, x2: in STD_LOGIC_VECTOR(N-1 downto 0);
                y1, y2: out STD_LOGIC_VECTOR(N-1 downto 0);
                src : in STD_LOGIC;
                dst : in STD_LOGIC);
    end component;

    begin
    
        SWITCH_0: switch port map(
            x1 => input_0,
            x2 => input_2,
            src => src_address(1),
            dst => dst_address(1),
            y1 => wire(0),
            y2 => wire(2));
            
        SWITCH_1: switch port map(
            x1 => input_1,
            x2 => input_3,
            src => src_address(1),
            dst => dst_address(1),
            y1 => wire(1),
            y2 => wire(3));
            
         SWITCH_2: switch port map(
            x1 => wire(0),
            x2 => wire(1),
            src => src_address(0),
            dst => dst_address(0),
            y1 => output_0,
            y2 => output_1);

         SWITCH_3: switch port map(
            x1 => wire(2),
            x2 => wire(3),
            src => src_address(0),
            dst => dst_address(0),
            y1 => output_2,
            y2 => output_3);
    
        

end Behavioral;
