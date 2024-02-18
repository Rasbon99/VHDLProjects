
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chronometer_tb is
end chronometer_tb;

architecture Testbench of chronometer_tb is

    component chronometer is
        Port (  sec_input : in integer range 0 to 59;
                min_input : in integer range 0 to 59;
                hour_input : in integer range 0 to 23;
                load : in STD_LOGIC := '0';
                reset : in STD_LOGIC := '1';
                clk : in STD_LOGIC := '0';
                nano_output : out integer;
                sec_output : out integer range 0 to 59;
                min_output : out integer range 0 to 59;
                hour_output : out integer range 0 to 23);
    end component;
    
    signal sec_input : integer range 0 to 59 := 0;
    signal min_input : integer range 0 to 59 := 0;
    signal hour_input : integer range 0 to 23 := 0;
    signal load : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal clk : STD_LOGIC := '0';
    signal sec_output : integer range 0 to 59 := 0;
    signal min_output : integer range 0 to 59 := 0;
    signal hour_output : integer range 0 to 23 := 0;
    signal nano_output : integer := 0;
    
    constant clock_period : time := 1 ns;      -- 10 ns

    begin
    
        clock_proc : process
            begin
                clk <= not clk;
                wait for clock_period / 2;
        end process; 
        
        CM_tb: chronometer port map(
            sec_input => sec_input,
            min_input => min_input,
            hour_input => hour_input,
            load => load,
            reset => reset,
            clk => clk,
            nano_output => nano_output,
            sec_output => sec_output,
            min_output => min_output,
            hour_output => hour_output);
            
        stim_proc : process
            begin
                reset <= '1';
            
                wait for 10*clock_period;
                
                reset <= '0';
                
                wait for 2500*clock_period;
                
                load <= '1';
                sec_input <= 10;
                min_input <= 24;
                hour_input <= 10;
                
                wait for clock_period;
                
                load <= '0';
                
                wait;
                
        end process;
            
            


end Testbench;
