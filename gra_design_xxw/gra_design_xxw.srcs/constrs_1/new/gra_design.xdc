## Clock signal 时钟信号
set_property PACKAGE_PIN E3 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
## 复位信号
set_property PACKAGE_PIN U9 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN U8 [get_ports sen_sel]					
set_property IOSTANDARD LVCMOS33 [get_ports sen_sel]
##Bank = 34, Pin name = IO_L24N_T3_34,						Sch name = LED0
set_property PACKAGE_PIN T8 [get_ports comp_flag]					
set_property IOSTANDARD LVCMOS33 [get_ports comp_flag]
##Bank = 34, Pin name = IO_L8P_T1-34,						Sch name = SW8
set_property PACKAGE_PIN U4 [get_ports {limit_value[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[0]}]
##Bank = 34, Pin name = IO_L9N_T1_DQS_34,					Sch name = SW9
set_property PACKAGE_PIN V2 [get_ports {limit_value[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[1]}]
##Bank = 34, Pin name = IO_L9P_T1_DQS_34,					Sch name = SW10
set_property PACKAGE_PIN U2 [get_ports {limit_value[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[2]}]
##Bank = 34, Pin name = IO_L11N_T1_MRCC_34,					Sch name = SW11
set_property PACKAGE_PIN T3 [get_ports {limit_value[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[3]}]
##Bank = 34, Pin name = IO_L17N_T2_34,						Sch name = SW12
set_property PACKAGE_PIN T1 [get_ports {limit_value[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[4]}]
##Bank = 34, Pin name = IO_L11P_T1_SRCC_34,					Sch name = SW13
set_property PACKAGE_PIN R3 [get_ports {limit_value[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[5]}]
##Bank = 34, Pin name = IO_L14N_T2_SRCC_34,					Sch name = SW14
set_property PACKAGE_PIN P3 [get_ports {limit_value[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[6]}]
##Bank = 34, Pin name = IO_L14P_T2_SRCC_34,					Sch name = SW15
set_property PACKAGE_PIN P4 [get_ports {limit_value[7]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {limit_value[7]}]
##Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = AN0
set_property PACKAGE_PIN N6 [get_ports {sel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[0]}]
##Bank = 34, Pin name = IO_L18P_T2_34,						Sch name = AN1
set_property PACKAGE_PIN M6 [get_ports {sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[1]}]
##Bank = 34, Pin name = IO_L4P_T0_34,						Sch name = AN2
set_property PACKAGE_PIN M3 [get_ports {sel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[2]}]
##Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name = AN3
set_property PACKAGE_PIN N5 [get_ports {sel[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[3]}]
##Bank = 34, Pin name = IO_L3P_T0_DQS_34,					Sch name = AN4
set_property PACKAGE_PIN N2 [get_ports {sel[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[4]}]
##Bank = 34, Pin name = IO_L16N_T2_34,						Sch name = AN5
set_property PACKAGE_PIN N4 [get_ports {sel[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[5]}]
##Bank = 34, Pin name = IO_L1P_T0_34,						Sch name = AN6
set_property PACKAGE_PIN L1 [get_ports {sel[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[6]}]
##Bank = 34, Pin name = IO_L1N_T034,						Sch name = AN7
set_property PACKAGE_PIN M1 [get_ports {sel[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[7]}]
##7 segment display
##Bank = 34, Pin name = IO_L2N_T0_34,						Sch name = CA
set_property PACKAGE_PIN L3 [get_ports {seg_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[0]}]
##Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = CB
set_property PACKAGE_PIN N1 [get_ports {seg_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[1]}]
##Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = CC
set_property PACKAGE_PIN L5 [get_ports {seg_led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[2]}]
##Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = CD
set_property PACKAGE_PIN L4 [get_ports {seg_led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[3]}]
##Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = CE
set_property PACKAGE_PIN K3 [get_ports {seg_led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[4]}]
##Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = CF
set_property PACKAGE_PIN M2 [get_ports {seg_led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[5]}]
##Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = CG
set_property PACKAGE_PIN L6 [get_ports {seg_led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[6]}]
##Bank = 15, Pin name = IO_L16P_T2_A28_15,					Sch name = JA4 E17? 数据传输线
set_property PACKAGE_PIN E17 [get_ports dq0]
set_property IOSTANDARD LVCMOS33 [get_ports dq0]

set_property PACKAGE_PIN V15 [get_ports dq1]					
set_property IOSTANDARD LVCMOS33 [get_ports dq1]
##Bank = 34, Pin name = IO_L16P_T2_34,						Sch name = DP
set_property PACKAGE_PIN M4 [get_ports {seg_led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_led[7]}]



