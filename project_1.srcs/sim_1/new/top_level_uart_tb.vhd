----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2015 11:17:01 PM
-- Design Name: 
-- Module Name: top_level_uart_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level_uart_tb is
--  Port ( );
end top_level_uart_tb;

architecture Behavioral of top_level_uart_tb is

component top_level is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          TX : out STD_LOGIC;
          RX : in STD_LOGIC;
          ctrl_reg : in STD_LOGIC_VECTOR (7 downto 0);
          stat_reg : out STD_LOGIC_VECTOR (7 downto 0);
          rx_fifo : out STD_LOGIC_VECTOR (7 downto 0);
          tx_fifo : in STD_LOGIC_VECTOR (7 downto 0);
          interrupt : out STD_LOGIC);
end component;

signal tx_s, rx_s : STD_LOGIC;
signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
constant clk_period : time := 20 ns;
signal ctrl_reg_s : STD_LOGIC_VECTOR (7 downto 0);
signal stat_reg_s : STD_LOGIC_VECTOR (7 downto 0);
signal rx_fifo_s : STD_LOGIC_VECTOR (7 downto 0);
signal tx_fifo_s : STD_LOGIC_VECTOR (7 downto 0);
signal interrupt_s : STD_LOGIC;

begin

uut: top_level
port map (clk => clk,
          rst => rst,
          TX => tx_s,
          RX => tx_s,
          ctrl_reg => ctrl_reg_s,
          stat_reg => stat_reg_s,
          rx_fifo => rx_fifo_s,
          tx_fifo => tx_fifo_s,
          interrupt => interrupt_s);
          
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
    wait for clk_period * 10;
    rst <= '0'; 
    wait;       
end process;

transmitt_process: process
begin
    ctrl_reg_s(0) <= '1';  --rst_tx_fifo
    wait for clk_period * 10;
    ctrl_reg_s(0) <= '0';
    ctrl_reg_s(3) <= '1';  --write_en_tx
    tx_fifo_s <= "00000001";
    wait for clk_period;
	ctrl_reg_s(3) <= '0';
    wait for clk_period;
	ctrl_reg_s(3) <= '1';  --write_en_tx
	tx_fifo_s <= "00000101";
    wait for clk_period;
    ctrl_reg_s(3) <= '0';
    wait;
end process;

receive_process: process
begin
    wait for 200 us;
    ctrl_reg_s(2) <= '1';
    wait for clk_period;
    ctrl_reg_s(2) <= '0';
    wait for clk_period;
    ctrl_reg_s(2) <= '1';
    wait for clk_period;
    ctrl_reg_s(2) <= '0';
    wait;
end process;

end Behavioral;
