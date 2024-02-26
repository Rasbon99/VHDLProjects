----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2021 10:04:57
-- Design Name: 
-- Module Name: ButtonDebouncer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ButtonDebouncer is
    generic (                       
        CLK_period: integer := 10;  -- periodo del clock (della board) in nanosecondi
        btn_noise_time: integer := 10000000 -- durata stimata dell'oscillazione del bottone in nanosecondi
                                            -- il valore di default è 10 millisecondi
    );
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           CLEARED_BTN : out STD_LOGIC);
end ButtonDebouncer;

architecture Behavioral of ButtonDebouncer is

-- questo componente prende in input il segnale proveniente dal bottone e genera un 
-- segnale "ripulito" che presenta un impulso della durata di un colpo di clock per 
-- segnalare l'avvenuta pressione del bottone.
-- Il debouncer implementa un semplice automa di 4 stati:
-- si parte da NOT_PRESSED e, appena si rileva BTN=1, si va in CHK_PRESSED dove 
-- si attende un certo tempo in modo da "superare" l'oscillazione: se il bottone è ancora alto
-- si alza il segnale ripulito in output (avrà la durata di un inmpulso di clock)
-- e si va in PRESSED; anche qui quando si rileva BTN=0
-- si va in uno stato intermedio CHK_NOT_PRESSED in cui si aspetta un certo tempo per superare
-- l'oscillazione: se dopo questo tempo è ancora basso si ritorna in NOT_PRESSED

-- con questo automa se si mantiene il bottone premuto non vengono generati più impulsi in 
-- uscita 

type stato is (NOT_PRESSED, CHK_PRESSED, PRESSED, CHK_NOT_PRESSED);
signal BTN_state : stato := NOT_PRESSED;

constant max_count : integer := btn_noise_time/CLK_period; -- 10000000/10= conto 1000000 colpi di clock 

begin

deb: process (CLK)
variable count: integer := 0;

begin
   if rising_edge(CLK) then
	   
	   if( RST = '1') then
	       BTN_state <= NOT_PRESSED;
	       CLEARED_BTN <= '0';
	   else
	   	  case BTN_state is
			when NOT_PRESSED =>
			    if( BTN = '1' ) then
					BTN_state <= CHK_PRESSED;
				else 
					BTN_state <= NOT_PRESSED;
				end if;
            when CHK_PRESSED =>
                if(count = max_count -1) then
                    if(BTN = '1') then --se arrivo a count max ed è ancora alto vuol dire che non era un bounce, devo alzare CREARED_BTN
                        count:=0;
                        CLEARED_BTN <= '1';
                        BTN_state <= PRESSED;
                    else
                        count:=0;
                        BTN_state <= NOT_PRESSED;
                    end if;
                        
                else 
                    count:= count+1;
                    BTN_state <= CHK_PRESSED;
                end if;
                
            when PRESSED =>
                CLEARED_BTN<= '0'; --questo lo metto per fare in modo che il segnale sia alto per un solo impulso di clock
			     
			    if(BTN = '0') then
				    BTN_state <= CHK_NOT_PRESSED;
				else
				    BTN_state <= PRESSED;
				end if;
			
			when CHK_NOT_PRESSED =>
			    if(count = max_count -1) then
                    if(BTN = '0') then --se arrivo a count max ed è ancora basso vuol dire che non era un bounce e il botone è stato rilasciato
                        count:=0;
                        BTN_state <= NOT_PRESSED;
                    else
                        count:=0;
                        BTN_state <= PRESSED;
                    end if;
                        
                else 
                    count:= count+1;
                    BTN_state <= CHK_NOT_PRESSED;
                end if;
                
            when others => 
                BTN_state <= NOT_PRESSED;
		  end case;
    end if;  
  end if;  
end process;


end Behavioral;
