module fp_tb;
reg clk,rst;
reg [31:0] instruction;
wire [31:0] data_out;

floatingpoint fp(.instruction(instruction),.clk(clk),.rst(rst),.data_out(data_out));

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
rst=1; #10; 
rst=0;
end

initial 
begin

    instruction = 32'b0;                                     #10;

    //Fadd_en
    instruction = 32'b0000000_01000_10001_000_01111_1010011; #10;
    
    //Fsub_en
    instruction = 32'b0000100_01010_10110_000_00101_1010011; #10;
    
 
    //Fmul_en
    instruction = 32'b0001000_01100_10001_001_11011_1010011; #10;
    
    //Fdiv_en
    instruction = 32'b0001100_11010_10011_001_01001_1010011; #10;
    
    //Fsqrt_en  
    instruction = 32'b0101100_00000_10111_001_11001_1010011; #10;
    
    //Fmax_en
    instruction = 32'b0010100_01101_10101_001_10011_1010011; #10;

    //Fmin_en
    instruction = 32'b0010100_10011_01011_000_01001_1010011; #10;

    //Feq_en
    instruction = 32'b1010000_11011_10011_010_01000_1010011; #10;

    //Flt_en
    instruction = 32'b1010000_10011_11001_001_01001_1010011; #10;
   
    //Fleq_e
    instruction = 32'b1010000_00010_01001_000_11001_1010011; #10;
   
$finish;
end
endmodule


