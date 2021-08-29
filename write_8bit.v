module write_8bit(
	input csn_in,
	input clk,
	input [7:0]data_in,
	output data_out,
	output csn_out
);
	
	reg csn_out;
	reg data_out;
	reg [3:0]state;
	
	always@(posedge clk)
		begin
			if(csn_in)
				begin
					csn_out <= 1'b1;
					data_out <= 1'b0;
					state <= 4'b0;
				end
			else
				case(state)
					4'd0: begin
							csn_out <= 1'b0;
							data_out <= data_in[7];
							state <= state+1;
						end
					4'd1: begin
							data_out <= data_in[6];
							state <= state+1;
						end
					4'd2: begin
							data_out <= data_in[5];
							state <= state+1;
						end
					4'd3: begin
							data_out <= data_in[4];
							state <= state+1;
						end
					4'd4: begin
							data_out <= data_in[3];
							state <= state+1;
						end
					4'd5: begin
							data_out <= data_in[2];
							state <= state+1;
						end
					4'd6: begin
							data_out <= data_in[1];
							state <= state+1;
						end
					4'd7: begin
							data_out <= data_in[0];
							state <= state+1;
						end
					4'd8: begin
							csn_out <= 1'b1;
						end
				endcase
		end

endmodule