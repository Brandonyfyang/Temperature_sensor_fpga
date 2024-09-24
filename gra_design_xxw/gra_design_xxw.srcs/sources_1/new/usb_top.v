`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/28 15:29:32
// Design Name: 
// Module Name: usb_top
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


module usb_top(
    input wire usb_clk_60m,//out 60M clk
    input wire sys_rst_n,
    input wire usb_rxf_n,//FT232H数据可读指示
    input wire usb_txe_n,//FT232H数据可写指示
    output     usb_oe_n,
    output     usb_rd_n,
    output     usb_wr_n,
    output     usb_siwu_n,
    inout wire [7:0] usb_data//FT232双向数据总线
    );
endmodule
