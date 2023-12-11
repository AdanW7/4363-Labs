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
  bit [0:2] PLRU_bits [0:1023]; //TODO ... PLRU bits must be defined for all 1024 sets
  

  initial  begin
      for (int i=0; i<1024*N-1; i++) 
         tag_mem[i] = 0;
      for (int i=0; i<1024; i++ )
         pointer_array[i]=0;
        
    
    
       //TODO ... Initialize tree-PLRU array and PLRU_selection to 0
      for (int i=0; i<1024; i++) begin
            PLRU_bits[i] = 3'b000;
      end
        PLRU_selection = 2'b00;
        
        
  end

  always @(*)
  begin
      for (int i=0; i<N; i++)
      tag_read[i]=tag_mem[tag_req.index*N+i];
  end
  

  //TODO ... set the value for PLRU_selection based on the PLRU bits 
    always @(*)
  begin 
  //we are defining plru bits to have 3 important bits, bit 0 will always be the root node, bit 1 is the left branch and bit 2 is the right branch
 

      if ((PLRU_bits[tag_req.index][0])==0)begin
        if ((PLRU_bits[tag_req.index][2])==0)begin 
               PLRU_selection =3;
        end
        if ((PLRU_bits[tag_req.index][2])==1)begin 
               PLRU_selection =2;
        end
  end
  else
  begin
        if ((PLRU_bits[tag_req.index][1])==0)begin 
               PLRU_selection =1;
        end
        if ((PLRU_bits[tag_req.index][1])==1)begin 
               PLRU_selection =0;
        end 
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
	  //TODO ... Update the tree-PLRU state on the clock edge
	  

    case (tag_hit_line_num) 
    0:
    begin
        PLRU_bits[tag_req.index][0]=0;
        PLRU_bits[tag_req.index][1]=0;
    end
    1:
    begin
        PLRU_bits[tag_req.index][0]=0;
        PLRU_bits[tag_req.index][1]=1;
    end
    2:
    begin
        PLRU_bits[tag_req.index][0]=1;
        PLRU_bits[tag_req.index][2]=0;
    end
    3:
    begin
        PLRU_bits[tag_req.index][0]=1;
        PLRU_bits[tag_req.index][2]=1;
    end
    endcase


        
	  
      end
  end
  
endmodule
