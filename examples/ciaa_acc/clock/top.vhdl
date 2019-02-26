--
-- GPIOs on Zybo (only PL)
--
-- Author(s):
-- * Rodrigo A. Melo
-- * Bruno Valinoti
--
-- Copyright (c) 2019 Authors and INTI
-- Distributed under the BSD 3-Clause License
--


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;
library FPGALIB;
use FPGALIB.verif.all;

entity Top is
   port (
      sysclk_p_i   :  in std_logic;
      sysclk_n_i   :  in std_logic;
      leds_o       : out std_logic_vector(3 downto 0)
   );
end entity Top;

architecture RTL of Top is
   signal clk      : std_logic;
   signal led0, led1, led2, led3 : std_logic;
begin

   blink200MHz_inst: Blink
   generic map (FREQUENCY => 200e6)
   port map(clk_i => clk, rst_i => '0', blink_o => led0);

   ibufgds_inst : IBUFGDS
   generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS")
   port map (I => sysclk_p_i, IB => sysclk_n_i, O => clk);

   led1   <= '1';
   led2   <= led0;
   led3   <= '0';
   leds_o <= led3 & led2 & led1 & led0;
end architecture RTL;






