----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2023 19:32:00
-- Design Name: 
-- Module Name: intnet_on_board - Structural
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity intnet_on_board is
    Port (
        clock : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        load_first_part : in  STD_LOGIC;
        load_second_part : in  STD_LOGIC;
        value8_in : in STD_LOGIC_VECTOR (7 downto 0);
        state_switch : in STD_LOGIC_VECTOR (5 downto 0);
        led : out STD_LOGIC_VECTOR (3 downto 0);
        enable : in STD_LOGIC
    );
end intnet_on_board;

architecture Structural of intnet_on_board is

    component control_unit
        Port ( 
           clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           load_first_part : in  STD_LOGIC;
           load_second_part : in  STD_LOGIC;
           value8_in : in STD_LOGIC_VECTOR (7 downto 0);
           value16_out : out STD_LOGIC_VECTOR(15 downto 0);
           enable : in STD_LOGIC 
        );
    end component;

    signal cu_value : STD_LOGIC_VECTOR (15 downto 0);
    
    component intnet16_4
        Port ( b : in STD_LOGIC_VECTOR (15 downto 0);
               t : in STD_LOGIC_VECTOR (5 downto 0);
               z : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    begin
        
        cu : control_unit 
            port map(
                clock => clock,
                reset => reset,
                load_first_part => load_first_part,
                load_second_part => load_second_part,
                value8_in => value8_in,
                value16_out => cu_value,
                enable => enable);
            
        intnet_0 : intnet16_4
            port map(
                b => cu_value,
                t => state_switch,
                z => led
            );        

end Structural;
