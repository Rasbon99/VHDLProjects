
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Questa entità gestisce i segnali di selezione dei multiplexer dello shift register.
entity shift_manager is
    Port(   clock : in STD_LOGIC;
            load : in STD_LOGIC;
            reset : in STD_LOGIC;
            Y : in integer range 1 to 2;
            shift_enable : in STD_LOGIC;
            direction :in STD_LOGIC;
            selection : out STD_LOGIC_VECTOR (1 downto 0));
end shift_manager;

architecture Behavioral of shift_manager is

    type state is (idle, boot_load, memo, shift_sx, shift_dx);
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

-- Il segnale 'selection' è un segnale di uscita che gestisce la selezione dei multiplexer 4:1. 
-- Ogni multiplexer ha l'uscita in ingresso ai flip-flop dello shift register. Il segnale 'selection' ha quattro possibili valori:
--      - "00":  i multiplexer 4:1 danno in uscita il segnale di input allo shift register.
--      - "01":  il segnale di uscita del flip-flop successivo viene retroazionato come ingresso al flip-flop corrente.
--               Questo comportamento realizza uno shift a sinistra nello shift register.
--      - "10":  si crea la cascata dell'uscita del flip flop precedente in ingresso al flip flop corrente,
--               realizzando uno shift a destra.
--      - "11":  si realizza una memorizzazione, intesa come retroazione dell'uscita. Questo implica che 
--               il flip-flop corrente funge da ingresso per se stesso.
--      -------------------------------------------------------------------------------------------------------------------------------        
-- Il segnale 'load' ha due possibili valori:
--      - '1':  quando 'load' è '1', il sistema passa dallo stato 'idle' allo stato 'boot_load'
--              e il segnale 'selection' viene impostato a "00". Questo stato è utilizzato per caricare i dati nello shift register.
--              Se 'load' diventa '0' durante lo stato 'boot_load', il sistema passa allo stato 'memo' e 'selection' viene impostato a "11".
--              Questo stato è utilizzato per memorizzare i dati caricati. Se 'load' è '1' durante lo stato 'memo', il sistema ritorna allo stato 'idle'.
--      - '0':  quando 'load' è '0', il sistema rimane nello stato corrente.
--      -------------------------------------------------------------------------------------------------------------------------------        
-- Il segnale 'shift_enable' ha due possibili valori:
--      - '1':  quando 'shift_enable' è '1' e 'direction' è '0', il sistema passa allo stato 'shift_sx'
--              e 'selection' viene impostato a "01". Questo stato è utilizzato per spostare i dati a sinistra nello shift register.
--              Se 'shift_enable' è '1' e 'direction' è '1', il sistema passa allo stato 'shift_dx' e 'selection' viene impostato a "10".
--              Questo stato è utilizzato per spostare i dati a destra nello shift register.
--      - '0':  quando 'shift_enable' è '0', il sistema rimane nello stato corrente.


        
        FSM: process (current_state, load, shift_enable, direction)
        
            variable count : integer := 0;
        
            begin
                case current_state is 
                    
                    when idle =>
                        if (load = '1') then
                            selection <= "00";
                            next_state <= boot_load;
                        elsif (load = '0') then
                            next_state <= idle;    
                        end if;
                        
                    when boot_load =>
                        if (load = '0') then
                            selection <= "11";
                            next_state <= memo;
                        elsif (load = '1') then
                            next_state <= boot_load;
                        end if;
                    
                    when memo =>
                        if (load = '1') then
                            next_state <= idle;
                        elsif (shift_enable = '1' and direction = '0') then
                            selection <= "01";
                            count := count + 1;
                            next_state <= shift_sx;
                        elsif (shift_enable = '1' and direction = '1') then
                            selection <= "10";
                            count := count + 1;
                            next_state <= shift_dx; 
                        else
                            next_state <= memo;   
                        end if;
                        
                    when shift_sx =>
                        if (count < Y) then
                            count := count + 1;
                            next_state <= shift_sx;
                        elsif (count = Y) then
                            selection <= "11";
                            count := 0;
                            next_state <= memo;                        
                        end if;
                                                                                                           
                    when shift_dx =>
                        if (count < Y) then
                            count := count + 1;
                            next_state <= shift_dx;
                        elsif (count = Y) then
                            selection <= "11";
                            count := 0;
                            next_state <= memo;
                        end if;

                end case;                
        end process;


end Behavioral;
