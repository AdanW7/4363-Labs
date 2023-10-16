`timescale 1ns / 1ps
module Carry_Lookahead_Adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout,
    output P,
    output G
    );
wire [3:0] p; //propagate values are stored here
wire [3:0] g; //generate values are stores
wire [3:0] C; //carry for each bit position
    assign C[0] = Cin;
    pg_Block        pg(A,B,p,g);
    SuperPG_Block   SuperPG(p,g,P,G);
    Carry_Block_1   CB1(C[1],p[3:0],g[3:0],C[0]);
    Carry_Block_2   CB2(C[2],p[3:0],g[3:0],C[0]);
    Carry_Block_3   CB3(C[3],p[3:0],g[3:0],C[0]);
    Carry_Block_4   CB4(Cout,p[3:0],g[3:0],C[0]);
    assign S[3:0] = C[3:0] ^ p[3:0];
endmodule