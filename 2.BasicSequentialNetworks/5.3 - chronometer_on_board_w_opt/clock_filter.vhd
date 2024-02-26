
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_filter is
    generic(CLKIN_freq : integer := 100000000;   -- clock board 100MHz
			CLKOUT_freq : integer := 500);       -- frequenza desiderata 500Hz
    Port (  clock_in : in  STD_LOGIC;
            reset : in STD_LOGIC;
            clock_out : out  STD_LOGIC);         -- impulso che usato come enable dei counter
    
end clock_filter;

architecture Behavioral of clock_filter is

    signal clockfx : std_logic := '0';
    
    -- count_max_value: quanti cicli di clock di input ci sono per ogni ciclo di clock di output
    constant count_max_value : integer := CLKIN_freq/(CLKOUT_freq)-1;
    
    begin
    
    clock_out <= clockfx;
    
    count_for_division: process(clock_in)
        
        variable counter : integer range 0 to count_max_value := 0;
        
        -- semplice contatore che si interrompe al count_max_value
        begin
            if rising_edge(clock_in) then
               if( reset = '1') then
                    counter := 0;
                    clockfx <= '0'; 
               else
                if counter = count_max_value then
                    clockfx <=  '1';
                    counter := 0;
                else
                    clockfx <=  '0';
                    counter := counter + 1;
                end if;
               end if;
            end if;
    end process;
    

end Behavioral;

