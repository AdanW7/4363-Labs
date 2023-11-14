`timescale 1ns / 1ps

module pcr(
     input clk,
     input branchTaken,
     input stall,
     input [31:0] branchPCOffset,
     output reg [31:0] PC
    );
    
    initial
    begin
        PC = 0;
    end
    
    always @(posedge clk)
    begin
        if (branchTaken  && !stall ) begin //branch taken only happens when branchtaken signal is high and stall signal is low.
               PC <= PC + branchPCOffset;
          end
          else if (stall) begin // if there is a Load Use Hazard, then stall
             PC <= PC;
          end
          else begin
             PC <= PC + 4;
          end
     end
     
endmodule
