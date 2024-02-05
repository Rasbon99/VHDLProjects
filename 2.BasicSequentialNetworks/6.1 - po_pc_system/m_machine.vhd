
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity m_machine is
     Port ( m_input : in STD_LOGIC_VECTOR (7 downto 0);
            m_output : out STD_LOGIC_VECTOR (3 downto 0));
end m_machine;

architecture Behavioral of m_machine is

    signal left : STD_LOGIC_VECTOR (3 downto 0);
    signal right : STD_LOGIC_VECTOR (3 downto 0);
    signal sum : STD_LOGIC_VECTOR (3 downto 0);
    
    begin
    
        left <= m_input(3 downto 0);
        right <= m_input(7 downto 4);
        
        sum <= left xor right;
        
        m_output <= not sum;        

end Behavioral;
