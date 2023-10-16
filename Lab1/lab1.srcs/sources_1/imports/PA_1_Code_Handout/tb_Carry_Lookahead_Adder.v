`timescale 1ns / 1ps

module tb_Carry_Lookahead_Adder;
	// Inputs
	reg [3:0] A;
	reg [3:0] B;
	reg Cin;

	// Outputs
	wire Cout;
	wire [3:0] S;
	
	// For Testing
    integer i;
    integer j;
    integer k;
    integer result_test;
    reg flag_1;
    reg flag_2;
    integer total_correct;
    integer total_cases;

	// Instantiate the Unit Under Test (UUT)
	Carry_Lookahead_Adder uut (
		.A(A),
		.B(B),
		.Cin(Cin),
		.S(S),
		.Cout(Cout)
	);

	initial begin
    //Initialize
    total_correct=0;
    total_cases=0;

	// Add the test cases here
    for (i=0; i<=15; i=i+1) begin
      for (j=0;j<=15; j=j+1) begin
         for (k=0;k<=1; k=k+1) begin
              result_test=i+j+k;
              A=i;
              B=j;
              Cin=k;
              #1;
              flag_1=(result_test[3:0] == S);
              flag_2=(result_test[4] == Cout);
              #1;
              if (flag_1==1) begin
                 if (flag_2==1)begin
                    total_correct = total_correct + 1;
                 end
              end
              total_cases = total_cases + 1;
         end
      end
    end
           
       $display("The total correct cases for OR operation is %d\n", total_correct);
       $display("The total possible cases for OR operation is %d\n", total_cases);
       $display("Score is %e", (total_correct*10)/total_cases );  

	end
endmodule