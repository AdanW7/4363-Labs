`timescale 1ns / 1ps

module execute(
    input bypassAfromMEM,
    input bypassAfromALUinWB,
    input bypassAfromLWinWB,
    input bypassBfromMEM,
    input bypassBfromALUinWB,
    input bypassBfromLWinWB,
    input clk,
    input  [31:0] IDEXIR,
    input [31:0] IDEXA,
    input [31:0] IDEXB,
    input [31:0] MEMWBValue,
    output reg [31:0] EXMEMB,
    output reg [31:0] EXMEMIR,
    output reg [31:0] EXMEMALUOut
    );
    
 `include "parameters.sv"
    
 wire [31:0] Ain;
 wire [31:0] Bin;   
 wire [5:0] IDEXop;
 
 assign IDEXop = IDEXIR[31:26];
    
 forward FWDTOEX(
     .bypassAfromMEM(bypassAfromMEM),
     .bypassAfromALUinWB(bypassAfromALUinWB),
     .bypassAfromLWinWB(bypassAfromLWinWB),
     .bypassBfromMEM(bypassBfromMEM),
     .bypassBfromALUinWB(bypassBfromALUinWB),
     .bypassBfromLWinWB(bypassBfromLWinWB),
     .IDEXA(IDEXA),
     .IDEXB(IDEXB),
     .MEMWBValue(MEMWBValue),
     .EXMEMALUOut(EXMEMALUOut),
     .Ain(Ain),
     .Bin(Bin)
    );
    
   initial begin
     EXMEMB = 0;
     EXMEMIR = 0;
     EXMEMALUOut = 0;
   end
    
     always @(posedge clk)begin
              if ((IDEXop==LW) |(IDEXop==SW)) begin // address calculation & copy B
                   //$display("Received a load/store instruction");
                   EXMEMALUOut <= Ain +{{16{IDEXIR[15]}}, IDEXIR[15:0]};
                   EXMEMIR <= IDEXIR; EXMEMB <= Bin; //pass along the IR & B register
              end
              else if (IDEXop==ALUop) begin
                case (IDEXIR[5:0]) //case for the various R-type instructions
                
//                ADD performs the operation R[rd] = R[rs]+r[rt] (already implemented)
//                XOR performs the operations R[rd] = (R[rs] ^ R[rt])
//                NAND performs the operations R[rd] = (~(R[rs] & R[rt]))
//                SGT performs the operation R[rd] = (R[rs] > R[rt])
//                SRL performs the operation R[rd] = (R[rs] >> R[rt])
//                problem 0 change EX stage
                       32: begin //add
                              EXMEMALUOut <= Ain + Bin;  //add operation
                           end
                                                                         
                       50: begin //xor
                                EXMEMALUOut <= (Ain ^ Bin);
                           end
                           
                       51: begin //Nand
                                EXMEMALUOut <= (~(Ain & Bin));
                           end 
                           
                       52: begin //sgt
                                EXMEMALUOut <= (Ain > Bin);
                           end 
                           
                       53: begin //srl
                                EXMEMALUOut <= (Ain >> Bin);
                           end
                            
                       default: ; //other R-type operations: subtract, SLT, etc.
                     endcase
                     EXMEMIR <= IDEXIR; //pass along the IR & B register
              end 
              //problem 1 conditional inrement decrement
              else if (IDEXop==CINDC) begin //cind == opcode 47
              
                         if (Ain > 0) begin 
                             //TODO Assign Ain - Bin to EXMEMALUOut
                             EXMEMALUOut <= Ain - Bin;
                         end
                         else begin
                             //TODO Assign Ain + Bin to EXMEMALUOut
                             EXMEMALUOut <= Ain + Bin;
                         end  
                         EXMEMIR <= IDEXIR; //pass along the IR & B register
              end           
              else if (IDEXop==BEQINIT) begin //opcode 48
                        // Do n
                        EXMEMIR <= IDEXIR;
              end
       end
endmodule
