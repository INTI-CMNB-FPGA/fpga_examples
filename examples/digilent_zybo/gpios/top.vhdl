--
-- GPIOs on Zybo (only PL)
--
-- Author(s):
-- * Rodrigo A. Melo
--
-- Copyright (c) 2017 Authors and INTI
-- Distributed under the BSD 3-Clause License
--

library IEEE;
use IEEE.std_logic_1164.all;

entity Top is
   port (
      pbs_i  :  in std_logic_vector(3 downto 0);
      dips_i :  in std_logic_vector(3 downto 0);
      leds_o : out std_logic_vector(3 downto 0)
   );
end entity Top;

architecture RTL of Top is
begin

   leds_o <= pbs_i or dips_i;

end architecture RTL;
