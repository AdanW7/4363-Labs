`timescale 1ns / 1ps

//TODO 
//modify the cache FSM so that it implements 
//an n-way set associative cache
//also implement two replacement strategies
//LRU (least recently used) and MRU (most recently used) -- rotation

import cache_def::*; 

/*cache finite state machine*/
module dm_cache_fsm(input  bit clk, input  bit rst,
        input  cpu_req_type  cpu_req,       
        //CPU request input (CPU->cache)
        input  mem_data_type  mem_data,     
        //memory response (memory->cache)
        output mem_req_type   mem_req,      
        //memory request (cache->memory)
        output cpu_result_type cpu_res,
        //cache result (cache->CPU)
	output bit[0:1] PLRU_selection_debug
    );
  timeunit  1ns;  
  timeprecision  1ps;
  /*write  clock*/
  typedef enum {idle, compare_tag, allocate, write_back} cache_state_type;
  /*FSM state register*/
  cache_state_type vstate,rstate;
  /* replacement memory */
   
  /*interface signals to tag memory*/
  cache_req_type tag_req;                  //tag  request
  cache_tag_type tag_write;                //tag  write  data
  bit tag_miss;
  bit tag_hit;
  bit [0:1] tag_hit_line_num;
  bit [0:1] PLRU_selection;
  cache_tag_type[0:N-1] tag_read;          //tag  read  result
  
  /*interface signals to cache data memory*/
  cache_data_type data_read;               //cache  line  read  data
  cache_data_type data_write;              //cache  line  write  data
  cache_req_type data_req;                 //data  req
  /*temporary variable for cache controller result*/
  cpu_result_type v_cpu_res;  
  /*temporary variable for memory controller request*/
  mem_req_type v_mem_req;
  assign mem_req = v_mem_req;              //connect to output ports
  assign cpu_res = v_cpu_res;
  assign PLRU_selection_debug = PLRU_selection;

    always_comb begin
        /*-------------------------default values for all signals------------*/
	/*miss signal */
	tag_miss = 0;
	tag_hit = 0;
	tag_hit_line_num=0;
        /*no state change by default*/
        //vstate = rstate;
        v_cpu_res = '{0, 0, 0}; tag_write = '{0, 0, 0};
        /*read tag by default*/
        tag_req.we = '0;             
        /*direct map index for tag*/
        tag_req.index = cpu_req.addr[13:4];
        /*read current cache line by default*/
        data_req.we  =  '0;
        /*direct map index for cache data*/
        data_req.index = cpu_req.addr[13:4];
        /*modify correct word (32-bit) based on address*/
        data_write = data_read;        
        case(cpu_req.addr[3:2])
        2'b00:data_write[31:0]  =  cpu_req.data;
        2'b01:data_write[63:32]  =  cpu_req.data;
        2'b10:data_write[95:64]  =  cpu_req.data;
        2'b11:data_write[127:96] = cpu_req.data;
        endcase
        /*read out correct word(32-bit) from cache (to CPU)*/
        case(cpu_req.addr[3:2])
        2'b00:v_cpu_res.data  =  data_read[31:0];
        2'b01:v_cpu_res.data  =  data_read[63:32];
        2'b10:v_cpu_res.data  =  data_read[95:64];
        2'b11:v_cpu_res.data  =  data_read[127:96];
        endcase
        /*memory request address (sampled from CPU request)*/
        v_mem_req.addr = cpu_req.addr; 
        v_mem_req.addr[3:0]=0;  
        /*memory request data (used in write)*/
        v_mem_req.data = data_read; 
        v_mem_req.rw  = '0;

        MINCOUNT=100;
        
        //------------------------------------Cache FSM-------------------------
        case(rstate)
            /*idle state*/
            idle : begin
                $display("Idle state");
                /*If there is a CPU request, then compare cache tag*/
                if (cpu_req.valid)
                   vstate = compare_tag;
                end
            /*compare_tag state*/ 
            compare_tag : begin
              /*cache hit (tag match and cache entry is valid)*/
              int hit_idx = -999;  
              $display("Compare tag state"); 
              for (int i=0; i<N; i=i+1)
              begin
                 if (cpu_req.addr[TAGMSB:TAGLSB] == tag_read[i].tag && tag_read[i].valid) begin
                   hit_idx=i;
                 end
              end
                 if ( hit_idx != -999 ) begin
                     
                     //if (v_cpu_res.ready == '1) begin
                     tag_hit_line_num=hit_idx;
                     tag_hit = 1;    
                     //end
                     $display("%t, Hit at %d, data_read : %x, vstate is %d ", $time, hit_idx, data_read, vstate);
                     data_req.line_num=hit_idx;
                     tag_req.line_num=hit_idx;
                     v_cpu_res.ready = '1;
                     /*write hit*/
                     if (cpu_req.rw) begin 
                     /*read/modify cache line*/
                       tag_req.we = '1; data_req.we = '1;
                     /*no change in tag*/
                       tag_write.tag = tag_read[hit_idx].tag; 
                       tag_write.valid = '1;
                     /*cache line is dirty*/
                       tag_write.dirty = '1;           
                     end 
                   /*update the counter */
                   if (vstate != idle) begin
                     counter[tag_req.index*N+hit_idx]=counter[tag_req.index*N+hit_idx]+1;
                   end 
                   /*xaction is finished*/
                   vstate = idle; 
                 end 
                 /*cache miss*/
                 else begin 
		   tag_miss=1;
		   MINLINE = PLRU_selection;
                   tag_req.line_num=MINLINE; 
                   data_req.line_num=MINLINE; 
              
                   $display("%t: [FSM] Tag Write @ index=%x with tag=%x with line_num = %x", $time, tag_req.index,cpu_req.addr[TAGMSB:TAGLSB], tag_req.line_num);
                   /*Reset the counter for replaced line */
                   /*generate new tag*/
                   tag_req.we = '1; 
                   tag_write.valid = '1;
                   /*new tag*/
                   tag_write.tag = cpu_req.addr[TAGMSB:TAGLSB];
                   /*cache line is dirty if write*/
                   tag_write.dirty = cpu_req.rw;
                   /*generate memory request on miss*/
                   v_mem_req.valid = '1; 
                   /*compulsory miss or miss with clean block*/
                   if (tag_read[MINLINE].valid == 1'b0 || tag_read[MINLINE].dirty == 1'b0)
                        /*wait till a new block is allocated*/
                        begin
                        $display("Allocating...");
                        vstate = allocate;
                        end
                   else begin
                        /*miss with dirty line*/
                           /*write back address*/
                           v_mem_req.addr = {tag_read[MINLINE].tag, cpu_req.addr[TAGLSB-1:0]};
                           v_mem_req.addr[3:0] = 0; 
                           v_mem_req.rw = '1; 
                           /*wait till write is completed*/
                           vstate = write_back;
                   end
                 end
            end
            /*wait for allocating a new cache line*/
            allocate: begin                 
               //flag=0;
               $display("Allocate tag state");          
               v_mem_req.valid = '0;   
               /*memory controller has responded*/
               if (mem_data.ready) begin
               /*re-compare tag for write miss (need modify correct word)*/
               vstate = compare_tag; 
               data_write = mem_data.data;
               /*update cache line data*/
               data_req.we = '1; 
               /*Reset the counter for replaced line */
               end 
            end
            /*wait for writing back dirty cache line*/
            write_back : begin     
               $display("Writeback state");    
               /*write back is completed*/

               if (mem_data.ready) begin
                  /*issue new memory request (allocating a new line)*/
                  v_mem_req.valid = '1;            
                  v_mem_req.rw = '0;           
                  vstate = allocate; 
               end
            end
        endcase
        
    end //end always_comb
       
    always_ff @(posedge(clk)) begin
        if (rst) 
          rstate <= idle;       //reset to idle state
        else
          rstate <= vstate;
        
    end //end always_ff
    
    /*connect cache tag/data memory*/
    dm_cache_tag  ctag(.*);
    dm_cache_data cdata(.*);
    
endmodule
