`timescale 1ns / 1ps
module shift_amount(in1,in2,out
    );
input[4:0] in1,in2;//test if you need it letterly
output[4:0]out;
assign out={1'b0,(in1[3:0]-in2[3:0])};//(in1[4]==in2[4])?(in1[3:0]-in2[3:0]):
				
endmodule
