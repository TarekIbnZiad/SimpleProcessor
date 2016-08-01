module memory(data_in, clk, r_wb, address, plus, enable, data_out);

// list of inputs
input [15:0] data_in;
input [11:0] address;
input clk;
input r_wb, enable; // r_wb -> read/writebar
input [3:0] plus;

// list of outputs
output reg [15:0] data_out;

// list of internal signals
wire [15:0] phy_address;
reg [15:0] ram [0:65535]; 

// module implementation
//initial  $readmemh("mem_seg.txt",ram); 
//initial   $readmemh("mem_IO.txt",ram); 
//initial   $readmemh("MEMORY.txt",ram); 
//initial  $readmemh("mem_error.txt",ram);
initial  $readmemh("final_memory.txt",ram);

assign phy_address = {plus,address};//may need for #delay to rearnge the code just in case

always@(posedge clk)
 begin  
  if((enable == 1'b1) && (r_wb == 1'b1))        data_out = ram[phy_address];  //read in memory
  else if((enable == 1'b1) && (r_wb == 1'b0))    ram[phy_address] = data_in;     // write from memory
  else             data_out = 16'bxxxxxxxxxxxxxxxx;      // no operation 
 end
 endmodule