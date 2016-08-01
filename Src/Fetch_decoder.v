module Fetch_decoder(IR_OPCODE, D);

// list of inputs
input [14:12] IR_OPCODE;

// list of outputs
output [7:0]D;

// module implementation
assign D = (IR_OPCODE == 3'b000)? 8'b00000001:
		     (IR_OPCODE == 3'b001)? 8'b00000010:
		     (IR_OPCODE == 3'b010)? 8'b00000100:
	   	  (IR_OPCODE == 3'b011)? 8'b00001000:
		     (IR_OPCODE == 3'b100)? 8'b00010000:
		     (IR_OPCODE == 3'b101)? 8'b00100000:
		     (IR_OPCODE == 3'b110)? 8'b01000000:
		      8'b10000000;
endmodule 