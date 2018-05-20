library ieee;
use ieee.std_logic_1164.all;

-- Pipe 1 - IF stage to ID stage

Entity if_id is Port (

	  int_if : in std_logic;
	  instruction : in std_logic_vector(31 downto 0);
          pcplus1,in_port_in    : in std_logic_vector(15 downto 0);
	
          clk,rst,branch_rst,branch_rst_m,stall ,int_rst        : in std_logic;
 	  int_id : out std_logic;
          instr_out   : out std_logic_vector(31 downto 0);
          pc_out ,in_port_out    : out std_logic_vector(15 downto 0));
    End;

Architecture behave of if_id is
    begin
        process(clk,rst,branch_rst,branch_rst_m,stall)
        begin
	    if(rst = '1' or branch_rst = '1' or branch_rst_m = '1') then
		  instr_out   <= (others=>'0');
         	  pc_out      <= (others=>'0');
           	  in_port_out <= (others=>'0');
	  	  int_id <= '0';

	    elsif( clk'event and clk = '1' and stall = '0') then
                instr_out <= instruction;
                pc_out <= pcplus1;
		in_port_out <= in_port_in;
		int_id <= int_if;
            end if;
        end process;
    end;
