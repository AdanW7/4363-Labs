`timescale 1ns / 1ps

module Carry_Block_1(
    output Cout,
    input [7:0] p,
    input [7:0] g,
    input Cin
    );
   
   
    assign Cout = g[0]|(p[0]&Cin);

    
endmodule


