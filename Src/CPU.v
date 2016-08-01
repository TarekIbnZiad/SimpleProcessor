module CPU(E_OUT, AC_Out, clock, reset, INP, OUTR, Out_flag_set, error_address, wrong_instruction_flag);


// list of inputs 
input clock, reset, INP, Out_flag_set;

// list of outputs
output wire [15:0] AC_Out;
output wire E_OUT;
output wire [7:0] OUTR;
output wire [15:0] error_address;
output wire wrong_instruction_flag;

// list of internal signals
wire E_IN, r_wb, Mem_enable, Seq_Clr, E_RESET, E_COMP;
wire [7:0] D;
wire [6:0] T;
wire [9:0]ld;		// load of registers
wire [3:0]inc;		// increment of registers
wire [2:0]clr; 	// clear of registers
wire [2:0]sel; 	// control of data-bus 
wire [15:0] ALU_Out, DR_Out, IR_Out, Mem_Out,Bus_Out;
wire [11:0] PC_Out, AR_Out;
wire [4:0] p; 		// for combinations of ALU control
wire [3:0] Plus_Out;
wire [1:0] OP_TO_ALU;
wire [7:0] INP,INPR_out;//INP input from top module INPR_out input to ALU
wire inp_flag_reset,inp_flag,out_flag;
wire clock1, clock2;
wire float_flag;
buf #1 (clock1,clock);
buf #1 (clock2,clock1);

assign wrong_instruction_flag = ld[7];

// module implementation
data_bus DataBus( .sel(sel), .MEM_out(Mem_Out), .AR_out(AR_Out), .PC_out(PC_Out), .DR_out(DR_Out), .AC_out(AC_Out), .IR_out(IR_Out), .bus(Bus_Out), .plus(Plus_Out));	// DataBus instance 

top_control_unit ControUnit( .D(D), .T(T), .B(IR_Out[11:0]), .I(IR_Out[15]), .E(E_OUT), .DR(DR_Out), 
									  .AC(AC_Out), .ld(ld), .clr(clr), .inc(inc), .r_wb(r_wb), .enable(Mem_enable), 
									  .sel(sel), .seq_clr(Seq_Clr), .glb_clr(reset), .E_RESET(E_RESET), .E_COMP(E_COMP), 
									  .p(p), .ALU_OP(OP_TO_ALU), .inp_flag_reset(inp_flag_reset), 
									  .inp_flag(inp_flag), .out_flag(out_flag),.float_flag(float_flag)); 							// control unit instance

Fetch_decoder FetchAndDecode( .IR_OPCODE(IR_Out[14:12]), .D(D));		    							// fetch decoder instance

sequencer Seq( .clk(clock), .clear(Seq_Clr), .sequence(T) );											// sequencer instance

memory Mem( .data_in(Bus_Out), .clk(clock1), .data_out(Mem_Out), .r_wb(r_wb), .address(AR_Out), .plus(Plus_Out), .enable(Mem_enable) );    // memory instance
			   						    
Reg_PC    #(11) PC( .clk(clock2), .data_in(Bus_Out[11:0]), .ld(ld[0]), .inc(inc[0]), .clear(clr[0]), .data_out(PC_Out),.ld_reserved(ld[9]) );								// PC instance	
Reg_DR #(15) DR( .clk(clock2), .data_in(Bus_Out),       .ld(ld[1]), .inc(inc[1]), .data_out(DR_Out) );														// DR instance
Reg_IR          IR( .clk(clock2), .data_in(Bus_Out),       .ld(ld[2]), .data_out(IR_Out));																	// IR instance
Reg_AR #(11) AR( .clk(clock2), .data_in(Bus_Out[11:0]), .ld(ld[3]), .inc(inc[2]), .data_out(AR_Out),.ld_reserved(ld[8]));
Reg_Plus      Plus( .clk(clock2), .data_in(Bus_Out[15:12]), .ld(ld[6]), .clear(clr[2]), .data_out(Plus_Out));												// AR instance

AC_E AC( .clk(clock2), .data_in(ALU_Out), .ld(ld[4]), .inc(inc[3]), .clr(clr[1]), 
		 .E_IN(E_IN), .CMA(p[2]), .CME(E_COMP), .CIR(p[0]), .CIL(p[1]), 
		 .CLE(E_RESET), .E_OUT(E_OUT), .data_out(AC_Out)); 																								// AC instance
		 
error wrong_address(.clk(clock2), .data_in(Bus_Out), .ld(ld[7]), .glb_clear(reset), .data_out(error_address));					// Wrong instruction address
		 
ALU ALU( .ALU_RESULT(ALU_Out), .E_OUT(E_OUT), .E_RESULT(E_IN), .AC_OUT(AC_Out), .DR_OUT(DR_Out), .sel(OP_TO_ALU),.INPR(INPR_out),.float_flag(float_flag)); 		// ALU instance

INPR inpr(.clk(clock2),.Data_IN(INP),.Data_OUT(INPR_out),.flag(inp_flag),.flag_reset(inp_flag_reset));
OUTR outr(.clk(clock2),.ld(ld[5]),.Data_IN(Bus_Out[7:0]),.Data_OUT(OUTR),.flag(out_flag),.flag_set(Out_flag_set | reset));

endmodule 
