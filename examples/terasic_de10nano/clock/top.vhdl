--
-- Clock on de10nano
--
-- There is three clock sources on de10nano board:
-- * 3 x On-board 50MHz clock oscillator.
--
-- Author(s):
-- * Rodrigo A. Melo
--
-- Copyright (c) 2017-2019 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;
library FPGALIB;
use FPGALIB.verif.all;

entity Top is
   port (
      clk_i   :  in std_logic;
      clk2_i  :  in std_logic;
      clk3_i  :  in std_logic;
      rst_n_i :  in std_logic;
      leds_o  : out std_logic_vector(2 downto 0)
   );
end entity Top;

architecture RTL of Top is
   signal rst, led0, led1, led2 : std_logic;
begin

   rst <= not rst_n_i;

   blink0prog_inst: Blink
   generic map (FREQUENCY => 50e6)
   port map(clk_i => clk_i,  rst_i => rst, blink_o => led0);

   blink1prog_inst: Blink
   generic map (FREQUENCY => 50e6)
   port map(clk_i => clk2_i, rst_i => rst, blink_o => led1);

   blink2prog_inst: Blink
   generic map (FREQUENCY => 50e6)
   port map(clk_i => clk3_i, rst_i => rst, blink_o => led2);

   leds_o  <= led2 & led1 & led0;

end architecture RTL;
