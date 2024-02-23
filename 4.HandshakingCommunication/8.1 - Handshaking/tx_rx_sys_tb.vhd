library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tx_rx_sys_tb is
end tx_rx_sys_tb;

architecture Behavioral of tx_rx_sys_tb is
    constant N: integer := 16;
    constant M: integer := 8;
    signal start, reset, clock_a, clock_b: STD_LOGIC := '0';
    component tx_rx_sys is
        Generic(N: integer := 16;
                M: integer := 8);
        Port(   start: in STD_LOGIC;
                reset: in STD_LOGIC;
                clock_a : in STD_LOGIC;
                clock_b : in STD_LOGIC);
    end component;
    
    begin
        
        UUT: tx_rx_sys generic map (N => N, M => M) port map (
            start => start, 
            reset => reset, 
            clock_a => clock_a, 
            clock_b => clock_b);
    
        stim_proc : process
        begin
            reset <= '1';
            wait for 10 ns;
            reset <= '0';
            
            wait for 10 ns;
    
            start <= '1';
            wait for 10 ns;
            start <= '0';
            
    
            wait;
        end process;
    
        clk_a_proc : process
            begin
                    wait for 5 ns;
                    clock_a <= not clock_a;
            end process;
        
        clk_b_proc : process
            begin
                    clock_b <= not clock_b;
                    wait for 5 ns;              -- Testato fino a 50 ns (T = 100 ns)
            end process;
        
end Behavioral;

