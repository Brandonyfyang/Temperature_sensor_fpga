`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/24 14:51:37
// Design Name: 
// Module Name: tb_without_bubble
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


module tb_without_bubble;
reg clk;
reg rst_n;
reg [7:0] data_in;
reg valid_a;
reg ready_b;
wire ready_a;
wire valid_b;
wire [9:0] data_out;

//模块例化
without_bubble inst1(
.clk      (clk  ),
.rst_n    (rst_n  ),
.data_in  (data_in[7:0]  ),
.valid_a  (valid_a  ),
.ready_b  (ready_b  ),
.ready_a  (ready_a  ),
.valid_b  (valid_b  ),
.data_out (data_out[9:0]  )
);

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    #60
    rst_n = 1'b1;
end

always 
    #5 clk = ~clk;
reg [2:0] cnter ;

always@(posedge clk)begin
    if(!rst_n)begin
        cnter <= 3'b0;
    end
    else begin
        cnter <= (cnter==3'd3)?3'd0:cnter + 1'b1;
    end
end

always@(posedge clk)begin
    if(!rst_n)begin
        valid_a <= 1'b0;
        data_in <= 8'b0;
    end
    else if(cnter >= 3'd0 && cnter <= 3'd3)begin
        valid_a <= 1'b1;
        data_in <= data_in + 1'b1;
    end
    else begin
        valid_a <= 1'b0;
        data_in <= data_in;
    end
end

always@(posedge clk)begin
    if(!rst_n)begin
        ready_b <= 1'b0;
    end
    else begin
        ready_b <= (cnter == 3'd0)?1'b1:1'b0;
    end
end

endmodule
