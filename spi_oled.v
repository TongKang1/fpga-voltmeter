module spi_oled(
	input clk_in,
	input rst_n_in,
	input [7:0]rd_data,
	output oled_csn,
	output oled_rst,
	output oled_dcn,
	output oled_clk,
	output oled_dat,
	output [8:0]rd_addr,
	output rd_en
);
	
	localparam SPI_CLK = 5'd30;
	reg [4:0]count_spi;
	reg clk_spi;
	reg [4:0] count_spi;
	assign oled_rst = rst_n_in;
	wire oled_csn;
	reg oled_dcn;
	reg oled_clk;
	wire oled_dat;
	reg spi_csn;
	reg rd_en;
	reg [8:0]rd_addr;
	
	localparam PERIOD = 18'd200_000;
	reg [7:0]count_sys;
	reg [7:0]cmd_test;
	reg led;
	reg start;
	
	write_8bit write_byte(
		.csn_in(spi_csn),
		.clk(clk_spi),
		.data_in(cmd_test),
		.data_out(oled_dat),
		.csn_out(oled_csn)
	);	

	
	always@(posedge clk_in or negedge rst_n_in)
		begin
			if(!rst_n_in)
				begin
					clk_spi <= 1'b0;
					count_spi <= 5'b0;
					oled_clk <= 1'b1;
				end
			else
				begin
					if(count_spi==SPI_CLK)
						begin
							count_spi <= 5'b0;
							clk_spi <= ~clk_spi;
							oled_clk <= ~oled_clk;
							
						end
					else
						begin
							count_spi <= count_spi+1;
						end
				end
		end
	
	reg [1:0]count_loop_1;
	reg [3:0]count_loop_2;
	reg [7:0]page_addr;
	
	always@(posedge clk_spi or negedge rst_n_in)
		begin
			if(!rst_n_in)
				begin
					count_sys <= 8'b0;
					spi_csn <= 1'b1;
					oled_dcn <= 1'b0;
					//oled_clk <= 1'b0;
					cmd_test <= 8'hAE;
					led <= 1'b0;
					start <= 1'b0;
					count_loop_1 <= 2'b0;
					count_loop_2 <= 4'b0;
					page_addr <= 8'hB0;
					rd_addr <= 9'b0;
					rd_en <= 1'b0;
				end
			else
				case(start)
					//ssd1306 initial cmd
					1'b0: begin
						case(count_sys)
							8'd0:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd8:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
									cmd_test <= 8'hA8;
								end
								
							8'd10:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd18:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
									cmd_test <= 8'h1F;
								end
							
							8'd20:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd28:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
									cmd_test <= 8'hDA;
								end
							8'd30:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd38:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
									cmd_test <= 8'h02;
								end
							
							8'd40:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd48:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
									cmd_test <= 8'h8D;
								end
							
							8'd50:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd58:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
									cmd_test <= 8'h14;
								end
							
							8'd60:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd68:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
									cmd_test <= 8'hAF;
								end
							
							8'd70:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b0;
									oled_dcn <= 1'b0;
								end
							8'd78:  begin
									count_sys <= count_sys+1;
									spi_csn <= 1'b1;
									oled_dcn <= 1'b0;
								end
							
							8'd80: begin
									start <= start+1;
									count_sys <= 8'b0;
								end
							default: begin
									count_sys <= count_sys+1;
								end
						endcase
					end
				1'b1: begin
					//display from ram
						case(count_loop_1)
							2'd0: begin
									case(count_loop_2)
										4'd0: begin
												cmd_test <= page_addr;
												spi_csn <= 1'b0;
												oled_dcn <= 1'b0;
												count_loop_2 <= count_loop_2+1;
											end
										4'd8: begin
												spi_csn <= 1'b1;
												count_loop_2 <= count_loop_2+1;
											end
										4'd10: begin
												count_loop_1 <= count_loop_1+1;
												count_loop_2 <= 4'd0;
											end
										default: begin
												count_loop_2 <= count_loop_2+1;
											end
									endcase
								end
							2'd1: begin
									case(count_loop_2)
										4'd0: begin
												cmd_test <= 8'h00;
												spi_csn <= 1'b0;
												oled_dcn <= 1'b0;
												count_loop_2 <= count_loop_2+1;
											end
										4'd8: begin
												spi_csn <= 1'b1;
												count_loop_2 <= count_loop_2+1;
											end
										4'd10: begin
												count_loop_1 <= count_loop_1+1;
												count_loop_2 <= 4'd0;
											end
										default: begin
												count_loop_2 <= count_loop_2+1;
											end
									endcase
								end
							2'd2: begin
									case(count_loop_2)
										4'd0: begin
												cmd_test <= 8'h10;
												spi_csn <= 1'b0;
												oled_dcn <= 1'b0;
												count_loop_2 <= count_loop_2+1;
											end
										4'd8: begin
												spi_csn <= 1'b1;
												count_loop_2 <= count_loop_2+1;
											end
										4'd10: begin
												count_loop_1 <= count_loop_1+1;
												count_loop_2 <= 4'd0;
												rd_addr[6:0] <= 7'b0;
											end
										default: begin
												count_loop_2 <= count_loop_2+1;
											end
									endcase
								end
							2'd3: begin
									case(count_sys)
										8'd128: begin
												count_sys <= 8'd0;
												page_addr[1:0] <= page_addr[1:0]+1;
												rd_addr[8:7] <= rd_addr[8:7]+1;
												rd_addr[6:0] <= 7'b0;
												count_loop_1 <= count_loop_1+1;
											end
										default: begin
												case(count_loop_2)
													4'd0: begin
															rd_en <= 1'b1;
															count_loop_2 <= count_loop_2+1;
														end
													4'd1: begin
															cmd_test <= rd_data;
															spi_csn <= 1'b0;
															oled_dcn <= 1'b1;
															count_loop_2 <= count_loop_2+1;
														end
													
													4'd9: begin
															spi_csn <= 1'b1;
															rd_en <= 1'b0;
															rd_addr[6:0] <= rd_addr[6:0]+1;
															count_loop_2 <= count_loop_2+1;
														end
													4'd10: begin
															count_sys <= count_sys+1;
															count_loop_2 <= 4'd0;
														end
													default: begin
															count_loop_2 <= count_loop_2+1;
														end
												endcase
											end
									endcase
								end
						endcase
					end
				endcase
		end

endmodule