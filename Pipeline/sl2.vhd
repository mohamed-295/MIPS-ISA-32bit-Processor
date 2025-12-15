library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;	 
use ieee.numeric_std.all;


-- used to divide a number by 4
-- through shifting the number two bits to left


entity SL2 is
	port(
		num_in: in std_logic_vector(31 downto 0);
	   	num_out: out std_logic_vector(31 downto 0)
	);
end entity;


architecture SL2_ARCH of SL2 is
begin
	 num_out <= std_logic_vector(unsigned(num_in) sll 2);	
end architecture;	