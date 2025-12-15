library ieee;
use ieee.std_logic_1164.all;

entity tb_Pipeline is  
end entity tb_Pipeline;

architecture sim of tb_Pipeline is
  signal clk    : std_logic :='0';
  signal reset  : std_logic :='1';
  constant clk_period : time := 10 ns;
  
  component Pipeline is  
    port (
      clk   : in std_logic;
      reset : in std_logic
    );
  end component;
  
begin

  UUT: Pipeline  
    port map (
      clk   => clk,
      reset => reset
    );
  
  clock_process : process
  begin
    while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
  end process;    
  
  reset_process : process
  begin
     reset <= '1';
     wait for 50 ns;
     reset <= '0';
     wait;
  end process;

end sim;