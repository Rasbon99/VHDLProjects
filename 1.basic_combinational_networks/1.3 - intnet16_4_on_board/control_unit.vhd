
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port ( 
       clock : in  STD_LOGIC;
       reset : in  STD_LOGIC;
       load_first_part : in  STD_LOGIC;
       load_second_part : in  STD_LOGIC;
       value8_in : in STD_LOGIC_VECTOR (7 downto 0);
       value16_out : out STD_LOGIC_VECTOR(15 downto 0);
       enable : in STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

    signal reg : STD_LOGIC_VECTOR (15 downto 0);
    
    begin
        cu : process(clock)
            begin
                if rising_edge(clock) then
                    if reset = '1' then
                        reg <= (others => '0');
                    else
                        if load_first_part = '1' then
                            reg(7 downto 0) <= value8_in;
                        elsif load_second_part = '1' then
                            reg(15 downto 8) <= value8_in;
                        elsif enable = '1' then
                            value16_out <= reg;
                        end if;
                    end if;
                end if;
        end process;

end Behavioral;
