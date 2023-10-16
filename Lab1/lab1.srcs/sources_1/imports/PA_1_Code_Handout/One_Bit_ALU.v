`timescale 1ns / 1ps
module One_Bit_ALU(
    input A,
    input B,
    input Cin,
    input [1:0] control,
    output reg result,
    output reg Cout
    );
    
always @ (control, A, B,Cin)
    begin
        case(control)
        0: // addition case
            begin
                assign result = A^B^Cin;
                assign Cout =  (A & B)|(A & Cin)|(B & Cin);
            end
        1: // and case
            begin
                 assign result = A&B;
                 assign Cout = 0;
            end
        
        2: //  or case
        
         begin
                 assign result = A|B;
                 assign Cout = 0;
            end

        endcase
    end
endmodule
