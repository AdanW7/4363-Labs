`timescale 1ns / 1ps

module Carry_Lookahead_16_Bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output [15:0] Cout
    );
    
    wire C1,C2,C3,C4;
    wire P0,P1,P2,P3,G0,G1,G2,G3;
    wire cout1,cout2,cout3,cout4;
    
    Carry_Lookahead_Adder CLA0 (
		.A(A[3:0]),
		.B(B[3:0]),
		.Cin(Cin),
		.S(S[3:0]),
		.Cout(cout0),
		.P(P0),
		.G(G0)
	);
	
    Carry_Lookahead_Adder CLA1 (
		.A(A[7:4]),
		.B(B[7:4]),
		.Cin(C1),
		.S(S[7:4]),
		.Cout(cout1),
		.P(P1),
		.G(G1)
	);
	
    Carry_Lookahead_Adder CLA2 (
		.A(A[11:8]),
		.B(B[11:8]),
		.Cin(C2),
		.S(S[11:8]),
		.Cout(cout2),
		.P(P2),
		.G(G2)
	);

    Carry_Lookahead_Adder CLA3 (
		.A(A[15:12]),
		.B(B[15:12]),
		.Cin(C3),
		.S(S[15:12]),
		.Cout(cout3),
		.P(P3),
		.G(G3)
	);
	
	//Uses super-propagates to calculate the carry values
	CarryOuts CO(
	    .C0(Cin),
	    .P0(P0),
		.P1(P1),
		.P2(P2),
		.P3(P3),
		.G0(G0),
		.G1(G1),
		.G2(G2),
		.G3(G3),
		.C1(C1),
		.C2(C2),
		.C3(C3),
		.C4(C4)
	);
	
	assign Cout = C4;
	
endmodule