`timescale 1ns / 1ps

import cache_def::*; 

/*cache: data memory, single port, 1024 blocks*/
module dm_cache_data(input  bit clk, 
    input  cache_req_type  data_req,//data request/command, e.g. RW, valid
    input  cache_data_type data_write, //write port (128-bit line) 
    output cache_data_type data_read); //read port
    timeunit 1ns; timeprecision 1ps;
    cache_data_type data_mem[0:1024*N-1];


 initial begin
    for (int i=0; i<1024*N-1; i++) 
       data_mem[i] = 0;
    for (int j=0; j<1024; j++)
       pointer_arr[j] = 0;
  end
  
  assign  data_read  =  data_mem[data_req.index*N + data_req.line_num];
  
  always_ff  @(posedge(clk))  begin
    if  (data_req.we) begin
      data_mem[data_req.index*N + data_req.line_num] <= data_write;
      end
  end
endmodule

/*cache: tag memory, single port, 1024 blocks*/
module dm_cache_tag(input  bit clk, //write clock
    input  cache_req_type tag_req, //tag request/command, e.g. RW, valid
    input  cache_tag_type tag_write,//write port    
    input  bit tag_miss, //indicates cache miss
    input bit tag_hit, //indicates cache hit
    input bit [0:1] tag_hit_line_num,
    output bit[0:1] PLRU_selection,
    output cache_tag_type[0:N-1] tag_read);//read port
  timeunit 1ns; timeprecision 1ps;
  cache_tag_type tag_mem[0:1024*N-1];
  bit[0:1] pointer_array[0:1023];
  
  bit [0:3] PLRU_bits [0:1023]; //TODO ... PLRU bits must be defined for all cache sets
//  reg [1:0] PLRU_counters[0:3];
  
  initial  begin
  
      for (int i=0; i<1024*N-1; i++) 
         tag_mem[i] = 0;
         
      for (int i=0; i<1024; i++ )
         pointer_array[i]=0;
        
       //TODO ... Initialize bit-PLRU array and PLRU_selection to 0
      for (int i=0; i<1024; i++) begin
            PLRU_bits[i] = 4'b0000;
      end
    PLRU_selection = 2'b00;

  end

  always @(*)
  begin
      for (int i=0; i<N; i++)
      tag_read[i]=tag_mem[tag_req.index*N+i];
  end
  

  always @(*)
  begin
  //TODO ... set the value for PLRU_selection based on the PLRU bits 
  
  if ((PLRU_bits[tag_req.index][0])==0)begin
    PLRU_selection =0;
  end
    else if ((PLRU_bits[tag_req.index][1])==0)begin
    PLRU_selection =1;
  end
    else if ((PLRU_bits[tag_req.index][2])==0)begin
    PLRU_selection =2;
  end
    else if ((PLRU_bits[tag_req.index][3])==0)begin
    PLRU_selection =3;
  end

end
 
  always_ff @(posedge(clk))  begin
    if  (tag_req.we)
       tag_mem[tag_req.index*N + tag_req.line_num] <= tag_write;
    if (tag_miss) begin
       pointer_array[tag_req.index] <= (pointer_array[tag_req.index] + 1) % N;
    end      
    if (tag_hit) begin
          $display("Tag Hit Occurring Updating PLRU, the tag hit line number is %d", tag_hit_line_num);
	  //TODO ... Update the bit-PLRU state on the clock edge
	  
	  PLRU_bits[tag_req.index][tag_hit_line_num]=1;
	  if (PLRU_bits[tag_req.index]==4'b1111)
	  begin
	   PLRU_bits[tag_req.index]=4'b0000;
	  end

	  

	  
      end
  end
  
endmodule
