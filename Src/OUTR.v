module OUTR(clk,ld,Data_IN,Data_OUT,flag,flag_set);

input clk,flag_set,Data_IN,ld;
output Data_OUT,flag;
reg[7:0] Data_OUT;
wire[7:0] Data_IN;
reg flag;

always @(posedge clk)begin

	if(flag_set)
		flag = 1;
		
	if(ld && flag)begin
		Data_OUT =Data_IN;
		flag = 0;
		end
end

endmodule
