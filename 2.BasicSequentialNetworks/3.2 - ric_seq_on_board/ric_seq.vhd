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
    signal mode : STD_LOGIC := '0';
begin
    
    FSM: process (A)
        begin
            if( A'event and A = '1' ) then
                if( R = '1') then
                
                    if (M = '0') then
                        mode <= '0';
                    elsif (M = '1') then
                        mode <= '1';
                    end if;
                    stato_corrente <= S0;
                else
                    if mode = '0' then
                        case stato_corrente is
                            when S0 => 
                                if (i = '1' and E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S1;               
                                elsif (E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S3;
                                end if;
                
                            when S1 => 
                                if (i = '0' and E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S4;              
                                elsif (E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S2; 
                                end if;
                                
                            when S2 =>
                                if (E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S0;
                                end if;    
                
                            when S3 => 
                                if (E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S2;
                                end if;     
                
                            when S4 => 
                                if (i = '1' and E = '1') then 
                                    stato_corrente <= S0;                                        
                                    Y <= '1';               
                                elsif (E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S0;            
                                end if;
                                
                        end case;
                        
                    elsif (mode = '1') then
                        -- MODE 1 SEQUENZE PARZIALMENTE SOVRAPPOSTE
                            -- S0 - S1 - S2
                        case stato_corrente is
                            when S0 => 
                                if (i = '1' and E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S1;                   
                                elsif (E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S0;           
                                end if;
                
                            when S1 => 
                                if (i = '1' and E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S1;          
                                elsif (E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S2;                     
                                end if;
                                
                            when S2 =>  
                                if (i = '1' and E = '1') then
                                    stato_corrente <= S0;                           
                                    Y <= '1';               
                                elsif( E = '1') then
                                    Y <= '0';
                                    stato_corrente <= S0;                
                                end if;
                             
                             when others =>
                                Y <= '0';
                                stato_corrente <= S0;
                        end case;
                    end if;
                end if;
            end if;
        end process;
        
end Behavioral;