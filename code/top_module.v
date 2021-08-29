module top(
	input clk_in,
	input rst_n_in,
	
	input adc_in,
	output adc_clk,
	output adc_csn,
	output [7:0]led,
	
	output oled_csn,
	output oled_rst,
	output oled_dcn,
	output oled_clk,
	output oled_dat
);
	
	wire [8:0]rd_addr;
	wire [8:0]wr_addr;
	wire [7:0]rd_data;
	wire [7:0]wr_data;
	wire wr_en, rd_en;
	
	wire [7:0]led;
	
	wire oled_csn, oled_rst, oled_dcn, oled_clk, oled_dat;
	wire adc_clk, adc_csn;
	
	//RAM模块 512*8
	ram_display ram_display_real(.WrAddress(wr_addr), .RdAddress(rd_addr), .Data(wr_data), .WE(wr_en), 
    .RdClock(oled_clk), .RdClockEn(rd_en), .Reset(~rst_n_in), .WrClock(clk_in), .WrClockEn(wr_en), 
    .Q(rd_data));
	
	//OLED根据RAM中的内容刷新显示模块
	spi_oled spi_oled_real(.clk_in(clk_in), .rst_n_in(rst_n_in), .rd_data(rd_data),
	.oled_csn(oled_csn), .oled_rst(oled_rst), .oled_dcn(oled_dcn), .oled_clk(oled_clk),
	.oled_dat(oled_dat), .rd_addr(rd_addr), .rd_en(rd_en));
	
	//ADC读取并刷新RAM模块
	adc_8bit adc_volt(.clk_in(clk_in), .rst_n_in(rst_n_in), .adc_in(adc_in), .adc_clk(adc_clk), 
	.adc_csn(adc_csn), .led(led), .wr_data(wr_data), .wr_addr(wr_addr), .wr_en(wr_en));


endmodule