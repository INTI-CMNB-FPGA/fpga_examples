//
// Author(s):
// * Bruno Valinoti
//
// Copyright (c) 2017 Authors and INTI
// Distributed under the BSD 3-Clause License
//


module top (
//Entradas
   input wire     clk_i, 
   input wire     rst_i,
//Salidas
   output wire    led1_o,
   output wire    led2_o,
   output wire    led3_o,
   output wire    led4_o,
   output wire    led5_o
   );

//Signals declaration sector
wire led;

//Modules instantiation
   Blink #(
      .FREQUENCY(12_000_000),
      .SECONDS  (1)          
   )
   blink(
      .clk_i   (clk_i),
      .rst_i   (rst_i),
      .blink_o (led)
   );

//Concurrent assigns
assign led1_o = led;
assign led2_o = led;
assign led3_o = led;
assign led4_o = led;
assign led5_o = ~led;

endmodule

