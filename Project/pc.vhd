

Library ieee; 
Use ieee.std_logic_1164.all; 
 
Entity pc is  port ( 
Clk,Rst,stall : in std_logic; 
d : in std_logic_vector(15 downto 0);
 q : out std_logic_vector(15 downto 0)
);
 end pc; 

 Architecture behave of pc is 
begin 
	Process (Clk,Rst)
 	begin 
		if Rst = '1' then q <= ("0000001111111111");
 		elsif rising_edge(Clk) and stall = '0' then q <= d;
 		end if; 
	end process;
 end behave; 