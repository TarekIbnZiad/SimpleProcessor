module Reg_PC #(parameter p = 15) (clk, data_in, ld, inc, clear, data_out,ld_reserved);

// list of inputs
input wire clk, ld, inc, clear,ld_reserved;
input wire [p:0] data_in;

// list of outputs	
output reg [p:0] data_out;

// module implementation	
always @(posedge clk , posedge clear)
	begin
		if	    (clear == 1'b1)		data_out = 0;				      // clear PC
		else if (ld == 1'b1)		data_out = data_in; 		         // load data in PC
		else if (inc == 1'b1)		data_out = data_out + 1'b1;	// increment data in PC
		else if (ld_reserved == 1'b1)		data_out = 12'b111111111110;	// load reserved addr
	end
endmodule 