
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- DIGIT MANAGER: gestisce l'ingresso del valore
-- da stampare su display, interponendosi tra il 
-- chronometer e il display_seven segments.

entity digits_manager is
    Port ( nano_in : in integer := 0;
           sec_in : in integer := 0;
           min_in : in integer := 0;
           hour_in : in integer := 0;
           display_value : out STD_LOGIC_VECTOR (31 downto 0));
end digits_manager;

architecture Behavioral of digits_manager is

    -- Segnali utili per l'elaborazione della singole
    -- cifre dei tempi da concatenare in un unico
    -- STD_LOGIC_VECTOR da 32 bit, 4 per ogni cifra
    
    signal centsec_digit_0 : STD_LOGIC_VECTOR (3 downto 0);
    signal centsec_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
    signal sec_digit_0 : STD_LOGIC_VECTOR (3 downto 0);
    signal sec_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
    signal min_digit_0 : STD_LOGIC_VECTOR (3 downto 0);
    signal min_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
    signal hour_digit_0 : STD_LOGIC_VECTOR (3 downto 0);
    signal hour_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
    
    signal centsec : integer := 0;
    
    begin
        digit_proc: process(nano_in, sec_in, min_in, hour_in)
            begin
                centsec <= nano_in/1000000;         -- approssimazione in centesimi di secondo
                
                centsec_digit_0 <= std_logic_vector(to_unsigned(centsec / 10, 4));
                centsec_digit_1 <= std_logic_vector(to_unsigned(centsec mod 10, 4));
                
                sec_digit_0 <= std_logic_vector(to_unsigned(sec_in / 10, 4));
                sec_digit_1 <= std_logic_vector(to_unsigned(sec_in mod 10, 4));
                
                min_digit_0 <= std_logic_vector(to_unsigned(min_in / 10, 4));
                min_digit_1 <= std_logic_vector(to_unsigned(min_in mod 10, 4));
                
                hour_digit_0 <= std_logic_vector(to_unsigned(hour_in / 10, 4));
                hour_digit_1 <= std_logic_vector(to_unsigned(hour_in mod 10, 4));
                
        end process;
        
        -- Stringa di concatenazione in output
        display_value <= hour_digit_0 & hour_digit_1 & min_digit_0 & min_digit_1 & sec_digit_0 & sec_digit_1 & centsec_digit_0 & centsec_digit_1;

end Behavioral;
