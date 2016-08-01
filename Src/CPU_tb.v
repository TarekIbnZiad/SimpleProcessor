module CPU_tb;

	// Inputs
	reg clock;
	reg reset;
	reg Out_flag_set;
	reg[7:0] INP;

	// Outputs
	wire E;
	wire [15:0] AC;
	wire [7:0] OUTR;
	wire [15:0] error_address;
	wire wrong_instruction_flag;


	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.E_OUT(E), 
		.AC_Out(AC),
		.clock(clock), 
		.reset(reset),
		.INP(INP),
		.OUTR(OUTR),
		.Out_flag_set(Out_flag_set),
		.error_address(error_address),
		.wrong_instruction_flag(wrong_instruction_flag)
	);

	initial begin

		clock = 0;
		reset = 1;
		INP = 0;
		
		#12 reset = 0;
       
		#1200; 
		#400 INP = 127;
		#150 INP = 25;
		#200 Out_flag_set =1;
		#200 Out_flag_set =0;
		#750 INP = 240;
		#500 INP = 10;

	end
	always begin
		#5 clock = ~clock;
	end
      
endmodule
