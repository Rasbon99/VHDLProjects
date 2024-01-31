----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2023 18:24:49
-- Design Name: 
-- Module Name: intnet16_4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity intnet16_4 is
    Port ( b : in STD_LOGIC_VECTOR (15 downto 0);
           t : in STD_LOGIC_VECTOR (5 downto 0);
           z : out STD_LOGIC_VECTOR (3 downto 0));
end intnet16_4;

architecture structural of intnet16_4 is

    signal u : STD_LOGIC := '0'; 

    component mux16_1 port(
        c : in STD_LOGIC_VECTOR (15 downto 0);
        r : in STD_LOGIC_VECTOR (3 downto 0);
        w : out STD_LOGIC
        ); end component;
        
    component demux1_4 
Port (
       a : in STD_LOGIC;
       s : in STD_LOGIC_VECTOR (1 downto 0);
       y : out STD_LOGIC_VECTOR (3 downto 0)
       );
 end component;

    begin
       mux16_1_0: mux16_1 port map(
            c => b,
            r(0) => t(2),
            r(1) => t(3),
            r(2) => t(4),
            r(3) => t(5),
            w => u 
        );
        
        demux1_4_0: demux1_4 port map(
            a => u,
            s(0) => t(0),
            s(1) => t(1),
            y => z
        );

end structural;
