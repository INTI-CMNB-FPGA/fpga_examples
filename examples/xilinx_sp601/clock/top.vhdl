--
-- Clocks on sp601
--
-- There are four clock sources on sp601 board:
-- * On-board differential 200 MHz oscillator.
-- * On-board single-ended Oscillator Socket populated with 27 MHz.
-- * User differential through SMA.
-- * Differential through SMA.
-- This example is about on-board clock sources. They are used to blink user leds.
-- The clock of 200 MHz is used to blink LEDs 0 and 1.
-- The clock of 27 MHz is used to blink LEDs 2 and 3.
-- CPU_RESET push-button is used to stop and restart blink cycle.
--
-- Author(s):
-- * Rodrigo A. Melo
--
-- Copyright (c) 2017 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;
library FPGALIB;
use FPGALIB.verif.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity Top is
   port (
      clk_i   :  in std_logic;
      clk_p_i :  in std_logic;
      clk_n_i :  in std_logic;
      rst_i   :  in std_logic;
      leds_o  : out std_logic_vector(3 downto 0)
   );
end entity Top;

architecture RTL of Top is
   signal clk200, led27, led200 : std_logic;
begin

   IBUFGDS_inst: IBUFGDS
   port map (I => clk_p_i, IB => clk_n_i, O => clk200);

   blink27_inst: Blink
   generic map (FREQUENCY => 27e6)
   port map(clk_i => clk_i, rst_i => rst_i, blink_o => led27);

   blink200_inst: Blink
   generic map (FREQUENCY => 200e6)
   port map(clk_i => clk200, rst_i => rst_i, blink_o => led200);

   leds_o  <= led27 & led27 & led200 & led200;

end architecture RTL;
