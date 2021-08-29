module volt_display(
	input clk_in,
	input rst_n_in,
	input [7:0]BCD,
	output wr_en,
	output [8:0]wr_addr,
	output [7:0]wr_data	
);
	
	reg [127:0]oled_num [9:0];
	reg [127:0]oled_O;
	reg [127:0]oled_L;
	reg [127:0]oled_E;
	reg [127:0]oled_A;
	reg [127:0]oled_D;
	reg [127:0]oled_C;
	reg [127:0]oled_dot;
	reg [127:0]oled_v;
	
	reg [7:0]wr_data;
	reg [8:0]wr_addr;
	reg wr_en;

	reg start;
	reg [6:0]index;
	reg [3:0]state;
	reg [1:0]loop_1;
	reg [4:0]loop_2;
	reg [1:0]loop_3;
	reg [8:0]add;
	reg [127:0]data_display;
	
	always@(posedge clk_in or negedge rst_n_in)
		begin
			if(!rst_n_in)
				begin
					start <= 1'b0;
					
					wr_en <= 1'b0;
					wr_data <= 8'b0;
					wr_addr <= 9'b0;					

					oled_num[0] <= 128'hF00FF81F081288114810F81FF00F0000;
					oled_num[1] <= 128'h000020103010F81FF81F001000100000;
					oled_num[2] <= 128'h101C181E08138811C810781830180000;
					oled_num[3] <= 128'h10081818881088108810F81F700F0000;
					oled_num[4] <= 128'h8001C00160013011F81FF81F00110000;
					oled_num[5] <= 128'hF808F818881088108811881F080F0000;
					oled_num[6] <= 128'hE00FF01F981088108810801F000F0000;
					oled_num[7] <= 128'h18001800081E081F8801F80078000000;
					oled_num[8] <= 128'h700FF81F881088108810F81F700F0000;
					oled_num[9] <= 128'h7000F810881088108818F80FF0070000;
					
					oled_O <= 128'hE007F00F181808101818F00FE0070000;
					oled_L <= 128'h0810F81FF81F081000100018001C0000;
					oled_E <= 128'h0810F81FF81F8810C8111818381C0000;
					oled_A <= 128'hC01FE01F300118013001E01FC01F0000;
					oled_D <= 128'h0810F81FF81F08101818F00FE0070000;
					oled_C <= 128'hE007F00F1818081008101818300C0000;
					oled_dot <= 128'h00000000000000180018000000000000;
					oled_v <= 128'h0000C007C00F00180018C00FC0070000;
					
					index <= 7'b0;
					state <= 4'b0;
					loop_1 <= 2'b0;
					loop_2 <= 5'b0;
					loop_3 <= 2'b0;
					data_display <= 128'b0;
					add <= 9'b0_0000_0001;
				end
			else
				if(!start)
					//initial display
					begin
						case(loop_1)
							2'd0: begin
									case(state)
										4'd0: begin
												data_display <= oled_O;
												wr_addr <= 9'd344;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												loop_2 <= 5'b0;
												add <= 9'b0_0000_0001;
											end
										4'd1: begin
												data_display <= oled_L;
												wr_addr <= 9'd336;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd2: begin
												data_display <= oled_E;
												wr_addr <= 9'd328;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd3: begin
												data_display <= oled_D;
												wr_addr <= 9'd320;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd4: begin
												data_display <= oled_A;
												wr_addr <= 9'd304;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd5: begin
												data_display <= oled_D;
												wr_addr <= 9'd296;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd6: begin
												data_display <= oled_C;
												wr_addr <= 9'd288;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd7: begin
												data_display <= oled_dot;
												wr_addr <= 9'd64;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd8: begin
												data_display <= oled_v;
												wr_addr <= 9'd48;
												index <= 7'd0;
												state <= state+1;
												loop_1 <= loop_1+1;
												add <= 9'b0_0000_0001;
											end
										4'd9: begin
												state <= 4'd0;
												loop_1 <= 2'd0;
												loop_2 <= 5'd0;
												loop_3 <= 2'b0;
												index <= 7'd0;
												start <= 1'b1;
												add <= 9'b0_0000_0001;
											end
									endcase
								end
							2'd1: begin
									//write 128 bits in ram, according to address
									case(loop_2)
										5'd16: begin
												loop_2 <= 5'd0;
												loop_1 <= 2'd0;
												index <= 7'd0;
												add <= 9'b0_0000_0001;
												//start <= 1'b1;
											end
										default: begin
												case(loop_3)
													2'd0: begin
															
															wr_data[7] <= data_display[index];
															wr_data[6] <= data_display[index+1];
															wr_data[5] <= data_display[index+2];
															wr_data[4] <= data_display[index+3];
															wr_data[3] <= data_display[index+4];
															wr_data[2] <= data_display[index+5];
															wr_data[1] <= data_display[index+6];
															wr_data[0] <= data_display[index+7];
															
															wr_en <= 1'b1;
															add[0] <= ~add[0];
															loop_3 <= loop_3+1;
														end
													2'd1: begin
															loop_3 <= loop_3+1;
														end
													2'd2: begin
															wr_en <= 1'b0;
															loop_3 <= loop_3+1;
														end
													2'd3: begin
															wr_addr[7] <= wr_addr[7]+1;
															wr_addr[6:0] <= wr_addr[6:0]+add[6:0];
															index <= index+8;
															loop_3 <= loop_3+1;
															loop_2 <= loop_2+1;
														end
												endcase
											end
										
									endcase
								end
						endcase	
					end
				else
					//update real-time voltage
					begin
						case(loop_1)
							2'd0: begin
									data_display <= oled_num[BCD[7:4]];
									wr_addr <= 9'd72;
									add <= 1'b0;
									loop_1 <= loop_1+1;
									loop_2 <= 5'd0;
									loop_3 <= 2'd0;
									index <= 7'd0;
								end
							2'd1: begin
									case(loop_2)
										5'd16: begin
												loop_2 <= 5'd0;
												loop_1 <= loop_1+1;
												index <= 7'd0;
											end
										default: begin
												case(loop_3)
													2'd0: begin
															wr_data[7] <= data_display[index];
															wr_data[6] <= data_display[index+1];
															wr_data[5] <= data_display[index+2];
															wr_data[4] <= data_display[index+3];
															wr_data[3] <= data_display[index+4];
															wr_data[2] <= data_display[index+5];
															wr_data[1] <= data_display[index+6];
															wr_data[0] <= data_display[index+7];
															wr_en <= 1'b1;
															add[0] <= ~add[0];
															loop_3 <= loop_3+1;
														end
													2'd1: begin
															loop_3 <= loop_3+1;
														end
													2'd2: begin
															wr_en <= 1'b0;
															loop_3 <= loop_3+1;
														end
													2'd3: begin
															wr_addr[7] <= wr_addr[7]+1;
															wr_addr[6:0] <= wr_addr[6:0]+add[6:0];
															index <= index+8;
															loop_3 <= loop_3+1;
															loop_2 <= loop_2+1;
														end
												endcase
											end
									endcase
								end
								2'd2: begin
									data_display <= oled_num[BCD[3:0]];
									wr_addr <= 9'd56;
									add <= 1'b0;
									loop_1 <= loop_1+1;
									loop_2 <= 5'd0;
									loop_3 <= 2'd0;
									index <= 7'd0;
								end
								2'd3: begin
									case(loop_2)
										5'd16: begin
												loop_2 <= 5'd0;
												loop_1 <= loop_1+1;
												index <= 9'd0;
											end
										default: begin
												case(loop_3)
													2'd0: begin
															wr_data[7] <= data_display[index];
															wr_data[6] <= data_display[index+1];
															wr_data[5] <= data_display[index+2];
															wr_data[4] <= data_display[index+3];
															wr_data[3] <= data_display[index+4];
															wr_data[2] <= data_display[index+5];
															wr_data[1] <= data_display[index+6];
															wr_data[0] <= data_display[index+7];
															wr_en <= 1'b1;
															add[0] <= ~add[0];
															loop_3 <= loop_3+1;
														end
													2'd1: begin
															loop_3 <= loop_3+1;
														end
													2'd2: begin
															wr_en <= 1'b0;
															loop_3 <= loop_3+1;
														end
													2'd3: begin
															wr_addr[7] <= wr_addr[7]+1;
															wr_addr[6:0] <= wr_addr[6:0]+add[6:0];
															index <= index+8;
															loop_3 <= loop_3+1;
															loop_2 <= loop_2+1;
														end
												endcase
											end
									endcase
								end
						endcase
					end
					
		end


endmodule