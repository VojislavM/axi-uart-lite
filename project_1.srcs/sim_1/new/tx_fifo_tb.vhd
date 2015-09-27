----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2015 12:55:30 PM
-- Design Name: 
-- Module Name: tx_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_fifo_tb is
--  Port ( );
end tx_fifo_tb;

architecture Behavioral of tx_fifo_tb is

component Boud_rate_gen is
    generic (BAUD_RATE : natural;
             AXI_CLK : natural);

    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bclk : out STD_LOGIC); --baud clock out
end component;

component rising_edge_detect is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

component STD_FIFO is
    generic (
        constant DATA_WIDTH  : positive := 8;
        constant FIFO_DEPTH	: positive := 16
    );
    port (
        CLK		: in std_logic;
        RST		: in std_logic;
        DataIn	: in std_logic_vector(7 downto 0);
        WriteEn	: in std_logic;
        ReadEn	: in std_logic;
        DataOut	: out std_logic_vector(7 downto 0);
        Full	: out std_logic;
        Empty	: out std_logic
    );
end component;

component TX_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           load : in STD_LOGIC;
           baud_tick: STD_LOGIC;
           TxD_data : in STD_LOGIC_VECTOR (7 downto 0);
           transmitted : out STD_LOGIC;
           TxD : out STD_LOGIC;
           read_fifo : out STD_LOGIC);
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal bclk : STD_LOGIC := '0';
constant clk_period : time := 20 ns;
signal TxD : STD_LOGIC;
signal TxD_data : STD_LOGIC_VECTOR (7 downto 0);
signal load : STD_LOGIC;
signal transmitted : STD_LOGIC;
signal received : STD_LOGIC;
signal read_fifo : STD_LOGIC;
signal Empty : STD_LOGIC;
signal transmit_data : STD_LOGIC_VECTOR (7 downto 0);
signal WriteEn : STD_LOGIC := '0';
signal Full : STD_LOGIC;
signal ReadEn : STD_LOGIC;


begin

baud_generator: Boud_rate_gen
generic map (BAUD_RATE => 115200,
             AXI_CLK => 50)
port map (clk => clk, rst => rst, bclk => bclk);

edge_detect: rising_edge_detect
port map (clk => clk,
          input => read_fifo,
          output => ReadEn);
          
fifo: STD_FIFO
port map (CLK => clk,
        RST => rst,
        DataIn => transmit_data,
        WriteEn => WriteEn,
        ReadEn => ReadEn,
        DataOut => TxD_data,
        Full => Full,
        Empty => Empty);

uut: TX_control
port map (clk => clk, 
          rst => rst,
          load => (not Empty),
          baud_tick => bclk,
          TxD_data => TxD_data,
          transmitted => transmitted,
          TxD => TxD, 
          read_fifo => read_fifo);
        

clk_process: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

reset_process: process 
begin
    rst <= '1';
    wait for 100 ns;
    rst <= '0'; 
    wait;       
end process;

-- Write process
wr_proc : process
    variable counter : unsigned (7 downto 0) := (others => '0');
begin
    wait for clk_period * 20;
    transmit_data <= "00000001";
    wait for clk_period * 1;
    WriteEn <= '1';	
    wait for clk_period * 1;
    WriteEn <= '0';
    
    wait for clk_period * 20;
    transmit_data <= "00000101";
    wait for clk_period * 1;
    WriteEn <= '1';    
    wait for clk_period * 1;
    WriteEn <= '0';
    wait;
--    wait for CLK_period * 20;
--    for i in 1 to 32 loop
--        counter := counter + 1;
--        DataIn <= std_logic_vector(counter);
--        wait for CLK_period * 1; 
--        WriteEn <= '1';       
--        wait for CLK_period * 1;  
--        WriteEn <= '0';
--    end loop;  
--    wait;
end process;

--tx_process: process
--begin
--    TxD_data <= "01010101";
--    load <= '0';
--    wait for 250 ns;
--    load <= '1';
--    wait for 30 ns;
--    load <= '0';    
--    wait;
--end process;

end Behavioral;
