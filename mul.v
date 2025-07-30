module floatingmultiplication   (input [31:0]A,
                                 input [31:0]B,
                                 input Fmul_en,
                                 output reg  [31:0] result);

wire overflow,underflow;

reg [23:0] A_Mantissa,B_Mantissa;
reg Sign;
reg [7:0] Exponent;
reg [22:0] Mantissa;
reg [47:0] Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
reg A_sign,B_sign;

always@(*)
begin
A_Mantissa = {1'b1,A[22:0]};
A_Exponent = A[30:23];
A_sign = A[31];
  
B_Mantissa = {1'b1,B[22:0]};
B_Exponent = B[30:23];
B_sign = B[31];

Temp_Exponent = A_Exponent+B_Exponent-127;
Temp_Mantissa = A_Mantissa*B_Mantissa;
Mantissa = Temp_Mantissa[47] ? Temp_Mantissa[46:24] : Temp_Mantissa[45:23];
Exponent = Temp_Mantissa[47] ? Temp_Exponent+1'b1 : Temp_Exponent;
Sign = A_sign^B_sign;
result = Fmul_en?({Sign,Exponent,Mantissa}):0;
end
endmodule


module mul_tb;
reg [31:0] A,B;
reg Fmul_en;
wire [31:0] mul_result;

floatingmultiplication fmul(.A(A),.B(B),.Fmul_en(Fmul_en),.result(mul_result));

initial
begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin
Fmul_en=1;
A=32'h41a00000; B=32'h41f00000; #10;  //20*30
A=32'h41c80000; B=32'h42340000; #10; //25*45 
Fmul_en=0;   
A=32'h42480000; B=32'h42fa0000; #10; //50*125 
Fmul_en=1;
A=32'h42800000; B=32'h442f0000; #10; //64*700
$finish;
end

endmodule  



