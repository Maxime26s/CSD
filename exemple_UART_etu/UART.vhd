--code permettant d'envoyer/recevoir un message de avec 1b(start),8b(data),1b(stop) n'ayant pas de bit de parité

library IEEE;
use IEEE.STD_Logic_1164.ALL;

entity UART is
	Port(	clock_50:		in STD_LOGIC;
			rx:		in STD_LOGIC;
			tx:		out STD_LOGIC;
			LED_rx: 	out STD_LOGIC;
			LEDR : out std_logic_vector(8 downto 1);
			HEX0 : out std_logic_vector(7 downto 0));
	end UART;

architecture Behavioral of UART is
	signal UART_buffer: 	STD_LOGIC_VECTOR (9 DOWNTO 0) :="0000000000";
	signal output_hex : std_logic_vector(7 downto 0);
	
begin
	process(clock_50)
	
		variable counter:			integer range 0 to 50000 :=0;							
		variable counter_2:		integer range 0 to 50000 :=0;								
		variable tx_flag:			std_LOGIC :='0';									
		variable data_receiving: STD_LOGIC :='0';									
		begin
				if clock_50' event and clock_50='1' then --equivalent du VDFF (code du livre)
				
					--detection du bit start du message
					if (rx='0' and counter=0) then
							data_receiving:='1';
						elsif (counter=2604 and data_receiving='1') then
								UART_buffer(0)<=rx;
						
						elsif (counter=7812 and data_receiving='1') then
								UART_buffer(1)<=rx;
								
						elsif (counter=13020 and data_receiving='1') then
								UART_buffer(2)<=rx;
						
						elsif (counter=18228 and data_receiving='1') then
								UART_buffer(3)<=rx;
								
						elsif (counter=23436 and data_receiving='1') then
								UART_buffer(4)<=rx;
						
						elsif (counter=28644 and data_receiving='1') then
								UART_buffer(5)<=rx;
								
						elsif (counter=33852 and data_receiving='1') then
								UART_buffer(6)<=rx;
								
						elsif (counter=39060 and data_receiving='1') then
								UART_buffer(7)<=rx;
								
						elsif (counter=44268 and data_receiving='1') then
								UART_buffer(8)<=rx;
						
						elsif (rx='1' and data_receiving='1' and counter=49476) then
								counter:=0;
								data_receiving:='0';
								tx_flag:='1';
								UART_buffer(9)<=rx;
								
						end if;
						
						

					
					--incrementation du compteur d'envoie
						if(data_receiving='1') then
								counter:=counter+1;
						end if;

					--envoie du message
						if(tx_flag='1' and counter_2=0) then
								tx<=UART_buffer(0);
								
						elsif (tx_flag='1' and counter_2=5208) then
								tx<=UART_buffer(1);
								
						elsif (tx_flag='1' and counter_2=10416) then
								tx<=UART_buffer(2);
								
						elsif (tx_flag='1' and counter_2=15624) then
								tx<=UART_buffer(3);
								
						elsif (tx_flag='1' and counter_2=20832) then
								tx<=UART_buffer(4);
								
						elsif (tx_flag='1' and counter_2=26040) then
								tx<=UART_buffer(5);
								
						elsif (tx_flag='1' and counter_2=31248) then
								tx<=UART_buffer(6);
						
						elsif (tx_flag='1' and counter_2=36456) then
								tx<=UART_buffer(7);
								
						elsif (tx_flag='1' and counter_2=41664) then
								tx<=UART_buffer(8);
								
						elsif (tx_flag='1' and counter_2=46872) then
								tx<=UART_buffer(9);
								tx_flag:='0';															-- Initializes counter and flag
								counter_2:=0;	
								
						end if;
					--incrementation du compteur de reception
						if (tx_flag='1') then
						counter_2:=counter_2+1;														-- Updates counter_2
						end if;
					
				end if;
	end process;
	
	output <= UART_buffer(8 downto 1)
end Behavioral;