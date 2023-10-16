`timescale 1ns / 1ps
module Ripple_Carry_Adder(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    input [1:0] control,
    
    output [7:0] result,
    output Cout
    );

wire [7:0] C;
One_Bit_ALU alu0(.A(A[0]), .B(B[0]), .Cin(Cin),  .control(control), .result(result[0]), .Cout(C[0]));
One_Bit_ALU alu1(.A(A[1]), .B(B[1]), .Cin(C[0]),.control(control), .result(result[1]), .Cout(C[1]));
One_Bit_ALU alu2(.A(A[2]), .B(B[2]), .Cin(C[1]),.control(control), .result(result[2]), .Cout(C[2]));
One_Bit_ALU alu3(.A(A[3]), .B(B[3]), .Cin(C[2]),.control(control), .result(result[3]), .Cout(C[3]));
One_Bit_ALU alu4(.A(A[4]), .B(B[4]), .Cin(C[3]),.control(control), .result(result[4]), .Cout(C[4]));
One_Bit_ALU alu5(.A(A[5]), .B(B[5]), .Cin(C[4]),.control(control), .result(result[5]), .Cout(C[5]));
One_Bit_ALU alu6(.A(A[6]), .B(B[6]), .Cin(C[5]),.control(control), .result(result[6]), .Cout(C[6]));
One_Bit_ALU alu7(.A(A[7]), .B(B[7]), .Cin(C[6]),.control(control), .result(result[7]), .Cout(C[7]));
assign Cout= C[7];
endmodule


