`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: yifan_yang
// 
// Create Date: 2024/01/20 13:06:46
// Design Name: 
// Module Name: ds18_driver
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

module ds18_driver(
	input 		wire    clk	,//Nexy 4系统时钟，频率为50M
	input		wire    rst_n,//复位信号 低电平有效	
	
	inout		wire	dq,//单总线（双向信号）
	output reg [19:0]   temp_data,//转换后得到的温度值
    output reg          sign//符号位
);
//参数定义
parameter	INIT1	= 6'd1,
			WR_CMD  = 6'd2,
			WAIT  	= 6'd3,
			INIT2  	= 6'd4,
			RD_CMD  = 6'd5,
			RD_DATA = 6'd6;
//时间参数定义
parameter	T_INIT = 1_000	,//初始化最大时间 时长为1ms
			T_WAIT = 780_000;//转换等待延时 时长为780ms
//命令定义	
parameter 	WR_CMD_DATA = 16'h44cc,//跳过ROM及温度转换命令，低位在前
			RD_CMD_DATA = 16'hbecc;//跳过ROM及读取温度命令，低位在前
//信号定义
reg	[2:0]	cur_state	;//现态
reg	[2:0]	next_state	;//次态
reg	[4:0]	cnt			;//50分频计数器，1Mhz(1us)
reg			dq_out		;//双向总线输出
reg			dq_en		;//双向总线输出使能，1则输出，0则高阻态
reg			flag_ack	;//从机响应标志信号
reg			clk_us		;//us时钟
reg [19:0]	cnt_us		;//us计数器,最大可表示1048ms
reg [3:0]	bit_cnt		;//接收数据计数器
reg [15:0]	data_temp	;//读取的温度数据寄存
reg [15:0]	data		;//未处理的原始温度数据
wire		dq_in		;//双向总线输入
reg         rd_finish   ;

//双向端口使用方式
assign	dq_in = dq;//高阻态的话，则把总线上的数据赋给dq_in
assign	dq =  dq_en ? dq_out : 1'bz;//使能1则输出，0则高阻态

//生成1Mhz时钟
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt <= 5'd0;
        clk_us <= 1'b0;
    end
	else if(cnt == 5'd24)begin
		cnt <= 5'd0;
        clk_us <= ~clk_us;        
    end
	else begin
		cnt <= cnt + 1'd1;
        clk_us <= clk_us;       
    end
end

//状态机第一段
always @(posedge clk_us or negedge rst_n)begin
	if(!rst_n)begin		
		cur_state <= INIT1;	//复位就回到初始状态
    end else begin
		cur_state <= next_state; //不复位就每次都跳状态
    end
end

//状态机第二段
always @(*)begin
	next_state = INIT1;	
	case(cur_state)
		INIT1:begin
			if(cnt_us == T_INIT && flag_ack)begin//满足初始化时间且接收到了从机的响应信号	
				next_state = WR_CMD;//跳转到写状态
            end else begin	
				next_state = INIT1;
            end
		end	
		WR_CMD:begin	
			if(bit_cnt == 4'd15 && cnt_us == 20'd62)begin//写完了16个数据，写跳过ROM和写温度转换命令	
				next_state = WAIT;//跳转到等待状态，等待温度转换完成 
            end else begin
				next_state = WR_CMD;
            end						
		end	
		WAIT:begin	
			if(cnt_us == T_WAIT)begin//等待时间结束
				next_state = INIT2;	
            end else begin	
				next_state = WAIT;
            end	
		end	
		INIT2:begin	
			if(cnt_us == T_INIT && flag_ack)begin//再进行初始化，时序同INIT1
				next_state = RD_CMD;
            end else begin
				next_state = INIT2;
            end
		end
		RD_CMD:begin
			if(bit_cnt == 4'd15 && cnt_us == 20'd62)begin//写完了16个数据，写跳过ROM和写读取温度转换命令	
				next_state = RD_DATA;//跳转到读取温度数据状态
            end else begin
				next_state = RD_CMD;
            end	
		end	
		RD_DATA:begin	
			if(bit_cnt == 4'd15 && cnt_us == 20'd62)begin//读取完了16个数据
				next_state = INIT1;//跳转到初始化状态，开始新一轮温度采集
            end else begin	
				next_state = RD_DATA;
            end	
		end			
		default:next_state = INIT1;//默认初始化状态
	endcase
end

//状态机第三段：时序逻辑描述输出
always @(posedge clk_us or negedge rst_n)begin
	if(!rst_n)begin//默认输出
		dq_en <= 1'b0;
		dq_out <= 1'b0;
		flag_ack <= 1'b0;
		cnt_us <= 20'd0;
		bit_cnt <= 4'd0;
        rd_finish <= 1'b0;
	end
	else begin 	
		case(cur_state)
			INIT1:begin
                rd_finish <= 1'b0;
				if(cnt_us == T_INIT)begin					//时间计数到最大值（初始化时间）
					cnt_us <= 20'd0;						//计数器清零
					flag_ack <= 1'b0;						//从机响应标志信号拉低
				end
				else begin									//没有计数到最大值
					cnt_us <= cnt_us + 1'd1;				//计数器计数
					if(cnt_us <= 20'd499)begin				//小于500us时
						dq_en <= 1'b1;						//控制总线
						dq_out <= 1'b0;						//输出0，即拉低总线
					end
					else begin								//在500us处
						dq_en <= 1'b0;						//释放总线，等待从机响应						
						if (cnt_us == 20'd570 && !dq_in)	//在570us处采集总线电平，如果为0则说明从机响应了
							flag_ack <= 1'b1;				//拉高从机响应标志信号
					end	
				end
			end
			WR_CMD:begin
				if(cnt_us == 20'd62)begin						//一个写时隙周期63us，满足计时条件则
					cnt_us <= 20'd0;							//清空计数器
					dq_en <= 1'b0;								//释放总线
					if(bit_cnt == 4'd15)						//如果数据已经写了15个
						bit_cnt <= 4'd0;						//则清空
					else										//没写15个
						bit_cnt <= bit_cnt + 1'd1;				//则数据计数器+1，代表写入了一个数据
				end	
				else begin										//一个写时隙周期63us未完成
					cnt_us <= cnt_us + 1'd1;					//计数器一直计数
					if(cnt_us <= 20'd1)begin					//0~1us（每两个写数据之间需要间隔2us）
						dq_en <= 1'b1;							//拉低总线
						dq_out <= 1'b0;
					end
					else begin					
						if (WR_CMD_DATA[bit_cnt] == 1'b0)begin	//需要写入的数据为0
							dq_en <= 1'b1;						//拉低总线
							dq_out <= 1'b0;						//								
						end
						else if(WR_CMD_DATA[bit_cnt] == 1'b1)begin
							dq_en <= 1'b0;						//需要写入的数据为1
							dq_out <= 1'b0;						//释放总线						
						end
					end	
				end		
			end		
			WAIT:begin										//等待温度转换完成
				dq_en <= 1'b1;									//拉低总线兼容寄生电源模式
				dq_out <= 1'b1;									
				if(cnt_us == T_WAIT)							//计数完成
					cnt_us <= 20'd0;
				else
					cnt_us <= cnt_us + 1'd1;
			end	
			INIT2:begin										//第二次初始化，时序同INIT1
				if(cnt_us == T_INIT)begin						
					cnt_us <= 20'd0;
					flag_ack <= 1'b0;
				end
				else begin
					cnt_us <= cnt_us + 1'd1;
					if(cnt_us <= 20'd499)begin
						dq_en <= 1'b1;						
						dq_out <= 1'b0;
					end
					else begin
						dq_en <= 1'b0;												
						if (cnt_us == 20'd570 && !dq_in)
							flag_ack <= 1'b1;
					end	
				end
			end	
			RD_CMD:begin										//写16个数据，时序同WR_CMD
				if(cnt_us == 20'd62)begin
					cnt_us <= 20'd0;
					dq_en <= 1'b0;
					if(bit_cnt == 4'd15)
						bit_cnt <= 4'd0;
					else
						bit_cnt <= bit_cnt + 1'd1;
				end
				else begin
					cnt_us <= cnt_us + 1'd1;
					if(cnt_us <= 20'd1)begin
						dq_en <= 1'b1;							
						dq_out <= 1'b0;
					end
					else begin					
						if (RD_CMD_DATA[bit_cnt] == 1'b0)begin
							dq_en <= 1'b1;						
							dq_out <= 1'b0;														
						end
						else if(RD_CMD_DATA[bit_cnt] == 1'b1)begin
							dq_en <= 1'b0;						
							dq_out <= 1'b0;												
						end
					end	
				end
			end	
			RD_DATA	:begin										//读16位温度数据
				if(cnt_us == 20'd62)begin						//一个读时隙周期63us，满足计时条件则
					cnt_us <= 20'd0;							//清空计数器
					dq_en <= 1'b0;								//释放总线
					if(bit_cnt == 4'd15)begin					//如果数据已经读取了15个
						bit_cnt <= 4'd0;						//则清空
						data <= data_temp;						//临时的数据赋值给data
                        rd_finish <= 1'b1;
					end
					else begin									//如果数据没有读取15个
						bit_cnt <= bit_cnt + 1'd1;				//则数据计数器+1，意味着读取了一个数据
						data <= data;
                        rd_finish <= 1'b0;
					end
				end
				else begin										//一个读时隙周期还没结束
					cnt_us <= cnt_us + 1'd1;					//计数器累加
					if(cnt_us <= 20'd1)begin					//0~1us（每两个读数据之间需要间隔2us）
						dq_en <= 1'b1;							//拉低总线
						dq_out <= 1'b0;
					end
					else begin									//2us后
						dq_en <= 1'b0;							//释放总掉线					
						if (cnt_us == 20'd10)					//在10us处读取总线电平
							data_temp <= {dq,data_temp[15:1]};	//读取总线电平
					end	
				end
			end
			default:;		
		endcase
	end
end

//温度数据处理
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin//初始状态
		temp_data <= 20'd0;	
		sign  <= 1'b0;	
	end	
	else if(rd_finish)begin
        if(!data[15])begin
            sign <= 1'b0;
            temp_data[10:0] <= data[10:0] ;
        end
        else if(data[15])begin
            sign <= 1'b1;
            temp_data[10:0] <= (~data[10:0] + 1'b1) ;
        end
	end
end


endmodule
