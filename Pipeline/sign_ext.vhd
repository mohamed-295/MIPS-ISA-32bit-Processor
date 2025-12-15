library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;	 
use ieee.numeric_std.all;


entity sign_ext is
	port(
		num_in: in std_logic_vector(15 downto 0);
	   	num_out: out std_logic_vector(31 downto 0)
	);
end entity;


architecture sign_ext_ARCH of sign_ext is
begin
	num_out <= "0000000000000000" & num_in when (num_in(15) = '0') else
           "1111111111111111" & num_in;
	
end architecture;	
