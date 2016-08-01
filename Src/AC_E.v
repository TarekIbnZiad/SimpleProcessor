module AC_E(clk, data_in, ld, inc, clr, E_IN, CMA, CME, CIR, CIL, CLE, E_OUT, data_out);

// list of inputs
input clk, ld, inc, clr, E_IN, CMA, CME, CIR, CIL, CLE;
input [15:0] data_in;

// list of outputs
output reg E_OUT;
output reg [15:0] data_out;

// module implementation
always @(posedge clk)
	begin
		if	    (clr == 1'b1)	    data_out = 0;												               // clear AC
		else if (ld == 1'b1)		{E_OUT, data_out} = {E_IN, data_in};						         // load data in AC
		else if (inc == 1'b1)		{E_OUT, data_out} = {E_OUT,data_out+1'b1};						// increment the value in AC
		else if (CMA == 1'b1)		data_out = ~data_out;										         // complement AC
		else if (CME == 1'b1)		E_OUT = ~E_OUT;												         // complement the extension bit
		else if (CLE == 1'b1)		E_OUT = 0;													            // clear the extension bit
		else if (CIR == 1'b1)		{E_OUT, data_out} = {data_out[0], E_OUT, data_out[15:1]};	// circulate right
		else if (CIL == 1'b1)		{E_OUT, data_out} = {data_out[15], data_out[14:0], E_OUT};	// circulate left 
	end
endmodule 