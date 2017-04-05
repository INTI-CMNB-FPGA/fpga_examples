`timescale 1ns / 100ps
module top_tb ();
reg clk  = 1'b0     ;
reg rst  = 1'b1     ;
wire LED1, LED2, LED3, LED4, LED5;

top DUT(
//Entradas
   .clk_i(clk), 
   .rst_i(rst),
//Salidas
   .led1_o(LED1),
   .led2_o(LED2),
   .led3_o(LED3),
   .led4_o(LED4),
   .led5_o(LED5)
   );

always #1 clk = ~clk;

initial begin
   $dumpfile("top_tb.vcd");
   $dumpvars(0, top_tb);
   #4 rst = 1'b0;
   @(posedge(clk));
   if (LED5 == 1'b1)
      $display("Initialization OK."); 
   else
      $display("Bad initialization");
	 
    
   repeat(12_000_000) @(posedge(clk));
   repeat(2) @(posedge(clk));
   if (LED5 == 1'b0)
      $display("Test finished OK.");
   else
      $display("Wrong LED value on test finish");
	    
   $finish;
end

 initial
    begin
       $monitor("%b",LED1);
 end

endmodule
