`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: yifan_yang
// 
// Create Date: 2024/01/20 15:19:37
// Design Name: 
// Module Name: seg_work
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
module seg_work(
input wire clk,
input wire rst_n,
input wire [19:0] temp_data,
input wire work_en,
input wire sign,
input wire point,
input wire [7:0] limit_value,
output wire [7:0] seg_led,
output reg comp_flag,
output reg [7:0] sel
    );
    reg [2:0] sel_cnter;
    reg [15:0] clk_cnter;
    reg [3:0] sel_number;
    reg clk_1khz;
    reg [3:0] first_number,second_number,third_number;
    reg [3:0] fourth_number,fifth_number,sixth_number;
    reg [7:0] limit_dec,limit_dec1;
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            limit_dec <= 8'b0;
            limit_dec1 <= 8'b0;
        end
        else begin
            limit_dec <= limit_value;
            limit_dec1 <= fifth_number + sixth_number * 4'd10;
        end
    end
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            comp_flag <= 1'b0;
        end
        else begin
            comp_flag <= (limit_dec1 >= limit_dec)?1'b1:1'b0;
        end
    end
    always@(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            clk_1khz <= 1'b0;
            clk_cnter <= 16'b0;
        end
        else begin
            clk_1khz <= (clk_cnter==16'd24999) ? ~clk_1khz:clk_1khz;
            clk_cnter <= (clk_cnter==16'd24999)? 16'b0    :clk_cnter + 1'b1;
        end
    end
    always@(posedge clk_1khz or negedge rst_n)begin
        if(!rst_n)begin
            sel_cnter <= 3'b0;
        end
        else if(work_en)begin
            sel_cnter <= (sel_cnter==3'd5) ? 3'd0 : sel_cnter+1'b1;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            first_number <= 4'b0;
        end
        else begin
            if(temp_data[0])begin
                first_number <= 4'd5;
            end
            else begin
                first_number <= 4'd0;
            end
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            second_number <= 4'b0;
        end
        else begin
            case (temp_data[1:0])
            2'b00:second_number <= 4'd0;
            2'b01:second_number <= 4'd2;
            2'b10:second_number <= 4'd5;
            2'b11:second_number <= 4'd7;
            default:; 
            endcase
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            third_number <= 4'b0;
        end
        else begin
            case (temp_data[2:0])
            3'b000:third_number <= 4'd0;
            3'b001:third_number <= 4'd6;
            3'b010:third_number <= 4'd2;
            3'b011:third_number <= 4'd8;
            3'b100:third_number <= 4'd5;
            3'b101:third_number <= 4'd1;
            3'b110:third_number <= 4'd7;
            3'b111:third_number <= 4'd3; 
            default:;
            endcase
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            fourth_number <= 4'b0;
        end
        else begin
            case (temp_data[3:0])
            4'd0:fourth_number <= 4'd0;
            4'd1:fourth_number <= 4'd0;
            4'd2:fourth_number <= 4'd1;
            4'd3:fourth_number <= 4'd1;
            4'd4:fourth_number <= 4'd2;
            4'd5:fourth_number <= 4'd3;
            4'd6:fourth_number <= 4'd3;
            4'd7:fourth_number <= 4'd4;
            4'd8:fourth_number <= 4'd5;
            4'd9:fourth_number <= 4'd5;
            4'd10:fourth_number <= 4'd6;
            4'd11:fourth_number <= 4'd6;
            4'd12:fourth_number <= 4'd7;
            4'd13:fourth_number <= 4'd8;
            4'd14:fourth_number <= 4'd8;
            4'd15:fourth_number <= 4'd9;
            default:;
            endcase
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            fifth_number <= 4'b0;
        end
        else begin
            fifth_number <= temp_data[10:4] % 4'd10;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            sixth_number <= 4'b0;
        end
        else begin
            if(temp_data[10:4]>=7'd100)begin
                sixth_number <= (temp_data[10:4]-7'd100)/4'd10;
            end
            else begin
                sixth_number <= (temp_data[10:4])/4'd10;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            sel_number <= 4'b0;
            sel <= 8'b11111111;
        end
        else begin
            case (sel_cnter[2:0])
                3'd0:begin
                    //sel_number <= temp_data[3:0];
                    sel_number <= first_number;
                    sel <= 8'b1111_1110;
                end
                3'd1:begin
                    //sel_number <= temp_data[7:4];
                    sel_number <= second_number;
                    sel <= 8'b1111_1101;
                end
                3'd2:begin
                    //sel_number <= {1'b0,temp_data[10:8]};
                    sel_number <= third_number;
                    sel <= 8'b1111_1011;
                end
                3'd3:begin
                    sel_number <= fourth_number;
                    sel <= 8'b1111_0111;
                end
                3'd4:begin
                    sel_number <= fifth_number;
                    sel <= 8'b1110_1111;
                end
                3'd5:begin
                    sel_number <= sixth_number;
                    sel <= 8'b1101_1111;
                end
            default:; 
            endcase
        end
    end
    
    //小数点点亮�?�辑
    assign seg_led[7] = (sel == 8'b1110_1111)?1'b0:1'b1;
    decoder_seg decoder_seg_inst(
    .x     (sel_number),
    .y     (seg_led[6:0]),
    .clk   (clk),
    .rst_n (rst_n)
    );
endmodule
