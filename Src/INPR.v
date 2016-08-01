module INPR(clk,Data_IN,Data_OUT,flag,flag_reset);

input clk,flag_reset,Data_IN;
output Data_OUT,flag;
reg[7:0] Data_OUT;
wire[7:0] Data_IN;
reg flag;

always @(posedge clk)begin
	if(flag_reset)
		flag = 0;

	if(!flag && Data_OUT != Data_IN)begin
		flag = 1;
	end
	Data_OUT = Data_IN;
end
/*
always @(Data_IN)begin
	if(!flag)begin
		Data_OUT = Data_IN;
		flag = 1;
	end
end*/

endmodule
