
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


entity booth_mul_manager is
    Generic(N : integer := 8);
    Port(   clock : in STD_LOGIC;
            start : in STD_LOGIC;
            reset : in STD_LOGIC;
            count_in : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N)))) - 1 downto 0);
            q0_1 : in STD_LOGIC_VECTOR(1 downto 0);
            an_1 : in STD_LOGIC;
            read_aq : out STD_LOGIC;
            load_aq : out STD_LOGIC;
            sel_aq : out STD_LOGIC;
            load_m : out STD_LOGIC;
            sel_sum : out STD_LOGIC;
            sub : out STD_LOGIC;
            shift : out STD_LOGIC;
            reset_counter : out STD_LOGIC;
            enable_counter : out STD_LOGIC);
end booth_mul_manager;

architecture Behavioral of booth_mul_manager is

    type state is (idle, first_load, check, plus, minus, load_rca, check_sign, shift_reg, count, read_output);
    signal current_state : state := idle;
    signal next_state : state;

    begin
    
        transition_proc: process (clock)
            begin
                if (clock'event and clock = '1') then
                    if (reset = '1') then
                        current_state <= idle;
                    else
                        current_state <= next_state;
                    end if;
                end if;
        end process;
        
        FSM: process (current_state, start)
            begin
            
                read_aq <= '0';
                load_aq <= '0';
                sel_aq <= '0';
                load_m <= '0';
                sel_sum <= '0';
                sub <= '0';
                shift <= '0';
                reset_counter <= '0';
                enable_counter <= '0';
            
                case current_state is
                    when idle =>
                        if (start = '1') then
                            load_aq <= '1';
                            sel_aq <= '1';
                            load_m <= '1';
                            reset_counter <= '1';
                            next_state <= first_load;
                        else
                            next_state <= idle;
                        end if;
                        
                    when first_load =>
                        next_state <= check;
                    
                    -- Nello stato check, l'unità di controllo verifica i bit meno significativi di Q.
                    -- Se q0_1 è "01", allora il prossimo stato viene impostato a plus.
                    -- Se q0_1 è "10", allora il prossimo stato viene impostato a minus. 
                    -- Altrimenti, il prossimo stato viene impostato a load_rca.       
                    when check =>
                        if (q0_1 = "01") then
                            next_state <= plus;
                        elsif (q0_1 = "10") then
                            next_state <= minus;
                        else
                            next_state <= load_rca; -- PER Q[0:-1]= 11/00: concettualmente non loada l'RCA ma controlla solo il fill nella transizione successiva
                        end if; 
                    
                    -- Negli stati plus e minus, l'unità di controllo carica selezione del mux per la somma 
                    -- e in seguito il risultato dell'addizione o della sottrazione in AQ, e poi passa allo stato load_rca.        
                    when plus =>
                        load_aq <= '1';
                        sel_sum <= '1';
                        next_state <= load_rca;
                        
                    when minus =>
                        load_aq <= '1';
                        sub <= '1';
                        sel_sum <= '1';
                        next_state <= load_rca;
                        

                    when load_rca =>
                        if (an_1 = '0') then
                            next_state <= check_sign;
                        elsif(an_1 = '1') then
                            next_state <= check_sign;
                        end if;
                     
                     when check_sign =>
                        shift <= '1';
                        next_state <= shift_reg;
                     
                        
                     when shift_reg =>
                        next_state <= count;

                    -- Nello stato count, l'unità di controllo verifica se il contatore ha raggiunto N-1.
                    -- Se è così, allora resetta il contatore,  abilita la lettura di aq e passa allo stato read_output.
                    -- Se il contatore è minore di N, allora abilita il contatore e passa allo stato check.      
                     when count =>
                        if (to_integer(unsigned(count_in)) = N-1) then
                            reset_counter <= '1';
                            read_aq <= '1';
                            next_state <= read_output;
                        elsif (to_integer(unsigned(count_in)) < N) then
                            enable_counter <= '1';
                            next_state <= check; 
                        end if;
                        
                     when read_output =>
                        next_state <= idle;
                                         
                end case;
        end process;


end Behavioral;
