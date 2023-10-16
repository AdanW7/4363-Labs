`timescale 1ns / 1ps
///////////////////////////////////////////////
module CarryOuts(
    input C0,
    input P0,
    input P1,
    input P2,
    input P3,
    input G0,
    input G1,
    input G2,
    input G3,
    output C1,
    output C2,
    output C3,
    output C4
    );    
    assign C1 = (P0&C0) | G0;
    assign C2 = (P0&P1&C0) | (P1&G0) | G1;
    assign C3 = (P0&P1&P2&C0) | (P1&P2&G0) | (P2&G1);
    assign C4 = (P0&P1&P2&P3&C0) | (P1&P2&P3&G0) | (P2&P3&G1) | (P3&G2);
endmodule
	
