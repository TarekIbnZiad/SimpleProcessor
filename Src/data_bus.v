module data_bus(sel, MEM_out, AR_out, PC_out, DR_out, AC_out, IR_out, bus, plus);

// list of inputs
input [3:0] plus;
input   [2:0]  sel;
input	[15:0] MEM_out;
input	[11:0] AR_out;
input	[11:0] PC_out;
input	[15:0] DR_out;
input	[15:0] AC_out;
input	[15:0] IR_out;

// list of outputs
output [15:0] bus;

// module implementation
assign bus = (sel == 3'b001) ? {4'bxxxx,AR_out}:  // bus opens for AR register
				 (sel == 3'b010) ? {plus,PC_out}:  // bus opens for PC register
				 (sel == 3'b011) ? (DR_out):    // bus opens for DR register
				 (sel == 3'b100) ? (AC_out):    // bus opens for AC register
				 (sel == 3'b101) ? (IR_out):    // bus opens for IR register
				 (sel == 3'b110) ? (MEM_out):   // bus opens for MEMORY
				  16'bxxxxxxxxxxxxxxxx;
endmodule 