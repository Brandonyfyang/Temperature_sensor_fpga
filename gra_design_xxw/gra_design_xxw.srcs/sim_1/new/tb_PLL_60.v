`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/28 18:55:21
// Design Name: 
// Module Name: tb_PLL_60
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_PLL_60;
reg clk_in1;
reg reset;
wire locked,clk_out1;
initial begin
    clk_in1 = 1'b0;
    reset = 1'b1;
    #500
    reset = 1'b0;
end
always
    #5 clk_in1 = ~clk_in1;
clk_wiz_0 inst_wiz_0(
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk_in1));      // input clk_in1
endmodule
