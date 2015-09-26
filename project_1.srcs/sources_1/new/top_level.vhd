----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2015 10:51:42 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port ( clk, clk100mhz : in STD_LOGIC;
           reset1, data_ready : in STD_LOGIC;
           RXD : in STD_LOGIC;
           TXD, transmitted, received : out STD_LOGIC;
           data_in, data_out : STD_LOGIC_VECTOR(7 downto 0); 
           sel : in STD_LOGIC_VECTOR(1 downto 0));
end top_level;

architecture Behavioral of top_level is

component RX_control
Port ( clk : in STD_LOGIC;
        RxD : in STD_LOGIC;
        rst : in STD_LOGIC;
        baud_tick: in STD_LOGIC;
        received : out STD_LOGIC;
        RxD_data : out STD_LOGIC_VECTOR (7 downto 0);
        count1 : out STD_LOGIC_VECTOR(3 downto 0);
        count2 : out STD_LOGIC_VECTOR(2 downto 0));
end component;

component Baud_rate_gen
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       sel : in STD_LOGIC_VECTOR(1 downto 0);
       counter : out STD_LOGIC_VECTOR(7 downto 0) := "00000000"; 
       bclk : out STD_LOGIC); --baud clock out
end component;

component TX_control
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

signal b : STD_LOGIC;
signal clkk : STD_LOGIC_VECTOR(7 downto 0);
signal clk : STD_LOGIC := '0';
signal tx : STD_LOGIC;
signal counter1 : STD_LOGIC_VECTOR(3 downto 0); 
signal counter2 : STD_LOGIC_VECTOR(2 downto 0);
signal counter3 : STD_LOGIC_VECTOR(3 downto 0);
signal counter4 : STD_LOGIC_VECTOR(2 downto 0);

signal data_out1 : STD_LOGIC_VECTOR(7 downto 0);

begin



end Behavioral;
