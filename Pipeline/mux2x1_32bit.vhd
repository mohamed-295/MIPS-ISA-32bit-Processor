library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;	 
use ieee.numeric_std.all;


entity MUX2x1_32bit is
	port(
		A,B: in std_logic_vector(31 downto 0);
		sel: in std_logic;
		num_out: out std_logic_vector(31 downto 0)
	);
end entity;


architecture MUX2x1_32bit_ARCH of MUX2x1_32bit is
begin
	num_out <= A when sel = '0' else B;
end architecture;
