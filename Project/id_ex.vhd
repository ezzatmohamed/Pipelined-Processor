library ieee;
use ieee.std_logic_1164.all;

-- Pipe 1 - IF stage to ID stage

Entity id_ex is Port (

int_id,ccr_en_in: in std_logic;
	  ccr_out : in std_logic_vector(3 downto 0 );	
	  rt_in,rti_in : in std_logic;
	  in_port_in : in std_logic_vector( 15 downto 0 );
	  in_port_en_id,out_port_en_id,load_id,shift_id : in std_logic;
	  pcplus1_id,regdata1_id,regdata2_id : in std_logic_vector ( 15 downto 0 ); 
	  AluOp_id : in std_logic_vector ( 3 downto 0 ); 
	  carry_id :  in std_logic_vector( 1 downto 0 );
	  push_id,pop_id,MR_id,MW_id,MtoR_id,AluSrc_id,RW_id,j_id,jz_id,jn_id,jc_id,store_id,call_id :  in std_logic;
	  inst_id : in std_logic_vector ( 31 downto 0 );

	
          clk,rst,branch_rst,stall,int_rst         : in std_logic;
    int_ex,     ccr_en_out : out std_logic;
ccr_out_ex : out std_logic_vector(3 downto 0 );
	  rt_out,rti_out : out std_logic;
	  in_port_out : out std_logic_vector( 15 downto 0 );
	in_port_en_ex,out_port_en_ex,load_ex,shift_ex : out std_logic;
   	  pcplus1_ex,regdata1_ex,regdata2_ex : out std_logic_vector ( 15 downto 0 );
	  AluOp_ex : out std_logic_vector ( 3 downto 0 ); 
	  carry_ex : out std_logic_vector ( 1 downto 0 );
	  push_ex,pop_ex,MR_ex,MW_ex,MtoR_ex,AluSrc_ex,RW_ex,j_ex,jz_ex,jn_ex,jc_ex,store_ex,call_ex : out std_logic;
	  inst_ex : out std_logic_vector ( 31 downto 0 )

);
    End;

Architecture behave of id_ex is
    begin
        process(clk)
        begin
		  if( rising_edge(clk) ) then
             if( (rst = '1' or branch_rst = '1' or stall = '1') ) then
		load_ex <= '0';	
		regdata1_ex<= (others=>'0');
		regdata2_ex<= (others=>'0');
                pcplus1_ex <= (others=>'0');
		carry_ex   <= (others=>'0');
	  	push_ex    <= ('0');
		pop_ex     <= ('0');
		MR_ex      <= ('0');
		MW_ex      <= ('0');
		MtoR_ex    <= ('0');
		AluSrc_ex  <= ('0');
		RW_ex      <= ('0');
		j_ex       <= ('0');
		jz_ex      <= ('0');
		jn_ex      <= ('0');
		jc_ex      <= ('0');
		store_ex   <= ('0');
		call_ex    <= ('0');
		in_port_en_ex <= '0';
		out_port_en_ex  <= '0';
		inst_ex    <= (others=>'0');
		AluOp_ex   <= (others=>'0');
		in_port_out <= (others=>'0');
           	rti_out <='0';
		rt_out <= '0';
		ccr_out_ex <= (others=>'0');
		ccr_en_out <= '0';
		int_ex <='0';
	   elsif( (int_rst = '1') ) then
		load_ex <= '0';	
		regdata1_ex<= (others=>'0');
		regdata2_ex<= (others=>'0');
                pcplus1_ex <= (others=>'0');
		carry_ex   <= (others=>'0');
	  	push_ex    <= ('0');
		pop_ex     <= ('0');
		MR_ex      <= ('0');
		MW_ex      <= ('0');
		MtoR_ex    <= ('0');
		AluSrc_ex  <= ('0');
		RW_ex      <= ('0');
		j_ex       <= ('0');
		jz_ex      <= ('0');
		jn_ex      <= ('0');
		jc_ex      <= ('0');
		store_ex   <= ('0');
		call_ex    <= ('0');
		in_port_en_ex <= '0';
		out_port_en_ex  <= '0';
		inst_ex    <= (others=>'0');
		AluOp_ex   <= (others=>'0');
		in_port_out <= (others=>'0');
           	rti_out <='0';
		rt_out <= '0';
		ccr_out_ex <= (others=>'0');
		ccr_en_out <= '0';
		int_ex <=int_id;
	    elsif( clk = '1') then
	int_ex <= int_id;
	ccr_en_out <= ccr_en_in;
		regdata1_ex<= regdata1_id;
		regdata2_ex<= regdata2_id;
                pcplus1_ex <= pcplus1_id;
		carry_ex   <= carry_id;
	  	push_ex    <= push_id;
		pop_ex     <= pop_id;
		MR_ex      <= MR_id;
		MW_ex      <= MW_id;
		MtoR_ex    <= MtoR_id;
		AluSrc_ex  <= AluSrc_id;
		RW_ex      <= RW_id;
		j_ex       <= j_id;
		jz_ex      <= jz_id;
		jn_ex      <= jn_id;
		jc_ex      <= jc_id;
		store_ex   <= store_id;
		call_ex    <= call_id;
		inst_ex    <= inst_id;
		AluOp_ex   <= AluOp_id;
		shift_ex   <= shift_id;
		load_ex    <= load_id;
		in_port_en_ex <= in_port_en_id;
		out_port_en_ex  <= out_port_en_id;
		in_port_out <= in_port_in;
		rti_out <= rti_in;
		rt_out <= rt_in;
		ccr_out_ex <= ccr_out;
            end if;
				end if;
        end process;
    end;

