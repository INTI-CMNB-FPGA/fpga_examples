--
-- Clock on de0nano
--
-- There is one clock source on de0nano board:
-- * On-board 50MHz clock oscillator.
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

entity Top is
   port (
      clk_i   :  in std_logic;
      rst_n_i :  in std_logic;
      leds_o  : out std_logic_vector(7 downto 0)
   );
end entity Top;

architecture RTL of Top is
   signal rst, led : std_logic;
begin

   rst <= not(rst_n_i);

   blink_inst: Blink
   generic map (FREQUENCY => 50e6)
   port map(clk_i => clk_i, rst_i => rst, blink_o => led);

   leds_o <= led & not(led) & led & not(led) & led & not(led) & led & not(led);

end architecture RTL;
