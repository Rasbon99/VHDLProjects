library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sys_a_b_tb is
end sys_a_b_tb;

architecture Behavioral of sys_a_b_tb is 

   component sys_a_b
      Port( start : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk : in STD_LOGIC);
   end component;

   signal start : STD_LOGIC := '0';
   signal reset : STD_LOGIC := '0';
   signal clk : STD_LOGIC := '0';

   constant clk_period : time := 10 ns;

    begin
    
       uut: sys_a_b port map (
          start => start,
          reset => reset,
          clk => clk
        );
    
    
       clk_process :process
       begin
          clk <= '0';
          wait for clk_period/2;
          clk <= '1';
          wait for clk_period/2;
       end process;
    
       stim_proc: process
       begin        
    
          reset <= '1';
          wait for 160 ns;  
          reset <= '0'; 
          
          wait for clk_period;
          
          start <= '1';
          
          wait for clk_period;
          
          start <= '0';
    
          wait;
          
       end process;
    
    end Behavioral;
