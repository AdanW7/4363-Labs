`timescale 1ns / 1ps

package cache_def;
   //data structures for cache and tag & data   
   parameter int TAGMSB = 31;   //tag msb
   parameter int TAGLSB = 14;   //tag ls
   parameter int N = 4; //set associativity
   int counter[0:1024*N-1] ;
   int pointer_arr[0:1024];
   int flag=0;
   int MINCOUNT;
   int MINLINE;
   
   //data structure for cache tag
     typedef struct packed {
       bit    valid;              //valid  bit
       bit    dirty;              //dirty  bit
       bit  [TAGMSB:TAGLSB]tag;    //tag  bits
     }cache_tag_type;
     
   //data structure for cache memory request
     typedef struct {
       bit [9:0]index;            //10-bit index
       bit    we;                 //write  enable
       bit allocate;             //an allocate write 
       bit [5:0] line_num;
     }cache_req_type;
   
   //128-bit cache line data
     typedef bit [127:0]cache_data_type;
       
   //128-bit cache line data
     typedef bit [127:0]cache_data_t;  
 
   // data structures for CPU<->Cache controller interface
   // CPU request (CPU->cache controller)
       typedef struct {
         bit [31:0]addr;            //32-bit request addr
         bit [31:0]data;            //32-bit request data (used when write)
         bit rw;                    //request type : 0 = read, 1 = write
         bit  valid;                //request  is  valid
       } cpu_req_type;
       
       // Cache result (cache controller->cpu)
       typedef struct {
         bit  [31:0]data;            //32-bit  data
         bit ready;                 //result is ready
         bit valid;                 //the cpu result is valid
       } cpu_result_type;
       
   //----------------------------------------------------------------------
         // data structures for cache controller<->memory interface
         // memory request (cache controller->memory)
         typedef struct {
           bit [31:0]addr;            //request byte addr
           bit [127:0]data;           //128-bit request data (used when write)
           bit rw;                    //request type : 0 = read, 1 = write 
           bit  valid;                 //request  is  valid
         } mem_req_type;
         
         // memory controller response (memory -> cache controller)
         typedef struct {
           cache_data_type data;   //128-bit read back data
           bit ready;              //data is ready
           bit valid;              //data is valid in the memory
         } mem_data_type;
endpackage
