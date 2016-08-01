module top_control_unit(D, T, B, I, E, p, DR, AC, ld, clr, inc, r_wb, enable, sel, seq_clr, glb_clr, E_RESET, E_COMP, ALU_OP,inp_flag_reset,inp_flag,out_flag,float_flag);

// list of inputs 
input [7:0] D;
input [6:0] T;
input [11:0] B;
input I, E, glb_clr;
input [15:0] DR;
input [15:0] AC;
input inp_flag; //input flag
input out_flag; //out flag

// list of outputs
output [9:0] ld; 		 	    // all regs  ld[8] to load reserved addr of AR and ld[9] to load reserved addr of AR 
output [2:0] clr; 		 	 // AC
output [3:0] inc; 			 // all except IR
output [4:0] p; 			    // for ALU control
output reg r_wb,enable;  	 // controls of memory
output [2:0] sel; 	 	 	 // control of data-bus
output wire seq_clr; 	 	 // clearing of sequencer
output E_RESET, E_COMP;		 // for E control in ALU
output [1:0] ALU_OP;
output inp_flag_reset; 		 // input flag reset
output float_flag;

//float_flag
assign float_flag=D[7]&I&B[5];

// list of internal signals
wire [4:0] W,y;
wire [5:0] x; 
wire r,DIT;
wire wrong_inst;
wire error_halt;

reg R , IEN , R1; //two flip flop R: choose instruction or interrupt  IEN: interrupt enable 

assign ALU_OP = (D[0])?2'b00:
					 (D[1])?2'b01:
					 (D[2])?2'b10:   //DR transition
					  2'b11; 	     //AC transition

// module implementation
assign r = (~I & D[7] & T[3]);  // definiation of r
assign DIT = I & D[7] & T[3] ;
assign wrong_inst = (D[7]&(((B[0]+B[1]+B[2]+B[3]+B[4]+B[5]+B[6]+B[7]+B[8]+B[9]+B[10]+B[11])!=1) | (I&(|B[4:0]))))? 1'b1:1'b0;

assign error_halt = D[7] & wrong_inst;

// control of pc 		
assign W[0] = (AC == 0) ? 1'b1 : 1'b0 ;					
assign y[0] = (B[2] & r & W[0]);
assign W[1] = (E == 0 ) ? 1'b1 : 1'b0 ;
assign y[1] = (B[1] & r & W[1]);
assign W[2] = (AC[15] == 1 ) ? 1'b1 : 1'b0 ;
assign y[2] = (B[3] & r & W[2]);
assign W[3] = ((AC[15] == 0) && (AC[14:0]!=0)) ? 1'b1 : 1'b0 ;
assign y[3] = (B[4] & r & W[3]);
assign W[4] = (DR == 0) ? 1'b1 : 1'b0 ;
assign y[4] = (D[6] & T[6] & W[4]);

assign inc[0] = ((~R&T[1]) | y[0] | y[1] | y[2] | y[3] | y[4] | (DIT&B[9]&inp_flag) | (DIT&B[8]&out_flag) | R1|(D[7]&I&B[5]&T[6]));// inc[0] for PC increment
assign ld[0] = ((T[4] & D[4]) | (T[6] & D[5])); 	    												            // ld[0] for PC load
assign clr[0] = (glb_clr) | (D[7] & I & T[3] & B[4]); 															   // clr[0] for PC clear
assign ld[9] = R & T[1];

// control of DR
assign ld[1] = ((T[4]&D[0]) | (T[4]&D[1]) | (T[4]&D[2]) | (T[4]&D[6])| (T[4]&D[3]) | (T[4]&D[5]) | (R&T[0])|(D[7]&I&B[5]&T[5]));     // ld[1] for DR load
assign inc[1] = (T[5] & D[6]);						 														             // inc[1] for DR increment

//control of IR
assign ld[2] = ~R&T[1]; // ld[2] for IR load 

//control of AR 
assign ld[3] = ((~R&T[0]) | (~R&T[2]) | (!D[7] & I & T[3])|(D[7]&I&B[5]&T[3])|(D[7]&I&B[5]&T[4])); // ld[3] for AR load
assign inc[2] = (D[5] & T[5]); 					   // inc[2] for AR increment
assign ld[8] = R&T[0];

// control of AC
assign clr[1] = (r & B[11]);    						          // clr for AC clear
assign inc[3] = (r & B[5]);  							          // inc for AC increment
assign ld[4] = (T[5] & (D[0] | D[1] | D[2]) | DIT&B[11]|(D[7]&I&B[5]&T[6])); // ld for AC load

//control of Plus
assign ld[6] = (I&D[4]&T[3]) ; // ld[6] for Plus load 
assign clr[2] = glb_clr;                 //clr[2] for Plus clear

// control of error
assign ld[7] = (error_halt & (~R&T[0]));

//control of memory
always @(T,D,I,R)
	begin
		r_wb = 0;
		enable = 0;
		if ((D[3] && T[5])||(D[5] && T[5])||(D[6] && T[6])||(R && T[1]))
			begin
				r_wb = 0;
				enable = 1;
			end
		else if ((~R&T[1])||(!D[7] && I && T[3])||(D[0] && T[4])||(D[1] && T[4])||(D[2] && T[4])||(D[6] && T[4])||(D[7]&&I&&B[5]&&T[4])||(D[7]&&I&&B[5]&&T[5]))
			begin
				r_wb = 1;
				enable = 1;
			end
		else 
			enable = 0;
	end				

// control of encoder of data bus 
	 assign x[0] = ((D[4] & T[4]) | (D[5] & T[6])); 								           // AR
	 assign x[1] = ((D[5] & T[4]) | (~R&T[0]) | (D[7] & T[3] & wrong_inst) | (R&T[0])|(D[7]&I&B[5]&T[3]));		  // PC
	 assign x[2] = ((D[2] & T[5]) | (D[3] & T[5]) | (D[5] & T[5]) |(D[6] & T[6]) | (R&T[1]));  // DR
	 assign x[3] = (D[3] & T[4] | ( DIT & B[10] & !wrong_inst ));							  // AC
	 assign x[4] = ~R&T[2];															                    // IR
	 assign x[5] = ((~D[7] & I & T[3]) | (T[4] & (D[0] | D[1] | D[2] | D[6])) | (~R&T[1])|(D[7]&I&B[5]&T[4])|(D[7]&I&B[5]&T[5])); // MEM
	
	 assign sel = (x[0]) ? (3'b001):
				     (x[1]) ? (3'b010):
				     (x[2]) ? (3'b011):
				     (x[3]) ? (3'b100):
                 (x[4]) ? (3'b101):
                 (x[5]) ? (3'b110):
                  3'b000; 

// control of sequencer
	assign seq_clr = ((T[5] & (D[0] | D[1] | D[2] | D[3])) |
					  (D[4] & T[4]) | (T[6] & (D[5] | D[6])) | 
					  (((~I)&(D[7])) & B[0]) | (r & (B[1] | B[2] | B[3] | B[4] | B[5] | B[6] | B[7] | B[8] | B[9] | B[10] | B[11]))
					  | glb_clr |  DIT&(B[11]|B[10]|B[9]|B[8]|B[7]|B[6]) | (D[7] & I & T[3] & B[4]) | ld[7] | (error_halt & ((~R&T[0]) | T[3])) | R1|(D[7]&I&B[5]&T[6]));

// control of INPR
	assign inp_flag_reset = ((DIT & B[11]) | glb_clr);
	
// control of OUTR
	assign ld[5] = DIT & B[10];		 // ld[5] for OUTR

// control of R
	always @(T,R,R1,glb_clr,IEN,inp_flag,out_flag)begin
		if( (~T[0]&~T[1]&~T[2]) & IEN & (inp_flag|out_flag))	R =1'b1;
		else if(R&T[2])begin   //#11 R =0;
			R = 1'b0;
			R1 = 1'b1;
		end
		else if(glb_clr)	R =1'b0;
		else if(T[0])	R1 =1'b0;
	end
// control of IEN
	always @(T,D,I,B,R1,glb_clr,DIT,IEN)begin		
		if(DIT&B[7])			IEN =1'b1;
		else if(DIT&B[6])		IEN =1'b0;
		else if(R1)				IEN =1'b0;
		else if(glb_clr)		IEN =1'b0;
	end 
// control of ALU
	assign E_RESET = (r & B[10]);    //  CLE		
	assign E_COMP  = (r & B[8]);     //  CME		
	assign p[0]    = (r & B[7]);     //  CIR
	assign p[1]    = (r & B[6]);     //  CIL
	assign p[2]    = (r & B[9]); 	   //  CMA		
	assign p[3]    = (D[0] & T[5]);  //  AND	
	assign p[4]    = (D[1] & T[5]);  //  ADD
	
endmodule 
