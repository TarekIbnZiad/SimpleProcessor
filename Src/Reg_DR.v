module Reg_DR #(parameter p = 15) (clk, data_in, ld, inc, data_out);

// list of inputs 
input wire clk, ld, inc;
input wire [p:0] data_in;

// list of outputs
output reg [p:0] data_out;

// module implementation	
always @(posedge clk)
	begin
		if		(ld == 1'b1)	data_out = data_in;			      // load data in the register
		else if (inc == 1'b1)	data_out = data_out + 1'b1;	// increment the value in the register
	end
endmodule 