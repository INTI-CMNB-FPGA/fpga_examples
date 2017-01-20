--
-- Clocks on s5micro
--
-- There are four clock sources on s6micro board:
-- * 3 are user programmable. Default values:
-- * 1 Optional user installable of 66 MHz (not installed)
-- They are used to blink user leds.
-- The clock of 40 MHz (programmable) is used to blink LEDs 0.
-- The clock of 66.7 MHz (programmable) is used to blink LEDs 1.
-- The clock of 100 MHz (programmable) is used to blink LEDs 2.
-- The clock of 66.7 MHz (Fixed) is used to blink LEDs 3.
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
      clk2_i  :  in std_logic;
      clk3_i  :  in std_logic;
      clk4_i  :  in std_logic;
      rst_i   :  in std_logic;
      leds_o  : out std_logic_vector(3 downto 0)
   );
end entity Top;

architecture RTL of Top is
   signal led0, led1, led2, led3 : std_logic;
begin

   blink40prog_inst: Blink
   generic map (FREQUENCY => 40e6)
   port map(clk_i => clk_i, rst_i => rst_i, blink_o => led0);

   blink66prog_inst: Blink
   generic map (FREQUENCY => 66700e3)
   port map(clk_i => clk2_i, rst_i => rst_i, blink_o => led1);

   blink100prog_inst: Blink
   generic map (FREQUENCY => 100e6)
   port map(clk_i => clk3_i, rst_i => rst_i, blink_o => led2);

   blink66fixed_inst: Blink
   generic map (FREQUENCY => 66700e3)
   port map(clk_i => clk4_i, rst_i => rst_i, blink_o => led3);

   leds_o  <= led3 & led2 & led1 & led0;

end architecture RTL;
