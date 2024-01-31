library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ric_seq_tb is
end ric_seq_tb;

architecture Behavioral of ric_seq_tb is

    component ric_seq
    Port ( i : in STD_LOGIC;
           A : in STD_LOGIC;
           M : in STD_LOGIC;
           R : in STD_LOGIC;
           Y : out STD_LOGIC);
    end component;

   -- INPUT
   signal i : std_logic := '0';
   signal A : std_logic := '0';
   signal M : std_logic := '0';
   signal R : std_logic := '0';

    -- OUTPUT
   signal Y : std_logic;

   -- PERIODO DI CLOCK
   constant A_period : time := 10 ns;

begin

    -- UUT = UNIT UNDER TEST
   uut: ric_seq Port Map (
          i => i,
          A => A,
          M => M,
          R => R,
          Y => Y
        );

   -- CLOCK
   A_process :process
   begin
        A <= '0';
        wait for A_period/2;
        A <= '1';
        wait for A_period/2;
   end process;

   stim_proc: process
   begin

        wait for 50 ns;

        -- TESTING
        
        -- MODE 0: SEQUENZE NON SOVRAPPOSTE
        M <= '0'; 
        
        -- RESET
        R <= '1';                       
        wait for A_period;
        R <= '0';     
                          
        -- SEQUENZA DI INPUT: 110101001110101
        i <= '1'; wait for A_period; 
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        
        -- WAIT
        wait for 5*A_period;  
        
        -- RESET
        R <= '1';                       
        wait for A_period;
        i <= '0';
        
        -- MODE 1: SEQUENZE PARZIALMENTE SOVRAPPOSTE
        M <= '1'; 
        wait for A_period;
        R <= '0';     
  
        
        -- SEQUENZA DI INPUT: 110101001110101
        i <= '1'; wait for A_period; 
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        
        -- WAIT
        wait for 5*A_period;  
        
        -- RESET
        R <= '1';                       
        wait for A_period;
        i <= '0';
        
        -- MODE 0: SEQUENZE NON SOVRAPPOSTE
        M <= '0'; 
        wait for A_period;
        R <= '0';                      
        
        -- SEQUENZA DI INPUT: 111010101110001
        i <= '1'; wait for A_period; 
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        
        -- WAIT
        wait for 5*A_period;  
        
        -- RESET
        R <= '1';                       
        wait for A_period;
        i <= '0';
        
        -- MODE 1: SEQUENZE PARZIALMENTE SOVRAPPOSTE
        M <= '1'; 
        wait for A_period;
        R <= '0';      
        
        -- SEQUENZA DI INPUT: 111010101110001
        i <= '1'; wait for A_period; 
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '1'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '0'; wait for A_period;
        i <= '1'; wait for A_period;
        
        wait;
   end process;

end Behavioral;
