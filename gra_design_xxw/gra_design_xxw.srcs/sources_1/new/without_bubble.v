`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: yyf
// 
// Create Date: 2024/01/24 13:49:19
// Design Name: 
// Module Name: without_bubble
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 实现串行输入数据累加输出，输入端输入8bit数据，每当模块接收到4个输入数据后，输出端输出4个接收到数据的累加结果。
// 输入端和输出端与上下游的交互采用valid-ready双向握手机制。要求上下游均能满速传输时，数据传输无气泡，不能由于本模块的设计原因产生额外的性能损失。
// 其中，valid_a用来指示数据输入data_in的有效性，valid_b用来指示数据输出data_out的有效性；
// ready_a用来指示本模块是否准备好接收上游数据，ready_b表示下游是否准备好接收本模块的输出数据；clk是时钟信号；rst_n是异步复位信号。
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module without_bubble(
	input 				clk 	,//时钟信号   
	input 				rst_n	,//复位信号
	input		[7:0]	data_in	,//数据输入
	input				valid_a	,//数据有效
	input	 			ready_b	,//下游是否准备好接收
    output		 		ready_a	,//本模块是否准备好接收上游数据
    output	reg			valid_b	,//数据输出有效位
	output  reg [9:0] 	data_out //数据输出  
);
reg [1:0] cnter;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnter <= 2'b0;
	end
    else if(ready_a && valid_a)begin//上游有数据来，且本模块已经准备好接收
		cnter <= cnter + 1'b1;
	end
end

assign ready_a = (!valid_b) || ready_b ;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		valid_b <= 1'b0;
	end
	else if(cnter == 2'd3 && valid_a && ready_a)begin//已经接受了上游的四个数据
        valid_b <= 1'b1;
	end
	else if(valid_b && ready_b)begin//下游数据接收完成了
		valid_b <= 1'b0;
	end
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		data_out <= 10'b0;
	end
	else if(cnter == 2'b00 && ready_b && valid_a && ready_a)begin
		data_out <= {2'b00,data_in};//第一拍数据
	end
	else if(valid_a && ready_a)begin
		data_out <= data_out + data_in ;//数据累加输出
	end
end

endmodule
