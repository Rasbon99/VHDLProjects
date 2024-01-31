
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Contatore mod-Y leggermente modificato per dare in
-- uscita il segnale enable che corrisponde a:
-- un colpo di clock in caso Y = 1 o due colpi di
-- clock nel caso Y = 1. In realtè enable abilita
-- tramite clock i ff anche in fase di reset e di load
-- per consentire di azzerarli o portarli al valore di input.
-- Si azzera solo nel caso in cui si concluda il conteggio Y.

entity counter_enable is
    Port ( Y : in integer range 1 to 2;
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           load : in STD_LOGIC;
           enable : out STD_LOGIC := '0');
end counter_enable;

architecture Behavioral of counter_enable is

    signal counter_stop : integer := 0;
    
    signal temp : STD_LOGIC := '0';

    begin
        
    count_proc : process(clock)
        begin
            if (clock'event and clock = '1') then
                if (reset = '1') then
                    counter_stop <= 0;
                    temp <= '1';
                else
                    if (load = '1') then
                        temp <= '1';
                    elsif (counter_stop < Y) then
                        counter_stop <= counter_stop + 1;
                        temp <= '1';
                    else
                        temp <= '0';
                    end if;
                end if;                
            end if;
    end process;
    
    enable <= clock when temp = '1' else '0';

end Behavioral;
