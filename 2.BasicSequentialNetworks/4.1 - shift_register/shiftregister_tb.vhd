
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shiftregister_tb is
end shiftregister_tb;

architecture Testbench of shiftregister_tb is
    
    component shiftregister is
    Generic(N : integer := 4);
    Port (  data_in : in STD_LOGIC_VECTOR(N - 1 downto 0);
            EI, EO : in STD_LOGIC := '0';
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            Y : in integer range 1 to 2;
            direction : in STD_LOGIC;                          -- direction = 1 sx oppure direction = 0 dx
            load : in STD_LOGIC;
            shift_enable : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(N - 1 downto 0));
    end component;
    
    constant N_tb : integer := 4;
    signal input : STD_LOGIC_VECTOR(N_tb - 1 downto 0) := (others => 'U');
    signal output : STD_LOGIC_VECTOR(N_tb - 1 downto 0) := (others => 'U');
    signal clock : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal shift : integer range 1 to 2 := 1;
    signal dir : STD_LOGIC := 'U';
    signal load : STD_LOGIC:= '0';
    signal EI, EO : STD_LOGIC := '0';
    signal shift_enable : STD_LOGIC := '0';
    
    constant clk_period : time := 10 ns;
    
    begin
    
        clock_proc : process
            begin
                clock <= not clock;
                wait for clk_period / 2;
        end process; 
    
        SR_tb : shiftregister generic map (N => N_tb) port map(
        data_in => input,
        clk => clock,
        reset => reset,
        Y => shift,
        direction => dir,
        data_out => output,
        EI => EI,
        EO => EO,
        shift_enable => shift_enable,
        load => load);
        
        stim_proc: process
        begin
            wait for 100 ns;
        
            reset <= '1';
            
            dir <= '1';
            
            wait for 20 ns;
          
            input <= "1010";
            load <= '1';
            
            wait for 2*clk_period;
            
            reset <= '0';
            
            wait for 2*clk_period; 
            
            load <= '0';
            
            wait for 2*clk_period;
            
            shift_enable <= '1';
            
            wait for clk_period;
            
            shift_enable <= '0';
            
            wait for 4*clk_period;
            
            reset <= '1';
            
            dir <= '1';
            
            EI <= '1'; 
            
            wait for 20 ns;
          
            input <= "0111";
            load <= '1';
            
            wait for 2*clk_period;
            
            reset <= '0';
            
            wait for 2*clk_period; 
            
            load <= '0';
            
            wait for 5*clk_period;
            
            shift_enable <= '1';
            
            wait for clk_period;
            
            shift_enable <= '0';
            
            dir <= '0';
            
            wait for 5*clk_period;
            
            input <= "0101";
            load <= '1';
            
            wait for 2*clk_period;
            
            load <= '0';
            
            wait for 2*clk_period;
            
            shift_enable <= '1';
            
            wait for clk_period;
            
            shift_enable <= '0';
            
            
            wait;
              
        end process;
        
end Testbench;
