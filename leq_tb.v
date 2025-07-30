module Fleq_tb;
reg [31:0]read_data1;
reg [31:0]read_data2;
wire [31:0]leqdata_out;
reg Fleq_en;

Fleq u1(.read_data1(read_data1),.read_data2(read_data2),.leqdata_out(leqdata_out),.Fleq_en(Fleq_en));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin
Fleq_en=1'b1; #10;
Fleq_en=1'b1; #10;
Fleq_en=1'b0; #10;
Fleq_en=1'b1; #10;
Fleq_en=1'b0; #10;
Fleq_en=1'b0; #10;
Fleq_en=1'b1; #10;
Fleq_en=1'b1; #10;
Fleq_en=1'b1; #10;
end

initial
begin
read_data1=32'b0_10000000_01000000000000000000000 ; #10;        //2.5     equal
read_data1=32'b0_10000010_10000110011001100110011 ; #10;        //12.2    
read_data1=32'b0_10000001_01000000000000000000000 ; #10;        //5       
read_data1=32'b0_10000101_01101000000000000000000 ; #10;        //90      less than
read_data1=32'b0_10000100_11010000000000000000000 ; #10;        //58      equal but enable is low hence output is zero  
read_data1=32'b0_10000101_11000000000000000000000 ; #10;        //112  
read_data1=32'b0_10000100_00000000000000000000000 ; #10;        //32       
read_data1=32'b1_10000110_00101100000000000000000 ; #10;        //-150    less than
read_data1=32'b1_10000101_00011000000000000000000 ; #10;        //-70     
end

initial
begin
read_data2=32'b0_10000000_01000000000000000000000 ; #10;       //2.5   
read_data2=32'b1_10000010_11000000000000000000000 ; #10;       //-14
read_data2=32'b0_01111111_00000000000000000000000 ; #10;       //1 
read_data2=32'b0_10000101_11100000000000000000000 ; #10;       //120
read_data2=32'b0_10000100_11010000000000000000000 ; #10;       //58    
read_data2=32'b0_10000101_11100000000000000000000 ; #10;       //120
read_data2=32'b0_10000100_00000000000000100000110 ; #10;       //32.001 
read_data2=32'b0_10000110_00101100000000000000000 ; #10;       //150
read_data2=32'b1_10000101_01000000000000000000000 ; #10;       //-80
#10 $finish;
end

endmodule

