--
-- GPIOs on ml605
--
-- Author(s):
-- * Rodrigo A. Melo
--
-- Copyright (c) 2016 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;

entity Top is
   port (
      dips_i :  in std_logic_vector(7 downto 0);
      pbs_i  :  in std_logic_vector(4 downto 0);
      leds_o : out std_logic_vector(12 downto 0)
   );
end entity Top;

architecture RTL of Top is
begin

   leds_o(4 downto 0)  <= pbs_i;
   leds_o(12 downto 5) <= dips_i;

end architecture RTL;
