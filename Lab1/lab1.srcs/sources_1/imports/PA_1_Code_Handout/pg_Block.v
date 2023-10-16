`timescale 1ns / 1ps

module pg_Block(
    input [3:0] A,
    input [3:0] B,
    output [3:0] p,
    output [3:0] g
    );
    assign p[0]= A[0] ^ B[0];
    assign p[1]= A[1] ^ B[1];
    assign p[2]= A[2] ^ B[2];
    assign p[3]= A[3] ^ B[3];
    
    assign g[0]= A[0]&B[0];
    assign g[1]= A[1]&B[1];
    assign g[2]= A[2]&B[2];
    assign g[3]= A[3]&B[3];

endmodule
