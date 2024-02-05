
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity control_unit is
    Generic(N : integer range 0 to 255 := 4);
    Port (  start : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N)))) - 1 downto 0);
            reset : in STD_LOGIC;
            clock : in STD_LOGIC;
            count_reset : out STD_LOGIC;
            count_enable : out STD_LOGIC;
            rom_read : out STD_LOGIC;
            mem_write : out STD_LOGIC;
            stop : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is
    
    type state is (idle, boot, count, read, wait_m, write);
    signal current_state : state := idle;
    signal next_state : state;
    
    -- Last_cycle: segnale di flag per l'esecuzione
    -- dell'ultimo ciclo di read-wait-write dell'ultima
    -- locazione; viene attivato nella write se il conteggio
    -- (address) è arrivato a N-1. Una volta ritornato
    -- in write, se il last_cycle = 1 allora si alza stop
    -- e si torna in idle.
    
    signal last_cycle : STD_LOGIC := '0';
    
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
        
        next_state_proc: process (current_state, start)
            begin
                case current_state is
                
                    when idle =>
                        if (start = '1') then
                            stop <= '0';
                            count_reset <= '1';
                            next_state <= boot;
                        elsif (start = '0') then
                            stop <= '0';
                            count_enable <= '0';
                            next_state <= idle;
                        end if;
                        
                    when boot =>
                        count_enable <= '1';
                        count_reset <= '0';
                        next_state <= count;
                    
                    when count =>
                        rom_read <= '1';
                        count_enable <= '0';
                        next_state <= read;
                        
                    when read =>
                        rom_read <= '0';
                        mem_write <= '0';
                        next_state <= wait_m;
                    
                    -- Lo stato wait_m ritarda di un colpo di clock
                    -- la write ipotizzando che la rete combinatoria M
                    -- abbia un tale tempo di propagazione.
                     
                    when wait_m =>
                        rom_read <= '0';
                        mem_write <= '1';
                        next_state <= write;
                        
                    when write =>
                        if (last_cycle = '1') then
                            stop <= '1';
                            mem_write <= '0';
                            count_enable <= '0';
                            last_cycle <= '0';
                            next_state <= idle;
                    
                        elsif (to_integer(unsigned(address)) = N - 1) then
                            mem_write <= '0';
                            count_enable <= '1';
                            last_cycle <= '1';
                            next_state <= count;
                        else
                            mem_write <= '0';
                            count_enable <= '1';
                            last_cycle <= '0';
                            next_state <= count;
                        
                        end if;
                        
                end case;                    
        end process;


end Behavioral;
