--
-- MMCM Testbench
--
-- Author:
-- * Rodrigo A. Melo, rmelo@inti.gob.ar
--
-- Copyright (c) 2016 INTI
-- Copyright (c) 2016 Rodrigo A. Melo
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library UTILS;
use UTILS.Simul.all;

entity Top_tb is
end entity Top_tb;

architecture Test of Top_tb is
   constant PERIOD       : time := 5 ns;
   signal clk, nclk, rst : std_logic;
   signal stop           : boolean;
   signal leds           : std_logic_vector(5 downto 0);
begin

   nclk <= not (clk);

   do_clk: Clock
   generic map(PERIOD => PERIOD)
   port map(clk_o => clk, rst_o => rst, stop_i => stop);

   dut: entity work.Top
   port map (clk_p_i => clk, clk_n_i => nclk, rst_i => rst, leds_o => leds);

   stimulus: process
   begin
      wait until rising_edge(clk) and rst='0';
      for i in 0 to 255 loop
          wait until rising_edge(clk);
      end loop;
      stop <= TRUE;
      wait;
   end process stimulus;

end architecture Test;
