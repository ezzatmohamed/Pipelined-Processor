
Library ieee; 
Use ieee.std_logic_1164.all; 
 
Entity sp_reg is  port ( 
Clk,Rst : in std_logic; 
d : in std_logic_vector(15 downto 0);
 q : out std_logic_vector(15 downto 0)
);
 end sp_reg; 
 
Architecture behave of sp_reg is 
begin 
	Process (Clk,Rst)
 	begin 
		if Rst = '1' then q <= ("0000001111111111");
 		elsif rising_edge(Clk) then q <= d;
 		end if; 
	end process;
 end behave; 