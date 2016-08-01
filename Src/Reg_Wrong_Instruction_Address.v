module error(clk, data_in, ld, glb_clear, data_out);
	input wire clk, ld, glb_clear;
	input wire [15:0] data_in;
	output reg [15:0] data_out;
	
	always @(posedge clk) begin
		if(glb_clear == 1'b1)
			data_out = 16'd0;
		else if(ld == 1'b1)
			data_out = data_in - 16'b0000000000000001;
	end

endmodule
