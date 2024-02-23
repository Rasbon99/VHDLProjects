------------------------------------------------------------------------
--  RS232RefCom.vhd
------------------------------------------------------------------------
-- Author:  Dan Pederson
--          Copyright 2004 Digilent, Inc.
------------------------------------------------------------------------
-- Description:  	This file defines a UART which tranfers data from 
--				    serial form to parallel form and vice versa.			
------------------------------------------------------------------------
-- Revision History:
--  07/15/04 (Created) DanP
--	02/25/08 (Created) ClaudiaG: made use of the baudDivide constant
--											in the Clock Dividing Processes
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Rs232RefComp is
    Port ( 
		TXD 	: out std_logic  	:= '1';
    	RXD 	: in  std_logic;					
    	CLK 	: in  std_logic;					--Master Clock
		DBIN 	: in  std_logic_vector (7 downto 0);--Data Bus in
		DBOUT : out std_logic_vector (7 downto 0);	--Data Bus out
		RDA	: inout std_logic;						--Read Data Available(1 quando il dato è disponibile nel registro rdReg)
		TBE	: inout std_logic 	:= '1';				--Transfer Bus Empty(1 quando il dato da inviare è stato caricato nello shift register)
		RD		: in  std_logic;					--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
		WR		: in  std_logic;					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
		PE		: out std_logic;					--Parity Error Flag
		FE		: out std_logic;					--Frame Error Flag
		OE		: out std_logic;					--Overwrite Error Flag
		RST		: in  std_logic	:= '0');			--Master Reset
end Rs232RefComp;

architecture Behavioral of Rs232RefComp is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
--  Local Type Declarations
------------------------------------------------------------------------
	--Receive state machine
	type rstate is (					  
		strIdle,			--Idle state
		strEightDelay,		--Delays for 8 clock cycles
		strGetData,			--Shifts in the data bits 
		strCheckStop		--Enables error flags
	);
	--Transmit state machine
	type tstate is (
		sttIdle,			--Idle state
		sttTransfer,		--Move data into shift register
		sttShift			--Shift out data
		);

	--TBE control state machine
	type TBEstate is (
		stbeIdle,
		stbeSetTBE,
		stbeWaitLoad,
		stbeWaitWrite
		);
		

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
--- baudrate=9600 significa che trasmetto 9600 bit al secondo
--- in un secondo ci sono 50 milioni di fronti di Clock 
--- quanti fronti di clock devo aspettare per mandare un bit?
--- num_fronti_per_TX = 50 * 10^6 / 9600 = 5208 (il conteggio è usato per "generare un CLK TX")
--- lato ricevitore dovrò usare un clock 16 volte più veloce di CLK TX:
--- num_fronti_per_RX = num_fronti_per_TX/16 = 326
--- questo codice genera un clock in ricezione (rCLK) con duty cycle 50% quindi dovrà essere
--- alto per 163 fronti e basso per 163 fronti => il valore di conteggio che consente di generare
--- questo rCLK è baudDivide
--- NOTA: in questo codice il tCLK è generato a partire da rCLK






	constant baudDivide : std_logic_vector(7 downto 0) := "10100011"; 	--Baud Rate divider = 163 (set for a rate of 9600)
	signal clkDiv	:  std_logic_vector(8 downto 0)	:= "000000000";		--usato per rClk: conta il num di fronti di clk in cui 
																	    --mantenere il valore basso e il valore alto del clock di ricezione
	signal rClkDiv :  std_logic_vector(3 downto 0)	:= "0000";		    --usato per tClk: il MSB di questa stringa è usato come tClk


																	
-- --------------------- sezione TX ------------------------------------
	signal tfReg	:  std_logic_vector(7 downto 0);						--Transfer holding register
	signal tfSReg  :  std_logic_vector(10 downto 0) 	:= "11111111111";	--Transfer shift register
    signal tClk	:  std_logic;												--Transfering Clock
    
	signal tfCtr	:  std_logic_vector(3 downto 0)	:= "0000";				--contatore usato per ritardare l'inivio di bit in base alla baud rate
    signal tClkRST	:  std_logic := '0';                                    --reset per il contatore tfCtr

	signal load	:  std_logic := '0';
	signal shift	:  std_logic := '0';

-- --------------------- sezione RX ------------------------------------
																	
	signal rdReg	:  std_logic_vector(7 downto 0) := "00000000";			--Receive holding register
	signal rdSReg	:  std_logic_vector(9 downto 0) := "1111111111";		--Receive shift register
	signal rClk	:  std_logic := '0';										--Receiving Clock

	signal ctr	:  std_logic_vector(3 downto 0)	:= "0000";					--contatore usato per porsi a centro bit all'inizio e durante la ricezione dei bit
	signal ctRst	:  std_logic := '0';									--reset per il contatore ctr
	
	signal dataIncr:  std_logic := '0';										--impulso di conteggio per il contatore dataCtr (tipo enable)
	signal dataCtr :  std_logic_vector(3 downto 0)	:= "0000";				--contatore dei bit del frame letti
	signal dataRST :  std_logic := '0';										--reset per il contatore dataCtr
	
	signal rShift	:  std_logic := '0';

	
	
	
	signal par	:  std_logic;
	signal parError:  std_logic;											--Parity error bit
	signal frameError: std_logic;											--Frame error bit
	signal CE		:  std_logic;											--Clock enable per i latch che contengono i flag di errore
	

	
    

	signal strCur	:  rstate	:= strIdle; 				--Current state in the Receive state machine
	signal strNext	:  rstate;									--Next state in the Receive state machine
	
	signal sttCur  :  tstate := sttIdle;					--Current state in the Transfer state machine
	signal sttNext :  tstate;									--Next state in the Transfer state machine
	
	signal stbeCur :  TBEstate := stbeIdle;
	signal stbeNext:  TBEstate;
	
------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------

begin


	frameError <= not rdSReg(9);
	parError <= not (rdSReg(8) xor (((rdSReg(0) xor rdSReg(1)) xor (rdSReg(2) xor rdSReg(3))) xor ((rdSReg(4) xor rdSReg(5)) xor (rdSReg(6) xor rdSReg(7)))) );
	DBOUT <= rdReg; -- Buffer dentro cui carica il dato in ricezione
	tfReg <= DBIN;  -- Buffer di trasferimento
	par <=  not ( ((tfReg(0) xor tfReg(1)) xor (tfReg(2) xor tfReg(3))) xor ((tfReg(4) xor tfReg(5)) xor (tfReg(6) xor tfReg(7))) );


--  -------------generazione del clock veloce (x16) in ricezione ---------------------------
--  ----------------------------------------------------------------------------------------


--  ----- clkDiv si incrementa ad ogni colpo di CLK e fornisce un contatore mod-163

	process (CLK, clkDiv)	    						
		begin											
			if (CLK = '1' and CLK'event) then
				if (clkDiv = baudDivide) then           
					clkDiv <= "000000000";
				else
					clkDiv <= clkDiv +1;
				end if;
			end if;
	end process;
	
	
--  ----- ogni 163 colpi di CLK viene invertito il valore di rClk e quindi si genera un clock in RX

	process (CLK, clkDiv, rClk)	 					
	begin														
		if CLK = '1' and CLK'event then
			if (clkDiv = baudDivide) then
				rClk <= not rClk;
			else
				rClk <= rClk;
			end if;
		end if;
	end process;	

--  -------------generazione del clock in TX a partire da quello in RX  --------------------
--  ----------------------------------------------------------------------------------------

--  ----- per ogni fronte del clock veloce in RX viene incrementato un contatore in modo da derivare il clock in TX
	process (rClk)	  								     
		begin										    
			if (rClk = '1' and rClk'event) then
				rClkDiv <= rClkDiv +1;
			end if;
	end process;

--  ----- il contatore viene usato per generare direttamente il clock TX (ogni 8 colpi di rClk commuto tClk)
	tClk <= rClkDiv(3);	





--  -------------------------------- Controller di ricezione -------------------------------
--  ----------------------------------------------------------------------------------------

	--Receiving State Machine--
	process (rClk, RST)
		begin
			if rClk = '1' and rClk'Event then
				if RST = '1' then
					strCur <= strIdle;
				else
					strCur <= strNext;
				end if;
			end if;
		end process;
			
	--This process generates the sequence of steps needed to receive the data
	
	process (strCur, ctr, RXD, dataCtr, rdSReg, rdReg, RDA)
		begin   
			case strCur is

				when strIdle =>
				
					dataIncr <= '0';
					rShift <= '0';
					dataRst <= '0';
					CE <= '0';
					
					if RXD = '0' then
						ctRst <= '1';
						strNext <= strEightDelay;
					else
						ctRst <= '0';
						strNext <= strIdle;
					end if;
				
				when strEightDelay => 
				
					dataIncr <= '0';
					rShift <= '0';
					CE <= '0';

					if ctr(2 downto 0) = "111" then --aspetta i primi 8 colpi di rClk 
													--in modo da centrarsi nella cella dello Start bit
						ctRst <= '1';
					    dataRST <= '1';
						strNext <= strGetData;
					else
						ctRst <= '0';
						dataRST <= '0';
						strNext <= strEightDelay;
					end if;
				
				when strGetData =>	
					CE <= '0';
					dataRst <= '0';
					if ctr(3 downto 0) = "1111" then --aspetta 16 colpi di rClk  e fornisce il segnale di shift
													 --per acquisire un nuovo bit
						
						ctRst <= '1';     --fa ripartire il contatore che conta 16 colpi di clock
						dataIncr <= '1';  --fa avanzare il contatore di bit ricevuti
						rShift <= '1';		
					else
						ctRst <= '0';
						dataIncr <= '0';
						rShift <= '0';		
					end if;

					if dataCtr = "1010" then  --appena sono stati ricevuti 10 bit abilita il controllo di errore
						strNext <= strCheckStop;
					else
						strNext <= strGetData;
					end if;
				
				when strCheckStop =>
					dataIncr <= '0';
					rShift <= '0';
					dataRst <= '0';
					ctRst <= '0';

					CE <= '1';
					strNext <= strIdle;
									
			end case;
		
		end process;
		
		
--  ----- 	questo process azzera opportunamente il contatore ctr, usato sia per posizionarsi a centro bit
--          appena si riconosce lo start bit sia per campionare i successivi bit ogni 16 colpi di rClk
		
		process (rClk, ctRst)				   		--set up a counter based on rClk
		begin										--un contatore modulo 16 (con possibilità di reset)
			if rClk = '1' and rClk'Event then
				if ctRst = '1' then                 --ctRst diventa 1 la prima volta appena viene rilevato lo start bit e si passa
													--nello stato strEightDelay (ctr viene resettato e inizia a contare)
													
													--successivamente ctRst diventa 1 quando ctr conta 8 colpi di clock e quindi				
													--si entra nello stato strGetData perchè il ricevitore si è posizionato a centro bit			
													
													--infine ctRst diventa 1 quando ctr conta 16 colpi di clock perchè vuol dire che un
													--nuovo bit è stato acquisito
													
					ctr <= "0000";
				else
					ctr <= ctr +1;
				end if;
			end if;
		end process;


--  -----   questo process azzera opportunamente il contatore dataCtr, usato per contare i bit ricevuti, quando si ha dataRST=1
--          cioè quando il ricevitore si è posizionato a centro bit dopo aver ricevuto lo start e inizia a campionare i bit del frame

 	process (rClk, dataRST)					
		begin
			if (rClk = '1' and rClk'event) then
				if dataRST = '1' then       -- dataRST diventa 1 appena il ricevitore si posiziona a centro bit 
											-- dopo aver rilevato lo start bit
					dataCtr <= "0000";
				elsif dataIncr = '1' then
					dataCtr <= dataCtr +1;
				end if;
			end if;
		end process;
		



--  -----   questo process controlla i flag di errore: i flag vengono settati dopo aver ricevuto il frame, quando CE=1.
--  -----   quando la CPU legge il dato dal buffer pone RD=1 e questo farà abbassare RDA
	process (rClk, RST, RD, CE)
		begin
			if RD = '1' or RST = '1' then
				FE <= '0';
				OE <= '0';
				RDA <= '0';
				PE <= '0';
				
			elsif rClk = '1' and rClk'event then
				if CE = '1' then      
					FE <= frameError;
					OE <= RDA;   --se RDA era ancora alto vuol dire che nessuno ha ancora letto il dato e quindi si avrà overrun (quello di prima però fratm)
					RDA <= '1';	 --segnala la fine della ricezione
					PE <= parError;
					rdReg(7 downto 0) <= rdSReg (7 downto 0);
				end if;				
			end if;
		end process;

--  -----   questo process controlla lo shift register in ricezione facendolo shiftare di una posizione a destra e mettendo
--          in testa il valore seriale ricevuto su RXD
	process (rClk, rShift)
		begin
			if rClk = '1' and rClk'Event then
				if rShift = '1' then
					rdSReg <= (RXD & rdSReg(9 downto 1));
				end if;
			end if;
		end process;

	

--  -------------------------------- Controller di trasmissione ---------------------------
--  ----------------------------------------------------------------------------------------
 	--  Transfer State Machine--
	process (tClk, RST)
		begin
			if (tClk = '1' and tClk'Event) then
				if RST = '1' then
					sttCur <= sttIdle;
				else
					sttCur <= sttNext;
				end if;
			end if;
		end process;
		
	--  This process generates the sequence of steps needed transfer the data--
	process (sttCur, tfCtr, tfReg, TBE, tClk)
		begin   	   

			case sttCur is
			
				when sttIdle =>
					tClkRST <= '0';
					shift <= '0';
					load <= '0';
					
					if TBE = '1' then  --se la trasmissione del frame precedente è terminata torna in Idle
						sttNext <= sttIdle;
					else
						sttNext <= sttTransfer; --appena TBE si azzera (cioè appena WR=1) inizia a trasmettere
					end if;	

				when sttTransfer =>	
					shift <= '0';
					load <= '1';      --carica lo shift register con il dato DBIN preceduto da uno start bit e seguito da parity e stop
					tClkRST <= '1';	  --fa ripartire il contatore tfCtr che scandisce i bit da inviare 	
					sttNext <= sttShift;
					

				when sttShift =>
					shift <= '1';  
					load <= '0';
					tClkRST <= '0';
					if tfCtr = "1100" then --la trasmissione torna in Idle quando il contatore dei bit inviati è tfCtr=12
										   --in realtà i bit del frame sono 11 ma bisogna attendere almeno un ciclo di Clock
										   --con TXD alto per poter ricominciare una nuova trasmissione
				
						sttNext <= sttIdle;
					else
						sttNext <= sttShift;
					end if;
			end case;
		end process;	
		
		
--  -----   questo processo carica e shifta lo shift register in trasmissione
	process (load, shift, tClk, tfSReg)
		begin
			TXD <= tfsReg(0);
			if tClk = '1' and tClk'Event then
				if load = '1' then
					tfSReg (10 downto 0) <= ('1' & par & tfReg(7 downto 0) &'0');
				end if;
				if shift = '1' then				  
					tfSReg (10 downto 0) <= ('1' & tfSReg(10 downto 1));
				end if;
			end if;
		end process;
	

	

--  -----    process che azzera il contatore dei bit inviati quando tClkRST=1
	process (tClk, tClkRST)	 							
		begin										    
			if (tClk = '1' and tClk'event) then
				if tClkRST = '1' then
					tfCtr <= "0000";
				else
					tfCtr <= tfCtr +1;
				end if;
			end if;
		end process;
		
		
	
						 	
--  -------------------------------- Controller del segnale TBE  ---------------------------
--  ----------------------------------------------------------------------------------------
-- il segnale TBE è inizialmente alto, e diventa basso appena si avvia una nuova trasmissione
-- (quando viene dato il segnale di WRITE) per poi tornare alto quando il caricamente è stato terminato.
-- Nel codice, il segnale TBE è connesso al segnale load di caricamento dello shift register e a WR:
-- quando load e WR tornano bassi, TBE viene alzato (quindi TBE viene alzato prima che venga completato
-- l'inivio vero e proprio).
-- i segnali TBE e RDA possono essere usati come segnali di interruzione verso il dispositivo
-- (es. CPU) che usa la UART per la trasmissione e ricezione di dati

	process (CLK, RST)
		begin
			if CLK = '1' and CLK'Event then
				if RST = '1' then
					stbeCur <= stbeIdle;
				else
					stbeCur <= stbeNext;
				end if;
			end if;
		end process;

	--This process gererates the sequence of events needed to control the TBE flag--
	process (stbeCur, CLK, WR, DBIN, load)
		begin

			case stbeCur is

				when stbeIdle =>
					TBE <= '1';
					if WR = '1' then
						stbeNext <= stbeSetTBE;
					else
						stbeNext <= stbeIdle;
					end if;
				
				when stbeSetTBE =>
					TBE <= '0';
					if load = '1' then
						stbeNext <= stbeWaitLoad;
					else
						stbeNext <= stbeSetTBE;
					end if;
				
				when stbeWaitLoad =>
					if load = '0' then
						stbeNext <= stbeWaitWrite;
					else
						stbeNext <= stbeWaitLoad;
					end if;

				when stbeWaitWrite =>
					if WR = '0' then 
						stbeNext <= stbeIdle;
					else
						stbeNext <= stbeWaitWrite;
					end if;
				end case;
			end process;

			
end Behavioral;