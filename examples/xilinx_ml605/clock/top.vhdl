--
-- Clocks on ml605
--
-- There are four clock sources on ml605 board:
-- * On-board differential 200 MHz oscillator.
-- * On-board single-ended Oscillator Socket populated with 66 MHz.
-- * User differential through SMA.
-- * MGT differential through SMA.
-- This example is about on-board clock sources. They are used to blink user leds.
-- The clock of 200 MHz is used to blink the 8 GPIO LEDs.
-- The clock of 66 MHz is used to blink the 5 direction LEDs.
-- CPU Reset push-button (SW10) is used to stop and restart blink cycle.
--
-- Author(s):
-- * Rodrigo A. Melo
--
-- Copyright (c) 2016 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library UTILS;
use UTILS.verif.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity Top is
   port (
      clk_i   :  in std_logic;
      clk_p_i :  in std_logic;
      clk_n_i :  in std_logic;
      rst_i   :  in std_logic;
      leds_o  : out std_logic_vector(12 downto 0)
   );
end entity Top;

architecture RTL of Top is
   signal clk200, led66, led200 : std_logic;
begin

   IBUFGDS_inst: IBUFGDS
   port map (I => clk_p_i, IB => clk_n_i, O => clk200);

   blink66_inst: Blink
   generic map (FREQUENCY => 66e6)
   port map(clk_i => clk_i, rst_i => rst_i, blink_o => led66);

   blink200_inst: Blink
   generic map (FREQUENCY => 200e6)
   port map(clk_i => clk200, rst_i => rst_i, blink_o => led200);

   leds_o(4 downto 0)  <= led66 & led66 & led66 & led66 & not(led66);
   leds_o(12 downto 5) <= led200 & not(led200) & led200 & not(led200) &
                          led200 & not(led200) & led200 & not(led200);

end architecture RTL;
