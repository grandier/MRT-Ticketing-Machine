library ieee;
use ieee.std_logic_1164.all;


-- Untuk M (Money)
-- 00 = Tidak ada
-- 01 = 5K
-- 10 = 10K
-- 11 = 20K

-- Untuk T (Ticket)
-- 00 = Tidak ada
-- 01 = 5K
-- 10 = 10K
-- 11 = 15K

--- Untuk C1 dan C2 (Change)
-- 00 = 0
-- 01 = 5K
-- 10 = 10K
-- 11 = Tidak ada


entity Ticket_Machine is
	port(
		CLK : in std_logic;
		M, T : in std_logic_vector (1 downto 0);
		C1, C2, O : out std_logic_vector (1 downto 0)
	);
end Ticket_Machine;

architecture behaviour of Ticket_Machine is
	type state_types is (S0, S1, S2, S3, S4, S5, S6, S7, S8);

	-- S0 = idle
	-- S1 = pilih tiket 5K
	-- S2 = pilih tiket 10K
	-- S3 = pilih tiket 15K
	-- S4 = kembali 0
	-- S5 = kembali 5K
	-- S6 = kembali 10K
	-- S7 = kembali 15K (10K + 5K)
	-- S8 = keluar tiket

	signal PS, NS : state_types;
begin
	sync_proc : process(CLK, NS)
	begin
		if(rising_edge(CLK)) then PS <= NS;
		end if;
	end process;
	
	comb_proc : process(PS, M, T)
	begin
		C1 <= "00";
		C2 <= "00";
		O <= "00";

		case PS is

			when S0 => -- idle
				if(T = "00" or M /= "00") then NS <= S0;-- input invalid

				elsif(T = "01" and M = "00") then NS <= S1; -- tiket 5K

				elsif(T = "10" and M = "00") then NS <= S2;-- tiket 10K

				elsif(T = "11" and M = "00") then NS <= S3; -- tiket 15K
				end if;

			when S1 => -- tiket 5K
				-- kembali 0
				if(M = "01") then NS <= S4; -- kembali 0
				
				elsif(M = "10") then NS <= S5; -- kembali 5K

				elsif(M = "11") then NS <= S7; -- kembali 15K --> 10 + 5
				end if;

			when S2 => -- tiket 10K
				if(M = "01") then NS <= S1; -- sisa 5K

				elsif(M = "10") then NS <= S4; -- kembali 0
				
				elsif(M = "11") then NS <= S6; -- kembali 10K
				end if;

			when S3 => -- tiket 15K
				if(M = "01") then NS <= S2; -- sisa 10K

				elsif(M = "10") then NS <= S1; -- sisa 5K

				elsif(M = "11") then NS <= S5; -- kembali 5K
				end if;

			when S4 => -- kembali 0
				C1 <= "00"; -- 0

				C2 <= "00"; -- 0
				NS <= S8;

			when S5 => -- kembali 5K
				C1 <= "01"; -- 5K

				C2 <= "00"; -- 0
				NS <= S8;

			when S6 => -- kembali 10K
				C1 <= "10"; -- 10K

				C2 <= "00"; -- 0
				NS <= S8;

			when S7 => -- kembali 15K (10K + 5K)
				C1 <= "10"; -- 10K
				
				C2 <= "01"; -- 5K
				NS <= S8;

			when S8 => -- keluar tiket
				O <= T;

				NS <= S0;

		end case;

	end process;

end behaviour;