module Reg_IR(clk, data_in, ld, data_out);

// list of inputs
input wire clk, ld;
input wire [15:0] data_in;

// list of outputs
output reg [15:0] data_out;

// module implementation
always @(posedge clk)
	begin
		if(ld == 1'b1)	data_out = data_in;		// load data in IR
	end
endmodule