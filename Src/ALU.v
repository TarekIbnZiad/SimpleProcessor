module ALU(AC_OUT, DR_OUT, E_OUT, sel, ALU_RESULT, E_RESULT,INPR,float_flag);

// list of inputs
input [15:0] AC_OUT, DR_OUT;
input E_OUT;
input [1:0] sel;
input [7:0] INPR;
input float_flag;
// list of outputs
output [15:0] ALU_RESULT;
output E_RESULT;
wire [15:0]float_out;
// module implementation
addf addf(.in1(AC_OUT) ,.in2(DR_OUT) ,.out(float_out));//(in1,in2,out
assign {E_RESULT, ALU_RESULT} = (float_flag==1)?{1'b0,float_out}:
										  (sel==2'b00)?({E_OUT, AC_OUT & DR_OUT}):   //and
										  (sel==2'b01)?(AC_OUT + DR_OUT):    			//add
                                (sel==2'b10)?({E_OUT, DR_OUT}):       		//DR->AC transition
                                ({E_OUT,8'b0,INPR});           				//AC transition
										  
endmodule 