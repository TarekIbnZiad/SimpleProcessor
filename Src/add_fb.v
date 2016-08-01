`timescale 1ns / 1ps
module add_fp(G_in,S_in,out
    );
input[15:0] G_in,S_in;//G_in the greater number in the exponent
output[15:0] out;


wire [4:0]diff;

shift_amount u(G_in[14:10],S_in[14:10],diff);
assign out=(G_in==0||S_in==0)?S_in|G_in:(G_in[15]==S_in[15])?{G_in[15:10],G_in[9:0]+(S_in[9:0]>>(diff))}
       :{(G_in[9:0]>(S_in[9:0]>>diff))?G_in[15]:S_in[15],G_in[14:10],(G_in[9:0]>(S_in[9:0]>>diff))?G_in[9:0]-(S_in[9:0]>>diff):(S_in[9:0]>>diff)-G_in[9:0]};

endmodule