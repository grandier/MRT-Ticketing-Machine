library ieee;
use ieee.std_logic_1164.all;

entity Ticket_Machine_tb is
end Ticket_Machine_tb;

architecture bench of Ticket_Machine_tb is
	component Ticket_Machine is
		port(
			CLK : in std_logic;
			M, T : in std_logic_vector (1 downto 0);
			C1, C2, O : out std_logic_vector (1 downto 0)
		);
	end component;
	
	-- type state_types is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
	-- signal PS, NS : state_types;
	
	signal CLK : std_logic;
	signal M, T: std_logic_vector (1 downto 0);
	signal C1, C2, O: std_logic_vector (1 downto 0) ;
	constant CLK_PERIOD : time := 0.1 ns;
begin
	TM : Ticket_Machine port map (CLK, M, T, C1, C2, O);
	sync_proc : process
	begin
		CLK <= '0';
		wait for CLK_PERIOD;
		CLK <= '1';
		wait for CLK_PERIOD;
	end process;
	
	comb_proc : process
	begin
		T <= "01"; -- tiket 5K
		M <= "00"; -- uang 0
		wait for CLK_PERIOD;
		M <= "11"; -- uang 20K
		wait for CLK_PERIOD * 2;
		
		T <= "10"; -- tiket 10K
		M <= "01"; -- uang selain 0
		wait for CLK_PERIOD;
		T <= "10"; -- tiket 10K
		M <= "00"; -- uang  0
		wait for CLK_PERIOD;
		M <= "01"; -- uang 5K
		wait for CLK_PERIOD;
		M <= "10"; -- uang 10K
		wait for CLK_PERIOD * 2;
		
		T <= "11"; -- tiket 15K
		M <= "00"; -- uang 0
		wait for CLK_PERIOD;
		M <= "01"; -- uang 5K
		wait for CLK_PERIOD;
		M <= "11"; -- uang 20K
		wait for CLK_PERIOD * 2;
		
	end process;
end bench;