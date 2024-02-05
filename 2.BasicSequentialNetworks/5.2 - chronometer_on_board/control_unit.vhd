
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Questa unità di controllo gestisce il segnale
-- di load dell'input, andando a scandire una routine
-- di ingressi da switch abilitati da bottoni.

entity control_unit_input is
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            btn_input, btn_load: in STD_LOGIC;
            switch : in STD_LOGIC_VECTOR (5 downto 0);
            check_sec, check_min, check_hour : out STD_LOGIC;       -- segnali di accenzione dei led per l'avvenuto salvataggio dell'input
            data_sec : out integer range 0 to 59 := 0;
            data_min : out integer range 0 to 59 := 0;
            data_hour : out integer range 0 to 23 := 0;
            load : out STD_LOGIC := '0');
end control_unit_input;

architecture Behavioral of control_unit_input is
    type state_type is (SEC, MIN, HOUR);
    signal state : state_type := SEC;
    signal sec_reg : integer := 0;
    signal min_reg : integer := 0;
    signal hour_reg : integer := 0;
    signal load_wire : STD_LOGIC := '0';
    
    -- load_proc gestisce i segnali di input dal bottone,
    -- presi in successione sec, min, hour * load. 
    -- Se btn_input è '1', il valore dello switch viene 
    -- salvato nel registro corrispondente allo stato 
    -- (sec_reg, min_reg, hour_reg) e lo stato avanza.
    -- Se btn_load è '1', i segnali di controllo vengono 
    -- azzerati e load_wire diventa '1'. Altrimenti, load_wire è '0'.
    -- I valori dei registri vengono assegnati alle uscite (data_sec, 
    -- data_min, data_hour) solo quando load_wire è '1'.


    begin
        load_proc: process(clk)
        begin
            if (clk'event and clk = '1') then
                if (reset = '1') then
                    check_sec <= '0';
                    check_min <= '0';
                    check_hour <= '0';
                    sec_reg <= 0;
                    min_reg <= 0;
                    hour_reg <= 0;
                    state <= SEC;
                else
                    case state is
                        when SEC =>
                            if (btn_input = '1') then
                                check_sec <= '1';
                                sec_reg <= to_integer(unsigned(switch));
                                state <= MIN;
                            end if;
                        when MIN =>
                            if (btn_input = '1') then
                                check_min <= '1';
                                min_reg <= to_integer(unsigned(switch));
                                state <= HOUR;
                            end if;
                        when HOUR =>
                            if (btn_input = '1') then
                                check_hour <= '1';
                                hour_reg <= to_integer(unsigned(switch));
                                state <= SEC;
                            end if;
                    end case;
                    
                    if (btn_load = '1') then
                        check_sec <= '0';
                        check_min <= '0';
                        check_hour <= '0';
                        load_wire <= '1';
                    else
                        load_wire <= '0';
                    end if;
                end if;
            end if;
        end process;

    data_sec <= sec_reg when load_wire = '1';
    data_min <= min_reg when load_wire = '1';
    data_hour <= hour_reg when load_wire = '1';

    load <= load_wire;

end Behavioral;
