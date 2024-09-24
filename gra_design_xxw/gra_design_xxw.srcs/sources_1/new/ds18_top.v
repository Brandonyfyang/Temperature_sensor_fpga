`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/21 14:14:12
// Design Name: 
// Module Name: ds18_top
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


module ds18_top(
input  wire sys_clk,
input  wire rst_n,
inout  wire dq0,
inout  wire dq1,
input  wire sen_sel,
input  wire [7:0] limit_value,
output wire [7:0] sel,
output wire [7:0] seg_led,
output wire comp_flag
    );
wire sign0,sign1;
wire [19:0] temp_data0,temp_data1;
//sen0 driver
ds18_driver driver_inst0(
    .clk        (sys_clk),          
    .rst_n      (rst_n) ,                
    .dq         (dq0) ,            
    .temp_data  (temp_data0) ,             
    .sign       (sign0)        
);
//sen1 driver
ds18_driver driver_inst1(
    .clk        (sys_clk),          
    .rst_n      (rst_n) ,                
    .dq         (dq1) ,            
    .temp_data  (temp_data1) ,             
    .sign       (sign1)        
);
reg sign2;
reg [19:0] temp_data2;
always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n)begin
        sign2 <= 1'b0;
        temp_data2 <= 20'b0;
    end
    else begin
        if(sen_sel)begin
            sign2 <= sign0;
            temp_data2 <= temp_data0;
        end
        else begin
            sign2 <= sign1;
            temp_data2 <= temp_data1;
        end
    end
end
//模块调用 seg_work
seg_work seg_inst(
    .clk         (sys_clk),       
    .rst_n       (rst_n),         
    .temp_data   (temp_data2),           
    .work_en     (1'b1),            
    .sign        (sign2),            
    .point       (point),
    .limit_value (limit_value),            
    .seg_led     (seg_led),
    .comp_flag   (comp_flag),             
    .sel         (sel)         
);
//PLL Mode
wire reset_pll;
assign reset_pll = ~rst_n;
clk_wiz_0 inst_wiz_0(
    .clk_out1(clk_60m),// output clk_out1
    .reset(reset_pll), // input reset
    .locked(locked),// output locked high valid
    .clk_in1(sys_clk)// input clk_in1
    );

endmodule
