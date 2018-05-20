library ieee;
use ieee.std_logic_1164.all;

entity hazard_detection is port (

	id_ex_MR : in std_logic;
	id_ex_Rd : in std_logic_vector(2 downto 0);
	if_id_Rs : in std_logic_vector(2 downto 0);
	if_id_Rd : in std_logic_vector(2 downto 0);
	
	stall	 : out std_logic
	
);
end hazard_detection;


architecture beh of hazard_detection is	
begin

--stall <= '0';
	stall <= '1' when ( id_ex_MR = '1' and ( if_id_Rs = id_ex_Rd or  if_id_Rd = id_ex_Rd  ) ) else '0';
--	if id_ex_MR = '1' then
--		if if_id_Rs = id_ex_Rd or  if_id_Rd = id_ex_Rd then
--			stall <= '1';
		
end beh;