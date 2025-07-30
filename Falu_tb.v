module Falu_tb;
reg clk;
reg [31:0] read_data1,read_data2;

reg Fadd_en,Fsub_en,Fmul_en,Fdiv_en;
reg Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en; 
wire [31:0] data_out; 

F_alu alu_instantation(
                       .clk(clk),
                       .Fadd_en(Fadd_en),.Fsub_en(Fsub_en),.Fmul_en(Fmul_en),.Fdiv_en(Fdiv_en),
                       .Fsqrt_en(Fsqrt_en),.Fmax_en(Fmax_en),.Fmin_en(Fmin_en),
                       .Feq_en(Feq_en),.Flt_en(Flt_en),.Fleq_en(Fleq_en),
                       .read_data1(read_data1),.read_data2(read_data2),
                       .data_out(data_out)
                       ); 

initial
begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin 
clk=0;
forever #1 clk=~clk;
end

initial 
begin
Fadd_en=1'b1; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b1; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b1; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b1; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b1; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b1; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b1;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b1; Fleq_en=1'b0; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b1; Flt_en=1'b0; #10;
Fadd_en=1'b0; Fsub_en=1'b0; Fmul_en=1'b0; Fdiv_en=1'b0; Fsqrt_en = 1'b0; Fmax_en=1'b0; Fmin_en=1'b0;Feq_en=1'b0; Fleq_en=1'b0; Flt_en=1'b1; #10;

end

initial
begin
read_data1 = 32'h41a00000; #10; //20    add= 50
read_data1 = 32'h41c80000; #10; //25    sub= -20
read_data1 = 32'h42480000; #10; //50    mul= 6250
read_data1 = 32'h42800000; #10; //64    div= 0.0914
read_data1 = 32'h43200000; #10; //160  sqrt= 12.64
read_data1 = 32'h3f000000; #10; //0.5   max= 3000
read_data1 = 32'h3d23d70a; #10; //0.04  min= 0.04
read_data1 = 32'h43910000; #10; //290   eq = 0
read_data1 = 32'h441c4000; #10; //625   leq= 0
read_data1 = 32'h3c23d70a; #10; //0.010 lt = 1

end

initial
begin
read_data2=32'h41f00000; #10; //30
read_data2=32'h42340000; #10; //45
read_data2=32'h42fa0000; #10; //125
read_data2=32'h442f0000; #10; //700
read_data2=32'h3f0ccccd; #10; //0.55
read_data2=32'h453b8000; #10; //3000
read_data2=32'h441e8000; #10; //634
read_data2=32'h450ae000; #10; //2222
read_data2=32'h42e20000; #10; //113
read_data2=32'h43cd8000; #10; //411

#10 $finish;
end
endmodule
