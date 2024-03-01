
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity po_pc_sys_tb is
end po_pc_sys_tb;

architecture Testbench of po_pc_sys_tb is

    component po_pc_sys is
        Generic(N : integer range 0 to 255 := 4);
        Port (  start : in STD_LOGIC;
                clock : in STD_LOGIC;
                reset : in STD_LOGIC;
                stop : out STD_LOGIC;
                data_out : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    signal start : STD_LOGIC := '0';
    signal clock : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal stop : STD_LOGIC := '0';
    signal data_out : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    
    constant N_tb : integer range 0 to 255 := 4;
    constant clock_period : time := 10 ns;

    begin
        
        PO_PC_SYSTEM : po_pc_sys generic map (N => N_tb) port map(
            start => start,
            clock => clock,
            reset => reset,
            stop => stop,
            data_out => data_out); 
    
        clock_proc: process
            begin
                clock <= not clock;
                wait for clock_period/2;
        end process;
        
        stim_proc : process
            begin
                reset <= '1';
                
                wait for 10 * clock_period;
                
                reset <= '0';
                start <= '1';
                
                wait for 2 * clock_period;
                
                start <= '0';
                
                wait for 22 * clock_period;
                
                start <= '1';
                
                wait for 2 * clock_period;
                
                start <= '0';
                
                wait;
        end process;
        


end Testbench;
