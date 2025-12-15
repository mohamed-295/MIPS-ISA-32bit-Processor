library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Add_ALU is
    port(
        A       : in  std_logic_vector(31 downto 0);
        B       : in  std_logic_vector(31 downto 0);
        result  : out std_logic_vector(31 downto 0)

    );
end Add_ALU;

architecture Behavioral of Add_ALU is
begin

    process(A, B)
    begin
        
            result <= std_logic_vector(unsigned(A) + unsigned(B));
        
	  
    end process;

end Behavioral;
