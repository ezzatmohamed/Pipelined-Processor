library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is 
	port(
-- 		inputs:
	 	in_1, in_2 		: in unsigned(15 downto 0);		-- operands
		op 		: in std_logic_vector(3 downto 0);	        -- operation
		cin, clk 	: in std_logic;				        -- carry in, clock
		
-- 		outputs:
		cout, N, zero,over: out std_logic;			                -- carry, Negative, zero flags
		result 		: out std_logic_vector(15 downto 0)	    	        -- result
	);
end entity;
		
		
architecture calculation of alu is 

	signal F_i : unsigned(16 downto 0) := "00000000000000000";	
	-- internal signal for calculation
	-- is assigned to F-output and carry-flag with concurrent statement
	
	begin


over <= '0';
--	councurrent statements

	N <= F_i(15); 
	-- sign-flag is determined by bit 15 of the result -> sign bit
	
	zero <= '1' when F_i(15 downto 0) = "0000000000000000" else '0'; 
	-- only setting zero flag if result is zero, so all bits of F have to be 0
	
	result    <= std_logic_vector(F_i(15 downto 0)); 
	-- bits 15 downto 0 will be the result
	
	cout <= F_i(16); 
	-- bit 16 of F_i is the carry-flag
	
--	processes
	
	process(in_1,in_2,op) is
	begin
		
			case op is 
				-- determining operation
				-- concatenating first when using arithmetic calculations
				-- when using logical operations, the carry-flag is always 0
				

				when "0001" => 					-- Mov
					F_i <= (cin & in_1);
					
				when "0010" => 					-- ADD
					if cin = '1' then F_i <= ('0' & in_1) + ('0' & in_2) + 1;
					else              F_i <= ('0' & in_1) + ('0' & in_2);
					end if;
					
				when "0011" => 					-- SUB
					F_i <= ('0' & in_1) - ('0' & in_2);				
				when "0100" => 					-- And
					F_i <= '0' & (in_1 AND in_2);
					
				when "0101" => 					-- OR
					F_i <= '0' & (in_1 OR in_2);
				when "0110" =>
					F_i <= '0' & (in_1 sll to_integer(in_2));
				when "0111" =>
					F_i <= '0' & (in_1 srl to_integer(in_2));

				when "1000" => 					-- RLC
					F_i <=  in_2 & cin;
					
				when "1001" => 					-- RRC
					F_i <=  in_2(0) & cin & in_2(15 downto 1);
				
				when "1010" => 					-- NOT
					F_i <= '0' & ( NOT in_2);
					
				when "1011" => 					-- NEG

 					F_i    <=   ( '0' & ( not in_2 ) ) + 1  ;
					
				when "1100" => 					-- INC
					F_i <=  ( '0' & in_2 ) + 1;
					
				when "1101" => 					-- DEC
					F_i <=  ( '0' & in_2 ) - 1;
				when "0000" => 					
					F_i <=  '0' & in_2 ;
					
							
									
				-- concatenation happening after calculation because carry flag is impossible to reach
				
				when others =>
			end case;
		
	end process;

end architecture;

