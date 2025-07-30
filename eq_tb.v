module Feq_tb;
reg [31:0]read_data1;
reg [31:0]read_data2;
reg Feq_en;
wire [31:0]eqdata_out;

Feq u1(.read_data1(read_data1),.read_data2(read_data2),.Feq_en(Feq_en),.eqdata_out(eqdata_out));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin
Feq_en=1'b1; #10;
Feq_en=1'b1; #10;
Feq_en=1'b1; #10;
Feq_en=1'b0; #10;
Feq_en=1'b0; #10;
Feq_en=1'b1; #10;
Feq_en=1'b1; #10;
end

initial
begin
read_data1=32'b0_10000000_01000000000000000000000 ; #10;        //2.5   equal
read_data1=32'b1_10000010_10000110011001100110011 ; #10;        //-12.2
read_data1=32'b0_10000001_00100110011001100110011 ; #10;        //4.6   equal
read_data1=32'b0_10000100_11010000000000000000000 ; #10;        //58    equal but output will be 0 because enable is low
read_data1=32'b0_10000101_11000000000000000000000 ; #10;        //112  
read_data1=32'b0_10000100_00000000000000000000000 ; #10;        //32    equal
read_data1=32'b1_10000101_10111100000000000000000 ; #10;        //-111
end

initial
begin
read_data2=32'b0_10000000_01000000000000000000000 ; #10;      //2.5   equal  
read_data2=32'b0_10000010_11000000000000000000000 ; #10;       //14
read_data2=32'b0_10000001_00100111000010100011111 ; #10;       //4.61  equal 
read_data2=32'b0_10000100_11010000000000000000000 ; #10;       //58    equal but output will be 0 because enable is low
read_data2=32'b0_10000101_11100000000000000000000 ; #10;       //120
read_data2=32'b0_10000100_00000000000000100000110 ; #10;       //32.001 equal
read_data2=32'b1_10000110_00000100000000000000000 ; #10;       //-130
#10 $finish;
end

endmodule

