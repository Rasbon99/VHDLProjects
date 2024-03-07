
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity digits_manager is
    Port ( digits_input : in STD_LOGIC_VECTOR (15 downto 0);
           display_value : out STD_LOGIC_VECTOR (31 downto 0));
end digits_manager;

architecture Behavioral of digits_manager is

    signal minus_digit : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal digits : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

    begin
        
        minus_digit <= "10000" when digits_input(15) = '1' else "00000";
        
        digits <= STD_LOGIC_VECTOR(abs(signed(digits_input))) when digits_input(15) = '1' else digits_input;
        
        display_value <= "00000000000" & minus_digit & digits;

end Behavioral;
