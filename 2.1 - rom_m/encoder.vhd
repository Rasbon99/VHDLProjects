----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2023 16:23:34
-- Design Name: 
-- Module Name: encoder - Behavioral
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

entity encoder is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           z : out STD_LOGIC_VECTOR (3 downto 0));
end encoder;

architecture Behavioral of encoder is
    begin    
        z <=    "1111" when x = "00000000" else
                "1110" when x = "00000001" else
                "1101" when x = "00000010" else
                "1100" when x = "00000011" else
                "1011" when x = "00000100" else
                "1010" when x = "00000101" else 
                "1001" when x = "00000110" else
                "1000" when x = "00000111" else
                "0111" when x = "00001000" else
                "0110" when x = "00001001" else
                "0101" when x = "00001010" else
                "0100" when x = "00001011" else
                "0011" when x = "00001100" else
                "0010" when x = "00001101" else
                "0001" when x = "00001110" else
                "0000" when x = "00001111" else
                "----";
end Behavioral;
