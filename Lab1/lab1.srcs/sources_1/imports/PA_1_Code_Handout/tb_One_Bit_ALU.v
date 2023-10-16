`timescale 1ns / 1ps

module tb_One_Bit_ALU;
	// Inputs
	reg A;
	reg B;
	reg Cin;
	reg [1:0] control;

	// Outputs
	wire Cout;
	wire result;

    //For Testing
    reg[1:0] i;
    reg[1:0] j;
    reg[1:0] k;
    integer result_test;
    reg flag_1;
    reg flag_2;
    real total_correct;
    real total_cases;

	// Instantiate the Unit Under Test (UUT)
	One_Bit_ALU uut (
		.A(A),
		.B(B),
		.Cin(Cin),
		.control(control),
		.Cout(Cout),
		.result(result)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;
		control = 0;
		// Wait 100 ns for global reset to finish
		#1;
        //Do the results for the addition case
        for (i=0; i<=1; i=i+1) begin 
           for (j=0; j<=1; j=j+1) begin
              for(k=0; k<=1; k=k+1) begin
              // Initialize Inputs
                  result_test=0;
                  A = i[0];
                  B = j[0];
                  Cin = k[0];
                  result_test = i+j+k;
                  #1;
                  flag_1 = (result_test[0] ^ result);
                  flag_2 = (result_test[1] ^ Cout);
                  #1;
                  if (flag_1 == 0) begin
                      if (flag_2 == 0) begin
                           total_correct = total_correct + 1;
                      end
                  end
                  total_cases = total_cases + 1;
             end
           end
        end
        
       $display("The total correct cases for Addition operation is %d\n", total_correct);
       $display("The total possible cases for Addition operation is %d\n", total_cases);
       $display("Score is %e", (total_correct*10)/total_cases );        
        
        
        control=1;
        #1;
        //Do the results for the AND operation
         for (i=0; i<=1; i=i+1) begin 
           for (j=0; j<=1; j=j+1) begin
              for(k=0; k<=1; k=k+1) begin
              // Initialize Inputs
                  result_test=0;
                  A = i[0];
                  B = j[0];
                  Cin = k[0];
                  result_test = i&j;
                  #1;
                  flag_1 = (result_test[0] ^ result);
                  #1;
                  if (flag_1 == 0) begin
                      total_correct = total_correct + 1;
                  end
                  total_cases = total_cases + 1;
             end
           end
        end

        $display("The total correct cases for AND operation is %d\n", total_correct);
        $display("The total possible cases for AND operation is %d\n", total_cases);
        $display("Score is %e", (total_correct*10)/total_cases );
        
        control=2;
        #1;
        //Do the results for the OR operation
         for (i=0; i<=1; i=i+1) begin 
           for (j=0; j<=1; j=j+1) begin
              for(k=0; k<=1; k=k+1) begin
              // Initialize Inputs
                  result_test=0;
                  A = i[0];
                  B = j[0];
                  Cin = k[0];
                  result_test = i|j;
                  #1;
                  flag_1 = (result_test[0] ^ result);
                  #1;
                  if (flag_1 == 0) begin
                      total_correct = total_correct + 1;
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

