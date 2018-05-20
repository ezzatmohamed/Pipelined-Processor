	--------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forward_unit is 
	port (
		clk: in std_logic;
		id_ex_Rs,id_ex_Rd,ex_m_Rd,m_wb_Rd: in std_logic_vector(2 downto 0);
		ex_m_RW,m_wb_RW: in std_logic;
		Fa,Fb: out std_logic_vector(1 downto 0)
	);
end forward_unit;

architecture beh of forward_unit is
	begin
	process(clk)
	begin
	-- Ex Hazard
		if clk='0' and clk'event then
			
			if (ex_m_RW = '1' and ex_m_Rd = id_ex_Rs ) then Fa <= "00";
			elsif ( m_wb_RW = '1' and m_wb_Rd = id_ex_Rs ) then Fa <="01";
			else Fa <= "10";
			end if;
		
			if (ex_m_RW = '1' and ex_m_Rd = id_ex_Rd) then Fb <= "00";
			elsif (m_wb_RW = '1' and m_wb_Rd = id_ex_Rd ) then Fb <="01";
			else Fb <= "10";
			end if;
		--Fa <= "00" when (ex_m_RW = '1' and ex_m_Rd = id_ex_Rs ) else
		--      "01" when (m_wb_RW = '1' and m_wb_Rd = id_ex_Rs ) else "10";
		
		--Fb <= "00" when (ex_m_RW = '1' and ex_m_Rd = id_ex_Rd ) else
		--      "01" when (m_wb_RW = '1' and m_wb_Rd = id_ex_Rd ) else "10"; 
		end if;
	end process;
end beh;