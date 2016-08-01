module sequencer(clk, clear, sequence);
  
  // list of parameters
  parameter [6:0] T0 = 7'b0000001,
                  T1 = 7'b0000010,
                  T2 = 7'b0000100,
                  T3 = 7'b0001000,
                  T4 = 7'b0010000,
                  T5 = 7'b0100000,
                  T6 = 7'b1000000;
  
  // list of inputs   
  input clk, clear;
  
  // list of outputs
  output reg [6:0] sequence;
  
  // list of internal variables
  reg [6:0] next_state;
  
  // module implementation
  always @(sequence, clear)
	begin
		if(clear == 1'b1)
			next_state = 7'b0000001;
		else
			begin
				case(sequence)
					T0: next_state = T1;
					T1: next_state = T2;
					T2: next_state = T3;
					T3: next_state = T4;
					T4: next_state = T5;
					T5: next_state = T6;
					T6: next_state = T0;
					default: next_state = T0;
				endcase
			end
	end
  
  always @(posedge clk)
	begin
		if(clear == 1'b1)	sequence <= 7'b0000001;	
		else				sequence <= next_state;
	end
endmodule 