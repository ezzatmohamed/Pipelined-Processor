Library ieee; 
Use ieee.std_logic_1164.all; 
 
Entity reg_4 is  port ( 
Clk,Rst : in std_logic; 
d : in std_logic_vector(3 downto 0);
 q : out std_logic_vector(3 downto 0)
);
 end reg_4; 
 
Architecture behave of reg_4 is 
begin 
	Process (Clk,Rst)
 	begin 
		if Rst = '1' then q <= (others=>'0');
 		elsif rising_edge(Clk) then q <= d;
 		end if; 
	end process;
 end behave; 
