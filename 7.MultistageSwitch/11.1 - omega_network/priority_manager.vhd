
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity priority_manager is
    Port(   handler_0 : in STD_LOGIC;
            handler_1 : in STD_LOGIC;
            handler_2 : in STD_LOGIC;
            handler_3 : in STD_LOGIC;
            dst_0 : in STD_LOGIC_VECTOR (1 downto 0);
            dst_1 : in STD_LOGIC_VECTOR (1 downto 0);
            dst_2 : in STD_LOGIC_VECTOR (1 downto 0);
            dst_3 : in STD_LOGIC_VECTOR (1 downto 0);
            priority_src: out STD_LOGIC_VECTOR (1 downto 0);
            priority_dst : out STD_LOGIC_VECTOR (1 downto 0));
end priority_manager;

architecture Dataflow of priority_manager is

    signal n1: STD_LOGIC := '0';
    signal n2: STD_LOGIC := '0';
    signal n3: STD_LOGIC := '0';

    begin
    
    n1 <= (not handler_0) and handler_1;
    n2 <= (not handler_0) and (not handler_1) and handler_2;
    n3 <= (not handler_0) and (not handler_1) and (not handler_2) and handler_3;
    
    -- il nodo 0 non ha bisogno di un segnale a parte dato
    -- che nel momento in cui handler_0 è alto ha la priorità massima
    priority_dst <= dst_0 when handler_0 = '1' else
                    dst_1 when n1 = '1' else
                    dst_2 when n2 = '1' else
                    dst_3 when n3 = '1' else
                    (others => 'U');
                    
    priority_src <= "00" when handler_0 = '1' else
                    "01" when n1 = '1' else
                    "10" when n2 = '1' else
                    "11" when n3 = '1' else
                    (others => 'U');        

end Dataflow;
