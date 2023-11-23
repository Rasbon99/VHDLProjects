----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2023 16:23:34
-- Design Name: 
-- Module Name: systemS - Behavioral
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

entity systemS is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           y : out STD_LOGIC_VECTOR (3 downto 0);
           e: in STD_LOGIC);
end systemS;

architecture structural of systemS is

    signal u : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

    component rom_comb
        Generic(width : positive := 8;
                depth : positive := 4);                          
        Port (  address : in STD_LOGIC_VECTOR (depth - 1 downto 0);
                data : out STD_LOGIC_VECTOR (width - 1 downto 0);
                enable : in STD_LOGIC);
    end component;
    
    component encoder
        Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
               z : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    begin
        rom: rom_comb port map(
            address => a,
            data => u,
            enable => e );
        
        enc: encoder port map(
            x => u,
            z => y);
            
end structural;
