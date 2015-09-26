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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_tb is
--  Port ( );
end tx_tb;

architecture Behavioral of tx_tb is

component Boud_rate_gen is
    generic (BAUD_RATE : natural;
             AXI_CLK : natural);

    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bclk : out STD_LOGIC); --baud clock out
end component;

component TX_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           load : in STD_LOGIC;
           baud_tick: STD_LOGIC;
           TxD_data : in STD_LOGIC_VECTOR (7 downto 0);
           transmitted : out STD_LOGIC;
           TxD : out STD_LOGIC;
           count1 : out STD_LOGIC_VECTOR(3 downto 0);
           count2 : out STD_LOGIC_VECTOR(2 downto 0));
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal bclk : STD_LOGIC := '0';
constant clk_period : time := 20 ns;
signal TxD : STD_LOGIC;
signal TxD_data : STD_LOGIC_VECTOR (7 downto 0);
signal load : STD_LOGIC;
signal transmitted : STD_LOGIC;
signal count1 : STD_LOGIC_VECTOR(3 downto 0);
signal count2 : STD_LOGIC_VECTOR(2 downto 0);

begin

baud_generator: Boud_rate_gen
generic map (BAUD_RATE => 115200,
             AXI_CLK => 50)
port map (clk => clk, rst => rst, bclk => bclk);

uut: TX_control
port map (clk => clk, 
          TxD => TxD, 
          rst => rst,
          baud_tick => bclk,
        --  received => '0',
          transmitted => transmitted,
          load => load,
          TxD_data => TxD_data
        --  count1 => (others '0'),
        --  count2 => (others '0')
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

tx_process : process
begin
    TxD_data <= "01010101";
    load <= '0';
    wait for 250 ns;
    load <= '1';
    wait for 30 ns;
    load <= '0';    
    wait;
end process;

end Behavioral;
