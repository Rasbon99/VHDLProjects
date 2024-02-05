library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- RICONOSCITORE DI SEQUENZA 101
entity ric_seq is
    Port ( i : in STD_LOGIC;         -- INPUT
           R, A : in STD_LOGIC;      -- RESET E CLOCK
           M : in STD_LOGIC;         -- MODO
           Y : out STD_LOGIC);       -- OUTPUT
end ric_seq;

architecture Behavioral of ric_seq is
    type stato is (S0, S1, S2, S3, S4); 
    signal stato_corrente : stato := S0;
    signal stato_prossimo : stato;
    
    begin
    
    stato_uscita: process(stato_corrente, i)
    begin 
        case stato_corrente is
        
            -- MODE 0 SEQUENZE NON SOVRAPPOSTE
                -- S0 - S1 - S2 - S3 - S4
            -- MODE 1 SEQUENZE PARZIALMENTE SOVRAPPOSTE
                -- S0 - S1 - S2
            
            when S0 => 
                if (i = '1') then 
                    stato_prossimo <= S1;   
                    Y <= '0';                   -- RIMANE IN 0
                elsif (M = '0') then 
                    stato_prossimo <= S3;
                    Y <= '0';                   -- RIMANE IN 0
                else 
                    stato_prossimo <= S0;      
                    Y <= '0';                   -- RIMANE IN 0
                end if;
    
            when S1 => 
                if (M = '1' and i = '1') then 
                    stato_prossimo <= S1;    
                    Y <= '0';                   -- RIMANE IN 0
                elsif (M = '0' and i = '0') then 
                    stato_prossimo <= S4;
                    Y <= '0';                   -- RIMANE IN 0
                else 
                    stato_prossimo <= S2;     
                    Y <= '0';                   -- RIMANE IN 0
                end if;
                
            when S2 =>  
                if (M = '1' and i = '1') then
                    stato_prossimo <= S0;                           
                    Y <= '1';               -- SET M = 1
                else  
                    stato_prossimo <= S0;                                                  
                    Y <= '0';               -- RESET
                end if;
    
            when S3 => 
                stato_prossimo <= S2;                                                
                Y <= '0';                    -- RIMANE IN 0
    
            when S4 => 
                if i = '1' then 
                    stato_prossimo <= S0;                                        
                    Y <= '1';               -- SET M = 0
                else               
                    stato_prossimo <= S0;                                                 
                    Y <= '0';               -- RESET
                end if;
    
        end case;
    
    end process;
    
    mem: process (A)
    begin
        if( A'event and A = '1' ) then
            if( R = '1') then
                stato_corrente <= S0;
            else
                stato_corrente <= stato_prossimo;
            end if;
        end if;
    end process;
    
end Behavioral;
