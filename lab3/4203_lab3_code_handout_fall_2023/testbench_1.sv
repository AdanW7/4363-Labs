`timescale 1ns / 1ps

//simulated memory
import cache_def::*; 

`timescale 1ns/1ps

module sim_mem(input bit clk,
               input  mem_req_type  req,
               output mem_data_type data);
 
        localparam MEM_DELAY = 100;

        bit [127:0] mem[*];
        bit [127:0] rw;
        bit [127:0] _data;  
        bit [31:0] _addr;

        always @(posedge clk) begin
              data.valid = '0;
              data.ready = '0;
              if (!mem.exists(req.addr)) begin        //random initialize DRAM data on-demand 
                      mem[req.addr] = '1;     
              end

              if (req.valid) begin
                $display("%t: [Memory] %s @ addr=%x with data=%x", $time, (req.rw) ? "Write" : "Read", req.addr, 
                        (req.rw) ? req.data : mem[req.addr]);
                rw = req.rw;
                _data = req.data;
                _addr = req.addr; 
                #MEM_DELAY;
                if (rw)
                        begin
                        mem[_addr] =  _data ;  //req.data;
                        end
                else begin
                        data.data =  mem[_addr]; // mem[req.addr];             
                end

                $display("%t: [Memory] request finished", $time);
                data.valid = '1;       
                data.ready = '1;                         
              end
        end 
endmodule 

module test_main;
        bit clk;       
        initial forever #2 clk = ~clk; 

        mem_req_type    mem_req;        
        mem_data_type   mem_data;
        cpu_req_type     cpu_req;
        cpu_result_type  cpu_res;
	    bit[0:1] PLRU_selection_debug;

        integer total_cases=0;
        integer correct_cases=0;
        integer flag1=0;
        integer flag2=0;
        integer flag3=0;
        integer flag4=0;
        integer flag5=0;
       
        bit     rst;
        int  x[N][N] ;
        
 
        //simulated CPU
        initial begin

               rst = '0;
               #5;                           
               rst = '1;
               #10;
               rst = '0;

               for (int i=0; i<1024*N; i=i+1)begin
                    counter[i]=0;
               end

               cpu_req = '{default:0};
               
               //note that: The CPU needs to reset all cache tags in a real ASIC implementation
               //In this testbench, all tags are automatically initialized to 0 because the use of the systemverilog bit data type
               //For an FPGA implementation, all RAMs are initialized to be 0 by default.
               //read clean miss (allocate)
                               
               $timeformat(-9, 3, "ns", 10);


//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h5;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h5);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h10;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h10);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h5;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h5);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h10;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h10);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h5;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h5);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h5;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h5);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h10;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h10);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h7;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h7);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h6;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h6);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h10;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h10);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h9;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h9);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h2;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h2);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h5;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h5);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h1;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h1);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h3);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h0);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h3;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h3);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h5;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h5);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h10;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h10);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h1);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h10;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h10);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h2;
cpu_req.addr[31:14] = 'h4;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h4);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
//Access Delimiter
cpu_req.rw = '0;
cpu_req.addr[13:4] = 'h1;
cpu_req.addr[31:14] = 'h8;
cpu_req.valid = '1;
$display("%t: [CPU] read addr=%x", $time, cpu_req.addr);
wait(cpu_res.ready == '1);
$display("%t: [CPU] get data=%x", $time, cpu_res.data);
cpu_req.valid = '0;
total_cases=total_cases+1;
flag1 = (cpu_req.addr[31:14] == 'h8);
flag2 = (cpu_res.data == 'hffffffff);
flag3 = (dram_inst.mem[cpu_req.addr] == 'hffffffffffffffffffffffffffffffff);
flag4 = (PLRU_selection_debug == 'h2);
$display("PLRU selection debug is %d", PLRU_selection_debug);
$display("flag1 : %d flag2 : %d flag3 : %d flag4 : %d flag5 : %d",flag1, flag2, flag3, flag4, flag5);
if ((flag1+flag2+flag3+flag4)==4) begin correct_cases=correct_cases+1; end
#200;
$display("\n");
               
               // 0000 0010 1010 1111 0000 0000 0010 1100
               // 0    2    a     f    0   0     2    c

              $display ("The total cases are %d\n",total_cases);
              $display ("The correct cases are %d\n",correct_cases);

              $finish();
         end
        
        dm_cache_fsm dm_cache_inst(.*);
        sim_mem      dram_inst(.*, .req(mem_req), .data(mem_data));
endmodule
