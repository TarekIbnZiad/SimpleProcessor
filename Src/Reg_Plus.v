module Reg_Plus(clk, data_in, ld, clear, data_out);

// list of inputs
input wire clk, ld, clear;
input wire [3:0] data_in;

// list of outputs	
output reg [3:0] data_out;

// module implementation	
always @(posedge clk , posedge clear)
	begin
		if	     (clear == 1'b1)		data_out = 4'b0000;				// clear Plus
		else if (ld == 1'b1)		data_out = data_in; 					// load data in Plus
	end
endmodule 