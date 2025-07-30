module decoder_tb;

  reg [31:0] instruction;
  reg clk; 
  reg rst;
  wire Fadd_en,Fsub_en,Fmul_en,Fdiv_en,Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en;
  wire [4:0] rs1, rs2, rd;
  wire rd_en, wr_en;
 

decoder u1(.instruction(instruction),.clk(clk),.rst(rst),.Fadd_en(Fadd_en),.Fsub_en(Fsub_en),.Fmul_en(Fmul_en),.Fdiv_en(Fdiv_en),
.Fsqrt_en(Fsqrt_en),.Fmax_en(Fmax_en),.Fmin_en(Fmin_en),.Feq_en(Feq_en),
.Flt_en(Flt_en),.Fleq_en(Fleq_en),.rs1(rs1),.rs2(rs2),.rd(rd),.rd_en(rd_en),.wr_en(wr_en));

initial 
begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end
  
initial begin 
clk=0;
forever #5 clk=~clk;
end

initial begin
rst =1; #10;
rst=0;
end

initial 
begin
  
    instruction=32'b0; #10;    
 
    //Fadd_en
    instruction = 32'b0000000_01010_10001_000_01111_1010011; #10;
    //instruction = 32'b0000000_10001_01101_000_11100_1010011; #10;

    //Fsub_en
    instruction = 32'b0000100_01000_10110_000_00101_1010011; #10;
    //instruction = 32'b0000100_11001_11001_000_10100_1010011; #10;
 
    //Fmul_en
    instruction = 32'b0001000_01100_10001_001_11011_1010011; #10;
    //instruction = 32'b0001000_00110_11101_101_01001_1010011; #10;

    //Fdiv_en
    instruction = 32'b0001100_11010_10011_001_01001_1010011; #10;
    //instruction = 32'b0001100_10010_10101_101_00001_1010011; #10;

    //Fsqrt_en  
    instruction = 32'b0101100_00000_10111_001_11001_1010011; #10;
    //instruction = 32'b0101100_00000_00101_101_11101_1010011; #10;
    
    //Fmax_en
    instruction = 32'b0010100_01101_10101_001_10011_1010011; #10;
    //instruction = 32'b0010100_01000_00001_001_11011_1010011; #10;

    //Fmin_en
    instruction = 32'b0010100_10011_01011_000_01001_1010011; #10;
    //instruction = 32'b0010100_01011_00011_000_11000_1010011; #10;

    //Feq_en
    instruction = 32'b1010000_11011_10011_010_01000_1010011; #10;
    //instruction = 32'b1010000_00011_00011_010_01001_1010011; #10;

    //Flt_en
    instruction = 32'b1010000_10011_11001_001_01001_1010011; #10;
    //instruction = 32'b1010000_01011_01001_001_01010_1010011; #10;

    //Fleq_e
    instruction = 32'b1010000_00011_11011_000_11001_1010011; #10;
    //instruction = 32'b1010000_11011_01000_000_01000_1010011; #10;

#10 $finish;
end
endmodule
