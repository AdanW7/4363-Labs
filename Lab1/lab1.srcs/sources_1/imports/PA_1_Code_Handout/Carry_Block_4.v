`timescale 1ns / 1ps

module Carry_Block_4(
    output Cout,
    input [7:0] p,
    input [7:0] g,
    input Cin
    );

    assign Cout = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]) | (p[3]&p[2]&p[1]&p[0]&Cin);
endmodule
