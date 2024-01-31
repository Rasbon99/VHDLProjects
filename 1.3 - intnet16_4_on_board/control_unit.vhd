----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2023 19:32:00
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    Port ( 
       clock : in  STD_LOGIC;
       reset : in  STD_LOGIC;
       load_first_part : in  STD_LOGIC;
       load_second_part : in  STD_LOGIC;
       value8_in : in STD_LOGIC_VECTOR (7 downto 0);
       value16_out : out STD_LOGIC_VECTOR(15 downto 0);
       enable : in STD_LOGIC
       
    );
end control_unit;

architecture Behavioral of control_unit is

    signal reg : STD_LOGIC_VECTOR (15 downto 0);
    
    begin
        cu : process(clock)
            begin
                if rising_edge(clock) then
                    if reset = '1' then
                        reg <= (others => '0');
                    else
                        if load_first_part = '1' then
                            reg(7 downto 0) <= value8_in;
                        elsif load_second_part = '1' then
                            reg(15 downto 8) <= value8_in;
                        elsif enable = '1' then
                            value16_out <= reg;
                        end if;
                    end if;
                end if;
        end process;

end Behavioral;
