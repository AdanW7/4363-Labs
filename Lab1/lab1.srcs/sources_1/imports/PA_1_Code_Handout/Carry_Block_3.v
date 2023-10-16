`timescale 1ns / 1ps

module Carry_Block_3(
    output Cout,
    input [7:0] p,
    input [7:0] g,
    input Cin
    );
    assign Cout = g[2] | (p[2]&g[1]) | (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0]&Cin);

    
endmodule
