----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.10.2023 12:09:04
-- Design Name: 
-- Module Name: intnet16_4_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity intnet16_4_tb is
end intnet16_4_tb;

architecture behavioral of intnet16_4_tb is

    component intnet16_4
        Port ( b : in STD_LOGIC_VECTOR (15 downto 0);
               t : in STD_LOGIC_VECTOR (5 downto 0);
               z : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal input    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal control  : STD_LOGIC_VECTOR(5 downto 0)  := (others => '0');
    signal output  : STD_LOGIC_VECTOR (3 downto 0)  := (others => '0');

    begin
        uutintnet : intnet16_4 port map (
            b => input,
            t => control,
            z => output
        );

        stimproc: process 
            begin
                wait for 100 ns;
		
                input 	<= "0101010101010101";
                
                control <= "000000"; 
                wait for 10 ns; -- b0 = 0  in uscita
                
                control <= "000001";
                wait for 10 ns; -- b1 = 1 in uscita
                    
                control <= "000010";
                wait for 10 ns; -- b2 = 0 in uscita
                
                control <= "000011";
                wait for 10 ns; -- b3 = 1 in uscita

                control <= "000100";
                wait for 10 ns; -- b0 = 0  in uscita
                
                control <= "000101";
                wait for 10 ns; -- b1 = 1 in uscita
                    
                control <= "000110";
                wait for 10 ns; -- b2 = 0 in uscita
                
                control <= "000111";
                wait for 10 ns; -- b3 = 1 in uscita

                control <= "001000";
                wait for 10 ns; -- b0 = 0  in uscita
                
                control <= "001001";
                wait for 10 ns; -- b1 = 1 in uscita
                    
                control <= "001010";
                wait for 10 ns; -- b2 = 0 in uscita
                
                control <= "011011";
                wait for 10 ns; -- b3 = 1 in uscita
                
--                assert output = '1'
--                report "ERRORE"
--                severity failure;


    wait;
    end process;    
    
end behavioral;
