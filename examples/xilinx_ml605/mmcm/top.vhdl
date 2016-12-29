--
-- Mixed-Mode Clock Manager on ml605
--
-- To Do
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

entity Top is
   port (
      clk_p_i :  in std_logic;
      clk_n_i :  in std_logic;
      rst_i   :  in std_logic;
      leds_o  : out std_logic_vector(5 downto 0)
   );
end entity Top;

architecture RTL of Top is
   signal blink_reset, locked : std_logic;
   signal clk50, clk100, clk150, clk200, clk250, clk300 : std_logic;
begin

   mmcm_inst: entity work.mmcm
   port map (
     -- Clock in ports
     CLK_IN1_P => clk_p_i,
     CLK_IN1_N => clk_n_i,
     -- Clock out ports
     CLK_OUT1 => clk50,
     CLK_OUT2 => clk100,
     CLK_OUT3 => clk150,
     CLK_OUT4 => clk200,
     CLK_OUT5 => clk250,
     CLK_OUT6 => clk300,
     -- Status and control signals
     RESET    => rst_i,
     LOCKED   => locked
   );

   blink_reset <= not(locked);

   blink50_inst: Blink
   generic map (FREQUENCY => 50e6)
   port map(clk_i => clk50, rst_i => blink_reset, blink_o => leds_o(0));

   blink100_inst: Blink
   generic map (FREQUENCY => 100e6)
   port map(clk_i => clk100, rst_i => blink_reset, blink_o => leds_o(1));

   blink150_inst: Blink
   generic map (FREQUENCY => 150e6)
   port map(clk_i => clk150, rst_i => blink_reset, blink_o => leds_o(2));

   blink200_inst: Blink
   generic map (FREQUENCY => 200e6)
   port map(clk_i => clk200, rst_i => blink_reset, blink_o => leds_o(3));

   blink250_inst: Blink
   generic map (FREQUENCY => 250e6)
   port map(clk_i => clk250, rst_i => blink_reset, blink_o => leds_o(4));

   blink300_inst: Blink
   generic map (FREQUENCY => 300e6)
   port map(clk_i => clk300, rst_i => blink_reset, blink_o => leds_o(5));

end architecture RTL;
