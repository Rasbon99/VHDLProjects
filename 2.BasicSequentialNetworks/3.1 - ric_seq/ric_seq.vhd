library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- RICONOSCITORE DI SEQUENZA 101
entity ric_seq is
    Port ( i : in STD_LOGIC;         -- INPUT
           R, A : in STD_LOGIC;      -- RESET E CLOCK
           M : in STD_LOGIC;         -- MODO
           E : in STD_LOGIC;         -- ENABLE
           Y : out STD_LOGIC);       -- OUTPUT
end ric_seq;

architecture Behavioral of ric_seq is
    type stato is (S0, S1, S2, S3, S4); 
    signal stato_corrente : stato := S0;
    signal stato_prossimo : stato;
begin

    transition: process(M, stato_corrente, E, i)
    begin 
        Y <= '0';
        stato_prossimo <= S0;  -- default value
        
        if E = '1' then 
        
             -- MODE 0 SEQUENZE NON SOVRAPPOSTE
                -- S0 - S1 - S2 - S3 - S4
            if M = '0' then
                case stato_corrente is
                    when S0 => 
                        if (i = '1') then 
                            stato_prossimo <= S1;               
                        else 
                            stato_prossimo <= S3;      
                        end if;
        
                    when S1 => 
                        if (i = '0') then 
                            stato_prossimo <= S4;              
                        else 
                            stato_prossimo <= S2;       
                        end if;
                        
                    when S2 =>  
                        stato_prossimo <= S0;      
        
                    when S3 => 
                        stato_prossimo <= S2;        
        
                    when S4 => 
                        if i = '1' then 
                            stato_prossimo <= S0;                                        
                            Y <= '1';               
                        else               
                            stato_prossimo <= S0;                   
                        end if;
                        
                end case;
                
            else
                -- MODE 1 SEQUENZE PARZIALMENTE SOVRAPPOSTE
                    -- S0 - S1 - S2
                case stato_corrente is
                    when S0 => 
                        if (i = '1') then 
                            stato_prossimo <= S1;                   
                        else 
                            stato_prossimo <= S0;           
                        end if;
        
                    when S1 => 
                        if (i = '1') then 
                            stato_prossimo <= S1;          
                        else 
                            stato_prossimo <= S2;                     
                        end if;
                        
                    when S2 =>  
                        if (i = '1') then
                            stato_prossimo <= S0;                           
                            Y <= '1';               
                        else  
                            stato_prossimo <= S0;                
                        end if;
                     
                     when others =>
                        stato_prossimo <= S0;
                end case;
            end if;
        end if;
    end process;
    
    clock: process (A)
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
