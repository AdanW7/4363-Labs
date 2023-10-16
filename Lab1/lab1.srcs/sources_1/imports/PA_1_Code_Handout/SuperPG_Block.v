`timescale 1ns / 1ps

module SuperPG_Block(
       input[3:0] p,
       input[3:0] g,
       output[3:0] P,
       output[3:0] G
       );
    assign P = p[0]&p[1]&p[2]&p[3];
    assign G = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0];
endmodule
