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

entity rx_tb is
--  Port ( );
end rx_tb;

architecture Behavioral of rx_tb is

component Boud_rate_gen is
    generic (BAUD_RATE : natural;
             AXI_CLK : natural);

    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bclk : out STD_LOGIC); --baud clock out
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

begin

baud_generator: Boud_rate_gen
generic map (BAUD_RATE => 115200,
             AXI_CLK => 50)
port map(clk => clk, rst => rst, bclk => bclk);

uut: RX_control
port map (clk => clk, 
          RxD => RxD, 
          rst => rst, 
          baud_tick => bclk,
		  received => received,
          RxD_data => RxD_data
        --  count1 => (others '0'),
        --  count2 => (others '0')
        );
        
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
    wait for 200 ns;
    rst <= '0'; 
    wait;       
end process;

rx_process: process
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
