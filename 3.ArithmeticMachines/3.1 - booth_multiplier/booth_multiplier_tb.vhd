library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_multiplier_tb is
end booth_multiplier_tb;

architecture behavior of booth_multiplier_tb is

    constant N_tb : integer := 8; 

    -- Component Declaration for the Unit Under Test (UUT)

    component booth_multiplier_n
    Generic(N : integer := N_tb);
    Port(   x : in STD_LOGIC_VECTOR (N-1 downto 0);
            y : in STD_LOGIC_VECTOR (N-1 downto 0);
            clock: in STD_LOGIC;
            start : in STD_LOGIC;
            reset : in STD_LOGIC;
            p : out STD_LOGIC_VECTOR (2*N - 1 downto 0));
    end component;

   --Inputs
   signal x : STD_LOGIC_VECTOR (N_tb - 1 downto 0) := (others => '0');
   signal y : STD_LOGIC_VECTOR (N_tb - 1 downto 0) := (others => '0');
   signal clock : STD_LOGIC := '0';
   signal start : STD_LOGIC := '0';
   signal reset : STD_LOGIC := '0';

    --Outputs
   signal p : STD_LOGIC_VECTOR (2*N_tb - 1 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: booth_multiplier_n Generic Map (N => N_tb)Port Map (
          x => x,
          y => y,
          clock => clock,
          start => start,
          reset => reset,
          p => p
        );

	-- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
		wait for 100 ns;	

		reset <= '0';      
      -- insert stimulus here 
      wait for 10 ns;
      
      x <= "10111000"; 
      y <= "00110111";
      
      wait for 4*clock_period;
      
      start <= '1';
      
      wait for clock_period; 
      
      start <= '0';
      
      wait for 500 ns;
      
      start <= '1';
      x <= "10001011"; 
      y <= "01110011";
      
      wait for clock_period; 
      
      start <= '0';	
      
      wait;
      
   end process;

end;

