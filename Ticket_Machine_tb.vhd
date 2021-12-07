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
	
	signal CLK : std_logic;
	signal M, T: std_logic_vector (1 downto 0);
	signal C1, C2, O: std_logic_vector (1 downto 0) ;
	constant CLK_PERIOD : time := 0.1 ns;
	constant CLK_LIMIT : integer := 50;
	signal i : integer := 0;
begin
	TM : Ticket_Machine port map (CLK, M, T, C1, C2, O);
	
	sync_proc : process
	begin
		CLK <= '0';
		wait for CLK_PERIOD / 2;
		CLK <= '1';
		wait for CLK_PERIOD / 2;
		if (i < CLK_LIMIT) then i <= i + 1;
		else wait;
		end if;
	end process;
	
	comb_proc : process
	begin
		-- tiket 5K , bayar 5K--
		T <= "01";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "01";
		wait for CLK_PERIOD * 2;
		
		assert ((C1 = "00") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 5K dengan pembayaran 5K" severity error;
		assert (O = "01") report "Tidak mengeluarkan tiket jika memilih tiket 5K dengan pembayaran 5K" severity error;
		wait for CLK_PERIOD;

		
		-- tiket 5K , bayar 10K--
		T <= "01";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "10";
		wait for CLK_PERIOD;
		
		assert ((C1 = "01") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 5K dengan pembayaran 10K" severity error;
		wait for CLK_PERIOD;
		assert (O = "01") report "Tidak mengeluarkan tiket jika memilih tiket 5K dengan pembayaran 10K" severity error;
		wait for CLK_PERIOD;


		-- tiket 5K , bayar 20K--
		T <= "01";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "11";
		wait for CLK_PERIOD;
		
		assert ((C1 = "10") and (C2 = "01")) report "Kembalian gagal jika memilih tiket 5K dengan pembayaran 20K" severity error;
		wait for CLK_PERIOD;
		assert (O = "01") report "Tidak mengeluarkan tiket jika memilih tiket 5K dengan pembayaran 20K" severity error;
		wait for CLK_PERIOD;


		-- tiket 10K , bayar 5K, 5K--
		T <= "10";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "01";
		wait for CLK_PERIOD;
		M <= "01";
		wait for CLK_PERIOD;
		
		assert ((C1 = "00") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 10K dengan pembayaran 5K dan 5K" severity error;
		wait for CLK_PERIOD;
		assert (O = T) report "Tidak mengeluarkan tiket jika memilih tiket 10K dengan pembayaran 5K dan 5K" severity error;
		wait for CLK_PERIOD * 2;


		-- tiket 10K , bayar 10K--
		T <= "10";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "10";
		wait for CLK_PERIOD * 2;
		
		assert ((C1 = "00") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 10K dengan pembayaran 10K" severity error;
		assert (O = T) report "Tidak mengeluarkan tiket jika memilih tiket 10K dengan pembayaran 10K" severity error;
		wait for CLK_PERIOD;


		-- tiket 10K , bayar 20K--
		T <= "10";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "11";
		wait for CLK_PERIOD;
		
		assert ((C1 = "10") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 10K dengan pembayaran 20K" severity error;
		wait for CLK_PERIOD;
		assert (O = T) report "Tidak mengeluarkan tiket jika memilih tiket 10K dengan pembayaran 20K" severity error;
		wait for CLK_PERIOD * 2;


		-- tiket 15K, bayar 5K, 5K, 5K --
		T <= "11";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "01";
		wait for CLK_PERIOD;
		M <= "01";
		wait for CLK_PERIOD;
		M <= "01";
		wait for CLK_PERIOD;
		
		assert ((C1 = "00") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 15K dengan pembayaran 5K, 5K, dan 5K" severity error;
		wait for CLK_PERIOD;
		assert (O = T) report "Tidak mengeluarkan tiket jika memilih tiket 15K dengan pembayaran 5K, 5K, dan 5K" severity error;
		wait for CLK_PERIOD * 2;


		-- tiket 15K, bayar 10K, 5K --
		wait for CLK_PERIOD * 2;
		T <= "11";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "10";
		wait for CLK_PERIOD;
		M <= "01";
		wait for CLK_PERIOD;
		
		assert ((C1 = "00") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 15K dengan pembayaran 10K dan 5K" severity error;
		wait for CLK_PERIOD;
		assert (O = T) report "Tidak mengeluarkan tiket jika memilih tiket 15K dengan pembayaran 10K dan 5K" severity error;
		wait for CLK_PERIOD * 2;
		

		-- tiket 15K, bayar 20K --
		T <= "11";
		M <= "00";
		wait for CLK_PERIOD;
		M <= "11";
		wait for CLK_PERIOD;
		
		assert ((C1 = "01") and (C2 = "00")) report "Kembalian gagal jika memilih tiket 15K dengan pembayaran 20K" severity error;
		wait for CLK_PERIOD;
		assert (O = T) report "Tidak mengeluarkan tiket jika memilih tiket 15K dengan pembayaran 20K" severity error;
		wait for CLK_PERIOD * 2;

		wait;
	end process;
end bench;