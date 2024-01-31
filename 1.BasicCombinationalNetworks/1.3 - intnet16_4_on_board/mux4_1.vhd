
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity mux4_1 is port(
    b : in STD_LOGIC_VECTOR(3 downto 0);
    t : in STD_LOGIC_VECTOR(1 downto 0);
    z : out STD_LOGIC);
end mux4_1;

-- LIVELLO DI ASTRAZIONE DATAFLOw:

-- COSTRUTTO BOOLEANO:
architecture dataflow_alternative0 of mux4_1 is

    begin 
        z <= ((b(0) AND (NOT t(1)) AND (NOT t(0))) OR (b(1) AND (NOT t(1)) AND t(0)) OR (b(2) AND t(1) AND (NOT t(0))) OR (b(3) AND t(1) AND t(0)));

end dataflow_alternative0;

-- COSTRUTTO WHEN-ELSE:
architecture dataflow_alternative1 of mux4_1 is
    
    begin
        z <= b(0) when t = "00" else
            b(1) when t = "01" else
            b(2) when t = "10" else
            b(3) when t = "11" else
            '-';

end dataflow_alternative1;

-- COSTRUTTO WITH-SELECT:
architecture dataflow_alternative2 of mux4_1 is
    
    begin
        with t select
            z <= b(0) when "00",
                b(1) when "01",
                b(2) when "10",
                b(3) when "11",
                '-' when others;

end dataflow_alternative2;


-- LIVELLO DI ASTRAZIONE BEHAVORIAL:
    
-- COSTRUTTO CASE:
architecture behavioral_alternative0 of mux4_1 is
    begin

        process (b, t)

            begin
                case t is
                    when "00" => z <= b(0);
                    when "01" => z <= b(1);
                    when "10" => z <= b(2);
                    when "11" => z <= b(3);
                    when others => z <= '-';
                end case;

        end process;

end behavioral_alternative0;

-- COSTRUTTO IF-THEN-ELSE:
architecture behavioral_alternative1 of mux4_1 is
    begin

        process (b, t)

            begin
                if (t = "00") then 
                    z <= b(0);
                elsif (t = "01") then
                    z <= b(1);
                elsif (t = "10") then
                    z <= b(2);
                elsif (t = "11") then
                    z <= b(3);
                else
                    z <= '-';
                end if;
                
        end process;

end behavioral_alternative1;
