library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux16_1_tb is
end mux16_1_tb;

architecture behavioral of mux16_1_tb is

    component mux16_1 port (
        c : in STD_LOGIC_VECTOR (15 downto 0);
        r : in STD_LOGIC_VECTOR (3 downto 0);
        w : out STD_LOGIC
    );
    end component;

    signal input    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal control  : STD_LOGIC_VECTOR(3 downto 0)  := (others => '0');
    signal output  : STD_LOGIC                      := '0';

    begin
        uut : mux16_1 port map (
            c => input,
            r => control,
            w => output
        );

        stimproc: process 
            begin
                wait for 100 ns;
		
                input 	<= "1010101010101010";
                
                control <= "0000"; 
                wait for 10 ns; -- b0 = 0  in uscita
                
                control <= "0001";
                wait for 10 ns; -- b1 = 1 in uscita
                    
                control <= "0010";
                wait for 10 ns; -- b2 = 0 in uscita
                
                control <= "0011";
                wait for 10 ns; -- b3 = 1 in uscita

                control <= "0100"; 
                wait for 10 ns; -- b0 = 0  in uscita
                
                control <= "0101";
                wait for 10 ns; -- b1 = 1 in uscita
                    
                control <= "0110";
                wait for 10 ns; -- b2 = 0 in uscita
                
                control <= "0111";
                wait for 10 ns; -- b3 = 1 in uscita

                control <= "1000"; 
                wait for 10 ns; -- b0 = 0  in uscita
                
                control <= "1001";
                wait for 10 ns; -- b1 = 1 in uscita
                    
                control <= "1010";
                wait for 10 ns; -- b2 = 0 in uscita
                
                control <= "1011";
                wait for 10 ns; -- b3 = 1 in uscita

                control <= "1100"; 
                wait for 10 ns; -- b0 = 0  in uscita
                
                control <= "1101";
                wait for 10 ns; -- b1 = 1 in uscita
                    
                control <= "1110";
                wait for 10 ns; -- b2 = 0 in uscita
                
                control <= "1111";
                wait for 10 ns; -- b3 = 1 in uscita
                
                assert output = '1'
                report "ERRORE"
                severity failure;



    wait;
    end process;
    
end behavioral;
