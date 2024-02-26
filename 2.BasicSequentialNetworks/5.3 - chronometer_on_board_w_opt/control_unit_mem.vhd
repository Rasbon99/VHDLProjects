
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity control_unit_mem is
    Generic(N : integer := 4);
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;    
            btn_stop : in STD_LOGIC;
            --address : in STD_LOGIC_VECTOR (integer(ceil(log2(real(N)))) - 1 downto 0);
            display_value: in STD_LOGIC_VECTOR (31 downto 0);
            count_enable : out STD_LOGIC;
            count_reset : out STD_LOGIC;
            chrono_enable : out STD_LOGIC;
            ff_enable : out STD_LOGIC;
            mem_write : out STD_LOGIC;
            mem_data_in: out STD_LOGIC_VECTOR (31 downto 0));
end control_unit_mem;

architecture Behavioral of control_unit_mem is

    type state is (idle, stop, print);
    signal next_state : state;
    signal current_state : state := idle;
    signal chrono_enable_reg : STD_LOGIC := '1';

    begin
    
        transition: process(clk)
            begin
                if(clk'event and clk = '1') then
                    if (reset = '1') then
                        current_state <= idle;
                    else
                        current_state <= next_state;
                    end if;                    
                end if;
        end process;
        
        FSM: process(current_state, btn_stop)
            begin
            
                count_enable <= '0';
                count_reset <= '0';
                chrono_enable <= '0';
                ff_enable <= '0';
                mem_write <= '0';
                mem_data_in <= (others => '0');
                
                case current_state is
                
                    when idle =>
                        if (btn_stop = '1') then
                            next_state <= stop;
                        else
                            next_state <= idle;
                        end if;
                        
                    when stop =>
                        ff_enable <= '1';
                        mem_data_in <= display_value;
                        mem_write <= '1';
                        next_state <= print;
                        
                    when print =>
                        if (btn_stop = '1') then
                            count_enable <= '1';
                            chrono_enable <= '1';
                            ff_enable <= '1';
                            next_state <= idle;
                        else
                            next_state <= print;
                        end if;     
                                                                
                end case;
        end process;
    

end Behavioral;
