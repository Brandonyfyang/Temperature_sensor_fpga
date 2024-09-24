`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: yifan_yang
// 
// Create Date: 2024/01/20 14:45:13
// Design Name: 
// Module Name: decoder_seg
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
module decoder_seg(
    input wire [3:0] x,
	input wire clk,
	input wire rst_n,
    output reg [6:0] y
);
    always @(posedge clk ) begin
		if(!rst_n)begin
			y <= 7'b0;
		end
		else begin
			case (x[3:0])
			4'd0: y <= 7'h40;
			4'd1: y <= 7'h79;
			4'd2: y <= 7'h24;
			4'd3: y <= 7'h30;
			4'd4: y <= 7'h19;
			4'd5: y <= 7'h12;
			4'd6: y <= 7'h02;
			4'd7: y <= 7'h78;
			4'd8: y <= 7'h00;
			4'd9: y <= 7'h10;
			4'ha: y <= 7'h08;
			4'hb: y <= 7'h03;
			4'hc: y <= 7'h46;
			4'hd: y <= 7'h21;
			4'he: y <= 7'h04;
			4'hf: y <= 7'h0e;
			default:; 
			endcase
		end
	end
endmodule

