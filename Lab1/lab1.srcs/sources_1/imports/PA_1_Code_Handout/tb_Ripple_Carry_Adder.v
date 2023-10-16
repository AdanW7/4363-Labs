`timescale 1ns / 1ps

module tb_Ripple_Carry_Adder;

	// Inputs
	reg [7:0] A;
	reg [7:0] B;
	reg Cin;
	reg [1:0] control;

	// Outputs
	wire [7:0] result;
	wire Cout;
	
	
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
	Ripple_Carry_Adder uut (
		.A(A),
		.B(B),
		.Cin(Cin),
		.control(control),
		.Cout(Cout),
		.result(result)
	);


	initial begin
    //Initialize
    total_correct=0;
    total_cases=0;

    //ALUs should be doing addition
	control = 0;
    #1;

	// Add the test cases here
    for (i=0; i<=255; i=i+1)begin
      for (j=0;j<=255; j=j+1)begin
         for (k=0;k<=1; k=k+1)begin
              result_test=i+j+k;
              A=i;
              B=j;
              Cin=k;
              #1;
              flag_1=(result_test[7:0] == result);
              flag_2=(result_test[8] == Cout);
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

    end

endmodule

