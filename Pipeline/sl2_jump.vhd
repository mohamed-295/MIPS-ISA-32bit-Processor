library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;	 
use ieee.numeric_std.all;


-- used to divide a number by 4
-- through shifting the number two bits to left


entity SL2_Jump  is
	port(
		num_in: in std_logic_vector(25 downto 0);
	   	num_out: out std_logic_vector(27 downto 0)
	);
end entity;


architecture SL2_Jump_ARCH of SL2_Jump is
begin
	num_out <= num_in(25 downto 0) & "00";  -- = 28 bits
	
end architecture;	
