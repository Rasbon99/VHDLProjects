library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity cu_b is
    Generic(N : integer := 16;
            M : integer := 8);
    Port(   clock : in STD_LOGIC;
            reset : in STD_LOGIC;
            mem_read : out STD_LOGIC;
            mem_write : out STD_LOGIC;
            mem_sum_in : out STD_LOGIC_VECTOR (M-1 downto 0);
            mem_data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
            address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N))))-1 downto 0);
            counter_enable : out STD_LOGIC;
            counter_reset : out STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR (M-1 downto 0);
            req : in STD_LOGIC;
            done : out STD_LOGIC;
            ack : out STD_LOGIC);
end cu_b;

architecture Behavioral of cu_b is
 
    type state is (idle, reset_counter, read, sum, write_sum, next_data);
    signal current_state : state := idle;
    signal next_state : state;
    
    signal sum_reg : STD_LOGIC_VECTOR (M-1 downto 0) := (others => '0');
    signal ack_temp : STD_LOGIC := '0';
    signal done_temp : STD_LOGIC := '0';
    signal mem_read_temp : STD_LOGIC := '0';

    begin
        trans_proc: process (clock)
            begin
                if (clock'event and clock = '1') then
                    if (reset = '1') then
                        current_state <= idle;
                    else
                        current_state <= next_state;
                        ack <= ack_temp;
                        done <= done_temp;
                        mem_read <= mem_read_temp;
                    end if;
                end if;
        end process;
        
        FSM: process (current_state, req)
            begin
                case current_state is
                    when idle => 
                        -- Se il nodo B riceve una richiesta, resetta il contatore e passa allo stato reset_counter
                        if(req = '1') then
                            counter_reset <= '1';
                            next_state <= reset_counter;
                        else
                            next_state <= idle;
                        end if;
        
                    when reset_counter =>
                        -- Dopo aver resettato il contatore, il nodo B inizia a leggere i dati dalla memoria
                        counter_reset <= '0';
                        mem_read_temp <= '1';
                        next_state <= read;
                        
                    when read =>
                        -- Il nodo B calcola la somma dei dati ricevuti e dei dati letti dalla memoria, poi passa allo stato sum
                        mem_read_temp <= '0';
                        ack_temp <= '1';
                        counter_enable <= '0';
                        next_state <= sum;
                    
                    when sum =>
                        -- Il nodo B scrive la somma calcolata nella memoria e passa allo stato write_sum
                        sum_reg <= std_logic_vector(unsigned(data_in) + unsigned(mem_data_in));
                        mem_write <= '1';
                        next_state <= write_sum;
                    
                    when write_sum =>
                        -- Dopo aver scritto la somma nella memoria, il nodo B passa allo stato next_data
                        mem_write <= '0';
                        ack_temp <= '0';
                        next_state <= next_data;
                        
                    when next_data =>
                        -- Se il nodo B riceve una richiesta, legge il prossimo dato dalla memoria e torna allo stato read, 
                        -- se invece ha completato il riempimento della memoria manda il segnale di done.
                        -- Si è scelto di utilizzare il segnale di done come fine della trasmissione generale
                        -- quando B riceve tutte le stringhe di bit, dopo che ha compiuto il controllo di conteggio.
                        -- Questo per considerare il caso in cui il ricevitore sia più lento rispetto al trasmettitore,
                        -- in modo che quest'ultimo non avanzi allo stato di idle prima che il ricevitore abbia concluso le
                        -- operazioni. Il controllo viene fatto solo su B in quanto le memorie hanno stessa dimensione.
                        -- La trasmissione dei byte non si può ripetere, data la traccia dell'esercizio, si è valutata superflua
                        -- in fase di progetto. In ogni caso rimuovendo il segnale di done, l'handshaking a due segnali
                        -- generalizza la possibilità di avere una nuova trasmissione, perdendo però robustezza in caso di clock diversi.
                        if (to_integer(unsigned(address))= N-1) then
                            done_temp <= '1';
                            next_state <= idle;
                        elsif (req = '1') then
                            counter_enable <= '1';
                            mem_read_temp <= '1';
                            ack_temp <= '1';
                            next_state <= read;
                        else
                            next_state <= idle;
                        end if;
                end case;
        end process;

        mem_sum_in <= sum_reg;
        
end Behavioral;
