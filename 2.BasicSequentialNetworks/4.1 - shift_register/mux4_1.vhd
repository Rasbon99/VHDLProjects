
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity mux4_1 is port(
    a_mux : in STD_LOGIC_VECTOR(3 downto 0);
    s_mux : in STD_LOGIC_VECTOR(1 downto 0);
    y_mux : out STD_LOGIC
);
end mux4_1;

-- COSTRUTTO WHEN-ELSE:
architecture dataflow of mux4_1 is
    
    begin
        y_mux <=    a_mux(0) when s_mux = "00" else
                    a_mux(1) when s_mux = "01" else
                    a_mux(2) when s_mux = "10" else
                    a_mux(3) when s_mux = "11" else
                    '-';
end dataflow;

