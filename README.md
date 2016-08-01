# SimpleProcessor
Designing and simulating a 16-bit Micro Processor using Verilog HDL.

The project was done as a part of CSE: undergraduate course at Faculty of Engineering, ASU. 

This project includes the design of a simple 16-bit Micro processor, and modeling of its components using Verilog HDL. This processor is NON-pipelined processor, including sequential blocks such as: registers and memory, and combinational blocks such as: ALU and control unit. Also, there are some complex blocks such as the data bus, has been modeled using behavioral approach, whereas some simple blocks such as: registers modules has been modeled using structural approach, and there are some mixed blocks as: Control unit which has been modeled using both behavioral and structural modeling.
	
This Processor has 2 Added Features , The first one is the input/output configuration and the other one is the memory segmentation So it can deal with a 64 K memory instead of 4 K using the same word size (16-bit).  

The tools used to implement this project are Xilinx ISE for digital simulation and synthesis and Plan Ahead for getting design layout. We used “Spartan6 – XC6SLX150” FPGA for synthesizing process, and the clock frequency we got was 136.179 MHz	

