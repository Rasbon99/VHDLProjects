library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---shift register che contiene inizialmente una stringa di 8 zeri e il moltiplicatore X
---al termine dell'operazione di moltiplicazione conterrà il risultato A+Q

entity shift_register is
	port( parallel_in: in std_logic_vector(16 downto 0); 
		  serial_in: in std_logic; 
		  clock, reset, load, shift: in std_logic;
		  parallel_out: out std_logic_vector(16 downto 0));		  
end shift_register;

architecture behavioural of shift_register is

	signal temp: std_logic_vector(16 downto 0);
	
	begin
	
	SR: process(clock)
		begin
		   if(clock'event and clock='1') then
			 if(reset='1') then 
			   temp <=(others=>'0');
			 else
			    if(load='1') then --caricamento iniziale del moltiplicatore
                          temp <= parallel_in;
                    elsif(shift='1') then 							
                          temp(15 downto 0) <= temp(16 downto 1);
                          temp(16) <= serial_in;
                    end if;
               end if; 
			
		   end if;
		end process;
	
	parallel_out <= temp;
	end behavioural;
		
			