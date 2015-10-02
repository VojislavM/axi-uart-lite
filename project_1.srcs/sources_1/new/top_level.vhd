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
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          TX : out STD_LOGIC;
          RX : in STD_LOGIC;
          ctrl_reg : in STD_LOGIC_VECTOR (7 downto 0);
          stat_reg : out STD_LOGIC_VECTOR (7 downto 0);
          rx_fifo : out STD_LOGIC_VECTOR (7 downto 0);
          tx_fifo : in STD_LOGIC_VECTOR (7 downto 0);
          interrupt : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

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
        constant FIFO_DEPTH	: positive := 16);
    port (
        CLK		: in std_logic;
        RST		: in std_logic;
        DataIn	: in std_logic_vector(7 downto 0);
        WriteEn	: in std_logic;
        ReadEn	: in std_logic;
        DataOut	: out std_logic_vector(7 downto 0);
        Full	: out std_logic;
        Empty	: out std_logic);
end component;

component simp_reg is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
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

component RX_control is
    Port ( clk : in STD_LOGIC;
           RxD : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_tick: in STD_LOGIC;
           received : out STD_LOGIC;
           RxD_data : out STD_LOGIC_VECTOR (7 downto 0);
           parity_error : out STD_LOGIC);
end component;

component Int_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_int : in STD_LOGIC;
           tx_int : in STD_LOGIC;
           enable : in STD_LOGIC;
           interrupt : out STD_LOGIC);
end component;

signal baud_tick : STD_LOGIC;
signal received : STD_LOGIC;
signal RxD_data_s : STD_LOGIC_VECTOR (7 downto 0);
signal parity_error : STD_LOGIC;
signal load : STD_LOGIC;
signal not_load : STD_LOGIC;
signal TxD_data : STD_LOGIC_VECTOR (7 downto 0);
signal transmitted : STD_LOGIC;
signal tx_out : STD_LOGIC;
signal read_fifo : STD_LOGIC;
signal WriteEn_rx : STD_LOGIC;
signal ReadEn_rx : STD_LOGIC;
signal DataOut_rx : STD_LOGIC_VECTOR (7 downto 0);
signal Full_rx : STD_LOGIC;
signal Empty_rx : STD_LOGIC;
signal transmit_data : STD_LOGIC_VECTOR (7 downto 0);
signal WriteEn_tx : STD_LOGIC;
signal ReadEn_tx : STD_LOGIC;
signal Full_tx : STD_LOGIC;
signal Empty_tx : STD_LOGIC;

signal int_enabled : STD_LOGIC;
signal frame_error : STD_LOGIC;

signal stat_reg_out : STD_LOGIC_VECTOR (7 downto 0);

signal rst_tx_fifo : STD_LOGIC;
signal rst_rx_fifo : STD_LOGIC;
signal enable_int : STD_LOGIC;
--signal sig1 : STD_LOGIC;
signal sig2 : STD_LOGIC;
signal sig3 : STD_LOGIC;
signal sig4 : STD_LOGIC;
signal sig5 : STD_LOGIC;

signal data_in_5 : STD_LOGIC;

signal interrupt_s : STD_LOGIC;

begin
rx_control_mod: RX_control
port map(clk => clk,
         RxD => RX,
         rst => rst,
         baud_tick => baud_tick,
         received => received,
         RxD_data => RxD_data_s,
         parity_error => parity_error);
         
tx_control_mod: TX_control
port map(clk => clk,
         rst => rst,
         load => not_load,
         baud_tick => baud_tick, 
         TxD_data => TxD_data,
         transmitted => transmitted,
         TxD => tx_out,
         read_fifo => read_fifo);
         
baud_generator: Boud_rate_gen
generic map (BAUD_RATE => 115200,
             AXI_CLK => 50)
port map(clk => clk,
         rst => rst,
         bclk => baud_tick);
         
rx_fifo_buf: STD_FIFO
generic map (DATA_WIDTH => 8,
			 FIFO_DEPTH => 16)
port map (CLK => clk,
          RST => rst_rx_fifo,
          DataIn => RxD_data_s,
          WriteEn => WriteEn_rx,
          ReadEn => ReadEn_rx,
          DataOut => DataOut_rx,
          Full => Full_rx,
          Empty => Empty_rx);
          
edge_detect_rx: rising_edge_detect
port map (clk => clk,
          input => received,
          output => WriteEn_rx);
          
tx_fifo_buf: STD_FIFO
generic map (DATA_WIDTH => 8,
			 FIFO_DEPTH => 16)
port map (CLK => clk,
          RST => rst_tx_fifo,
          DataIn => tx_fifo,
          WriteEn => WriteEn_tx,
          ReadEn => ReadEn_tx,
          DataOut => TxD_data,
          Full => Full_tx,
          Empty => Empty_tx);
          
edge_detect_tx: rising_edge_detect
port map (clk => clk,
          input => read_fifo,
          output => ReadEn_tx);

stat_reg_comp: simp_reg
port map(clk => clk,
         rst => rst,
         data_in(0) => Empty_rx,
         data_in(1) => Full_rx,
         data_in(2) => Empty_tx,
         data_in(3) => Full_tx,
         data_in(4) => int_enabled, 
         data_in(5) => data_in_5 ,
         data_in(6) => frame_error, --ne znam kako.
         data_in(7) => parity_error,
         data_out => stat_reg_out);  
         
ctrl_reg_comp: simp_reg
port map(clk => clk,
         rst => rst,
         data_out(0) => rst_tx_fifo,
         data_out(1) => rst_rx_fifo,
         data_out(2) => ReadEn_rx,  --dodato da se moze procitati rx fifo
         data_out(3) => WriteEn_tx,
         data_out(4) => int_enabled, --jos uvek nema
         data_out(5) => sig3,
         data_out(6) => sig4, --ne znam kako.
         data_out(7) => sig5,
         data_in=> ctrl_reg);  
         
interrupt_comp: Int_control
port map ( clk => clk,
           rst => rst,
           rx_int => Empty_rx,
           tx_int => Empty_tx,
           enable => int_enabled,
           interrupt => interrupt_s);

not_load <= (not Empty_tx);
data_in_5 <= (Full_rx and WriteEn_rx);
TX <= tx_out;
rx_fifo <= DataOut_rx;        
stat_reg <= stat_reg_out; 
interrupt <= interrupt_s; 
end Behavioral;
