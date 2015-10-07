library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_STD_FIFO is
end TB_STD_FIFO;

architecture behavior of TB_STD_FIFO is 
	
	component STD_FIFO
		Generic (
			constant DATA_WIDTH  : positive := 8;
			constant FIFO_DEPTH	: positive := 16
		);
		port (
			CLK		: in STD_LOGIC;
			RST		: in STD_LOGIC;
			DataIn	: in STD_LOGIC_VECTOR(7 downto 0);
			WriteEn	: in STD_LOGIC;
			ReadEn	: in STD_LOGIC;
			DataOut	: out STD_LOGIC_VECTOR(7 downto 0);
			Full	: out STD_LOGIC;
			Empty	: out STD_LOGIC
		);
	end component;
	

	signal CLK		: STD_LOGIC := '0';
	signal RST		: STD_LOGIC := '0';
	signal DataIn	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal ReadEn	: STD_LOGIC := '0';
	signal WriteEn	: STD_LOGIC := '0';
	signal DataOut	: STD_LOGIC_VECTOR(7 downto 0);
	signal Empty	: STD_LOGIC;
	signal Full		: STD_LOGIC;
	constant CLK_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
	uut: STD_FIFO
		PORT MAP (
			CLK		=> CLK,
			RST		=> RST,
			DataIn	=> DataIn,
			WriteEn	=> WriteEn,
			ReadEn	=> ReadEn,
			DataOut	=> DataOut,
			Full	=> Full,
			Empty	=> Empty
		);
	
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
	
	-- Reset process
	rst_proc : process
	begin
	wait for CLK_period * 5;		
		RST <= '1';
		wait for CLK_period * 5;		
		RST <= '0';		
		wait;
	end process;
	
	-- Write process
	wr_proc : process
		variable counter : unsigned (7 downto 0) := (others => '0');
	begin		
		wait for CLK_period * 20;
		for i in 1 to 32 loop
			counter := counter + 1;			
			DataIn <= std_logic_vector(counter);			
			wait for CLK_period * 1;			
			WriteEn <= '1';			
			wait for CLK_period * 1;	
			WriteEn <= '0';
		end loop;
		wait for clk_period * 20;	
		for i in 1 to 32 loop
			counter := counter + 1;
			DataIn <= std_logic_vector(counter);
			wait for CLK_period * 1;
			WriteEn <= '1';
			wait for CLK_period * 1;	
			WriteEn <= '0';
		end loop;	
		wait;
	end process;
	
	-- Read process
	rd_proc : process
	begin
		wait for CLK_period * 20;
		wait for CLK_period * 40;	
		ReadEn <= '1';
		wait for CLK_period * 60;
		ReadEn <= '0';	
		wait for CLK_period * 256 * 2;	
		ReadEn <= '1';
		wait;
	end process;

end;