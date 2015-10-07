----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2015 09:58:05 PM
-- Design Name: 
-- Module Name: rx_tb - Behavioral
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

entity rx_fifo_tb is
--  Port ( );
end rx_fifo_tb;

architecture Behavioral of rx_fifo_tb is

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

component RX_control is
    Port ( clk : in STD_LOGIC;
           RxD : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_tick: in STD_LOGIC;
           received : out STD_LOGIC;
           RxD_data : out STD_LOGIC_VECTOR (7 downto 0);
           parity_error : out STD_LOGIC);
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal bclk : STD_LOGIC := '0';
constant clk_period : time := 20 ns;
signal RxD : STD_LOGIC;
signal RxD_data : STD_LOGIC_VECTOR (7 downto 0);
signal received : STD_LOGIC := '0';

signal ReadEn	: std_logic := '0';
signal WriteEn	: std_logic := '0';
signal DataOut	: std_logic_vector(7 downto 0);
signal Empty	: std_logic;
signal Full	: std_logic;
	
begin

baud_generator: Boud_rate_gen
generic map (BAUD_RATE => 115200,
             AXI_CLK => 50)
port map(clk => clk, rst => rst, bclk => bclk);

edge_detect: rising_edge_detect
port map (clk => clk,
          input => received,
          output => WriteEn);

fifo: STD_FIFO
port map (CLK => clk,
          RST => rst,
          DataIn => RxD_data,
          WriteEn => WriteEn,
          ReadEn => ReadEn,
          DataOut => DataOut,
          Full => Full,
          Empty => Empty
    );
uut: RX_control
port map (clk => clk, 
          RxD => RxD, 
          rst => rst, 
          baud_tick => bclk,
		  received => received,
          RxD_data => RxD_data
        );
        
clk_process : process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

reset_process : process 
begin
    rst <= '1';
    wait for 200 ns;
    rst <= '0'; 
    wait;       
end process;

rx_process : process
begin
    RxD <= '1';
    wait for 250 ns;
    RxD <= '0';--start
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '0';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '0';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '0';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '0';
    wait for 8680 ns;
    RxD <= '0';--parity
    wait for 8680 ns;
    RxD <= '0';--stop
    wait for 8680 ns;
    
    RxD <= '0';--start
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '0';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '0';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '1';
    wait for 8680 ns;
    RxD <= '1';--parity
    wait for 8680 ns;
    RxD <= '1';--stop
    wait for 4300 ns;
    
    RxD <= '1';
    

    wait;
end process;

end Behavioral;
