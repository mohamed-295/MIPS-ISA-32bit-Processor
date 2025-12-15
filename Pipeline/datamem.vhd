library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
  port(
        CLK       : in std_logic;
        address   : in std_logic_vector(31 downto 0);
        MemWrite  : in std_logic;
        MemRead   : in std_logic;
        WriteData : in std_logic_vector(31 downto 0);
        ReadData  : out std_logic_vector(31 downto 0)
  );
end DataMemory;

architecture Behavioral of DataMemory is

  type mem_type is array (0 to 255) of std_logic_vector(7 downto 0);

  signal mem : mem_type := (others => (others => '0'));

begin

  process(CLK)
    variable addr : integer;
  begin
    if rising_edge(CLK) then
      if MemWrite = '1' then
        addr := to_integer(unsigned(address));
        mem(addr)     <= WriteData(31 downto 24);
        mem(addr + 1) <= WriteData(23 downto 16);
        mem(addr + 2) <= WriteData(15 downto 8);
        mem(addr + 3) <= WriteData(7 downto 0);
      end if;
    end if;
  end process;

  ReadData <= mem(to_integer(unsigned(address)))     &
              mem(to_integer(unsigned(address)) + 1) &
              mem(to_integer(unsigned(address)) + 2) &
              mem(to_integer(unsigned(address)) + 3) when MemRead = '1'
              else (others => '0');

end Behavioral;
