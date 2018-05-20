library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity control is port (

	--input
	opcode : in std_logic_vector( 4 downto 0 );
	int : in std_logic;
	--output
	AluOp : out std_logic_vector( 3 downto 0 );
	carry : out std_logic_vector( 1 downto 0 );
	rt,out_port,in_port,load,shift,push,pop,MR,MW,MtoR,AluSrc,RW,j,jz,jn,jc,store,call,rti ,ccr_en: out std_logic

);
end control;

architecture behave of control is

begin 
	
	ccr_en <= '1' when opcode = "01000" else '1' when opcode = "00001" else '1' when opcode = "00010" else '1' when opcode = "01001" else '1' when opcode = "01010" else '1' when opcode = "01011" else '1' when opcode = "01100" else '1' when opcode = "01101" else '1' when opcode = "01110" else '1' when opcode = "10000" else '1' when opcode = "10001" else '1' when opcode = "10110" else '1' when opcode = "11000" else '1' when opcode = "10111" else '1' when opcode = "11001" else '0';
	rt <= '1' when opcode = "00100" else '1' when opcode = "00011" else '0';
	rti <= '1' when opcode = "00100" else '0';
	out_port  <= '1' when opcode = "10100" else '0';
	in_port  <= '1' when opcode = "10101" else '0';
	load <= '1' when opcode = "00110" else '0';
	push <= '1' when opcode = "10010" else '1' when opcode = "11110" else '1' when int = '1' else '0' ;
	pop  <= '1' when opcode = "10011" else '1' when opcode = "00011" else '1' when opcode = "00100" else '0' ;
	MR   <= '1' when opcode = "00110" else '1' when opcode = "10011" else '1' when opcode = "00011" else '1' when opcode = "00100" else '0';
	MW   <= '1' when opcode = "00111" else '1' when int = '1' else '1' when opcode = "10010" else '1' when opcode = "11110" else '0';
	MtoR <= '1' when opcode = "00110" else '1' when opcode = "10011" else '0';
      AluSrc <= '1' when opcode = "00101" else '1' when opcode = "00110" else '1' when opcode = "00111" else '1' when opcode = "01101" else '1' when opcode = "01110" else '0';
	RW   <= '0' when opcode = "00000" else '0' when opcode = "00001" else '0' when opcode = "00010" else '0' when opcode = "00011" else '0' when opcode = "00100" else '0' when opcode = "00111" else '0' when opcode = "10010" else '0' when opcode = "10100" else '0' when opcode = "11010" else '0' when opcode = "11011" else '0' when opcode = "11100" else '0' when opcode = "11101" else '0' when opcode = "11110" else '1';
	j    <= '1' when opcode = "11101" else '0';
	jz   <= '1' when opcode = "11010" else '0';
	jn   <= '1' when opcode = "11011" else '0';
	jc   <= '1' when opcode = "11100" else '0';
       store <= '1' when opcode = "00111" else '0';
	call <= '1' when opcode = "11110" else '0'; 
	shift <= '1' when opcode = "01101" else '1' when opcode = "01110" else '0';
       AluOp <= "0001" when opcode = "01000" else "0010" when opcode = "01001" else "0011" when opcode = "01010" else "0100" when opcode = "01011" else "0101" when opcode = "01100" else "0110" when opcode = "01101" else "0111" when opcode = "01110" else "1000" when opcode = "10000" else "1001" when opcode = "10001" else "1010" when opcode = "10110" else "1011" when opcode = "10111" else "1100" when opcode = "11000" else "1101" when opcode = "11001" else "0000"; 
       carry <= "00" when opcode = "00001" else "10" when opcode = "00010" else "11";

end behave;