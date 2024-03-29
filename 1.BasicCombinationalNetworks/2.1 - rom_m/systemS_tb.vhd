
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity systemS_tb is
end systemS_tb;

architecture Behavioral of systemS_tb is

    component systemS is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           y : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    signal input : STD_LOGIC_VECTOR(3 downto 0) := (others => 'U');
    signal output : STD_LOGIC_VECTOR(3 downto 0) := (others => 'U');

    begin
        system: systemS port map(
            a => input,
            y => output);
        
        stimproc: process
            begin
                wait for 100 ns;
                
                input <= "0000";  
                wait for 10 ns;
                
                input <= "0001";
                wait for 10 ns;
                
                input <= "0010";
                wait for 10 ns;
                
                input <= "0011";
                wait for 10 ns;
                
                input <= "0100";
                wait for 10 ns;
                
                input <= "0101";
                wait for 10 ns;
                
                input <= "0110";
                wait for 10 ns;
                
                input <= "0111";
                wait for 10 ns;
                
                input <= "1000";
                wait for 10 ns;
                
                input <= "1001";
                wait for 10 ns;
                
                input <= "1010";
                wait for 10 ns;
                
                input <= "1011";
                wait for 10 ns;
                
                input <= "1100";
                wait for 10 ns;
                
                input <= "1101";
                wait for 10 ns;
                
                input <= "1110";
                wait for 10 ns;
                
                input <= "1111";
                wait for 10 ns;
                
                wait;
        end process;

end;
