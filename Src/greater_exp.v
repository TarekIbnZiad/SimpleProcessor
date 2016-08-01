`timescale 1ns / 1ps
module addf(in1,in2,out
    );
input[15:0] in1,in2;//G_in the greater number in the exponent

output[15:0] out;
wire[15:0] g,s;
assign {g,s}=(in1[14]==in2[14])?((in1[13:10]>in2[13:10])?{in1,in2}:{in2,in1})
										 :((in1[14])				  ?{in2,in1}:{in1,in2});
add_fp u(g,s,out);
endmodule
