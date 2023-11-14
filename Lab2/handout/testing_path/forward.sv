`timescale 1ns / 1ps

module forward(
    input bypassAfromMEM,
    input bypassAfromALUinWB,
    input bypassAfromLWinWB,
    input bypassBfromMEM,
    input bypassBfromALUinWB,
    input bypassBfromLWinWB,
    input [31:0] IDEXA,
    input [31:0] IDEXB,
    input [31:0] MEMWBValue,
    input [31:0] EXMEMALUOut,
    
    output reg [31:0] Ain,
    output reg [31:0] Bin
    );
    reg [31:0] tempA;
    reg [31:0] tempB;
    always @* begin
        //Ain 
        if(bypassAfromALUinWB || bypassAfromLWinWB)begin
            tempA<=MEMWBValue;
        end
        else begin
            tempA<=IDEXA;
        end
        if(bypassBfromMEM) begin
            Ain<=EXMEMALUOut;
        end
        else begin
            Ain<=tempA;
        end
        
        //Bin
        if(bypassBfromALUinWB || bypassBfromLWinWB)begin
            tempB<=MEMWBValue;
        end
        else begin
            tempB<=IDEXB;
        end
        if(bypassBfromMEM) begin
            Bin<=EXMEMALUOut;
        end
        else begin
            Bin<=tempB;
        end
    
    
    end
endmodule
