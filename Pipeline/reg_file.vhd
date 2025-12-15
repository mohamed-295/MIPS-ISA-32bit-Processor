
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity Reg_File is

	Port (	
		clk : in STD_LOGIC;
		reset: in std_logic;
		RegWrite : in STD_LOGIC;-- from Control       
		write_reg : in STD_LOGIC_VECTOR(4 downto 0);
		write_data : in STD_LOGIC_VECTOR(31 downto 0);
		read_reg1 : in STD_LOGIC_VECTOR(4 downto 0);  
		read_reg2 : in STD_LOGIC_VECTOR(4 downto 0);  
		read_data1 : out STD_LOGIC_VECTOR(31 downto 0);
		read_data2 : out STD_LOGIC_VECTOR(31 downto 0) 
	); 
end entity;

architecture Behavioral of Reg_File is							 
 type reg_arr is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);	
	 -- initializing registers data
	signal regs : reg_arr := (
  0  => x"00000000",  -- $r0
  1  => x"00000001",  -- $r1
  2  => x"00000002",  -- $r2
  3  => x"00000003",  -- $r3
  4  => x"00000004",
  5  => x"00000005",
  6  => x"00000006",
  7  => x"00000007",
  8  => x"0000000A", -- $t0	= 10 
  9  => x"00000005", -- $t1	= 5
  10 => x"00000000", -- $t2 = 0	(base address)
  11 => x"0000000B",
  12 => x"0000000C",
  13 => x"0000000D",
  14 => x"0000000E",
  15 => x"0000000F",
  16 => x"00000010",
  17 => x"00000011",
  18 => x"00000012",
  19 => x"00000013",
  20 => x"00000014",
  21 => x"00000015",
  22 => x"00000016",
  23 => x"00000017",
  24 => x"00000018",
  25 => x"00000019",
  26 => x"0000001A",
  27 => x"0000001B",
  28 => x"0000001C",
  29 => x"0000001D",
  30 => x"0000001E",
  31 => x"0000001F",
  others => (others => '0')  -- just in case
);

begin
    
	process(clk) is 
	begin
        
	if falling_edge(clk) then
            
		if reset = '1' then
                
			regs <= (others => (others => '0'));
            
		elsif RegWrite = '1' then
                
			if write_reg /= "00000" then                      
				regs(to_integer(unsigned(write_reg))) <= write_data;
               
			end if;
           
		end if;
       
	end if;
    
	end process;		  
	read_data1 <= regs(to_integer(unsigned(read_reg1))); 
	read_data2 <= regs(to_integer(unsigned(read_reg2)));

end architecture;
