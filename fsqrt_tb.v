module FloatSqrtTBmodule;   
reg [31:0] A;
reg clk,Fsqrt_en;
wire [31:0] result;

FloatingSqrt fsqrt(.A(A),.clk(clk),.Fsqrt_en(Fsqrt_en),.result(result));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin 
clk=0;
forever #5 clk=~clk;
end

initial
begin
Fsqrt_en=1; #10;
Fsqrt_en=1; #10;
Fsqrt_en=1; #10;
Fsqrt_en=1; #10;
end

initial  
begin
A = 32'h41c80000; #10;   // 25   sqrt is 5
A = 32'h42040000; #10;   // 33   sqrt is 5.744
A = 32'h42aa0000; #10;   // 85   sqrt is 9.21
A = 32'h442f0000; #10;   //700   sqrt is 26.45
#10 $finish;
end
endmodule























/*

real value;

initial
begin
#10
value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
$display("Expected Value : %f Result : %f",5.0,value);
#10
value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
$display("Expected Value : %f Result : %f",5.744562646538029,value);
#10
value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
$display("Expected Value : %f Result : %f",9.219544457292887,value);
#10
value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
$display("Expected Value : %f Result : %f",26.45,value);
$finish;
end
*/
