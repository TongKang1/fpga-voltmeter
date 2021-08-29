module adc_8bit(
	input clk_in,
	input rst_n_in,
	input adc_in,
	output adc_clk,
	output adc_csn,
	output [7:0]led,
	output [7:0]wr_data,
	output [8:0]wr_addr,
	output wr_en
);

	reg adc_clk;
	reg adc_csn;
	localparam ADC_PERIOD = 4'd12;
	reg [3:0]adc_count;
	reg [7:0]buffer;
	reg [15:0]mul_result;
	reg [7:0]bin_result;
	reg [6:0]state;
	reg [7:0]BCD;
	reg [7:0]led;
	
	wire [7:0]wr_data;
	wire [8:0]wr_addr;
	wire wr_en;
	
	volt_display volt_display_real(.clk_in(clk_in), .rst_n_in(rst_n_in),
	.BCD(BCD), .wr_en(wr_en), .wr_addr(wr_addr), .wr_data(wr_data));
	
	always@(posedge clk_in or negedge rst_n_in)
		begin
			if(!rst_n_in)
				begin
					adc_clk <= 1'b0;
					adc_count <= 4'b0;
				end
			else
				begin
					if(adc_count==ADC_PERIOD)
						begin
							adc_clk <= ~adc_clk;
							adc_count <= 4'b0;
						end
					else
						begin
							adc_count <= adc_count+1;
						end
				end
		end
		
	always@(posedge adc_clk or negedge rst_n_in)
		begin
			if(!rst_n_in)
				begin
					state <= 7'b0;
					buffer <= 8'b0;
					adc_csn <= 1'b1;
					BCD <= 8'h00;
					bin_result <= 8'b0;
					led <= 8'hff;
				end
			else
				case(state)
					7'd0: begin
							adc_csn <= 1'b0;
							state <= state+1;
						end
					7'd4: begin
							buffer[7] <= adc_in;
							state <= state+1;
						end
					7'd5: begin
							buffer[6] <= adc_in;
							state <= state+1;
						end
					7'd6: begin
							buffer[5] <= adc_in;
							state <= state+1;
						end
					7'd7: begin
							buffer[4] <= adc_in;
							state <= state+1;
						end
					7'd8: begin
							buffer[3] <= adc_in;
							state <= state+1;
						end
					7'd9: begin
							buffer[2] <= adc_in;
							state <= state+1;
						end
					7'd10: begin
							buffer[1] <= adc_in;
							state <= state+1;
						end
					7'd11: begin
							buffer[0] <= adc_in;
							state <= state+1;
							adc_csn <= 1'b1;
						end
					7'd12: begin
							state <= state+1;
						end
					7'd13: begin
							mul_result <= buffer*8'd132;
							state <= state+1;
						end
					7'd14: begin
							mul_result <= mul_result+16'd132;
							state <= state+1;
						end
					7'd15: begin
							bin_result[5:0] <= mul_result[15:10];
							state <= state+1;
						end
					7'd16: begin
						//8-bit binary to BCD
							state <= state+1;
							case(bin_result)
								8'd10: BCD <= 8'h10;
								8'd11: BCD <= 8'h11;
								8'd12: BCD <= 8'h12;
								8'd13: BCD <= 8'h13;
								8'd14: BCD <= 8'h14;
								8'd15: BCD <= 8'h15;
								8'd16: BCD <= 8'h16;
								8'd17: BCD <= 8'h17;
								8'd18: BCD <= 8'h18;
								8'd19: BCD <= 8'h19;
								8'd20: BCD <= 8'h20;
								8'd21: BCD <= 8'h21;
								8'd22: BCD <= 8'h22;
								8'd23: BCD <= 8'h23;
								8'd24: BCD <= 8'h24;
								8'd25: BCD <= 8'h25;
								8'd26: BCD <= 8'h26;
								8'd27: BCD <= 8'h27;
								8'd28: BCD <= 8'h28;
								8'd29: BCD <= 8'h29;
								8'd30: BCD <= 8'h30;
								8'd31: BCD <= 8'h31;
								8'd32: BCD <= 8'h32;
								8'd33: BCD <= 8'h33;
								default: BCD <= bin_result;
							endcase
						end
					7'd100: begin
							led <= ~buffer;
							state <= 7'd0;
						end
					default: begin
							state <= state+1;
						end
				endcase
		end
	

endmodule