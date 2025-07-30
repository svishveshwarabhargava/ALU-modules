module Flt_tb;
reg [31:0]read_data1;
reg [31:0]read_data2;
wire [31:0]ltdata_out;
reg Flt_en;

Flt u1(.read_data1(read_data1),.read_data2(read_data2),.ltdata_out(ltdata_out),.Flt_en(Flt_en));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin
Flt_en=1'b1; #10;
Flt_en=1'b1; #10;
Flt_en=1'b0; #10;
Flt_en=1'b1; #10;
Flt_en=1'b0; #10;
Flt_en=1'b0; #10;
Flt_en=1'b1; #10;
Flt_en=1'b1; #10;
end

initial
begin
read_data1=32'b0_10000000_01000000000000000000000 ; #10;        //2.5    
read_data1=32'b1_10000010_10000110011001100110011 ; #10;        //-12.2   less than
read_data1=32'b0_10000100_00000000000000000000000 ; #10;        //32      
read_data1=32'b1_10000001_00101100110011001100110 ; #10;        //-4.7    less than 
read_data1=32'b0_10000100_11010000000000000000000 ; #10;        //58      
read_data1=32'b0_10000101_11000000000000000000000 ; #10;        //112     less than
read_data1=32'b0_10000100_00000000000000000000000 ; #10;        //32      less than
read_data1=32'b0_10000110_00101100000000000000000 ; #10;        //150     
end

initial
begin
read_data2=32'b0_10000000_01000000000000000000000 ; #10;      //2.5   
read_data2=32'b0_10000010_11000000000000000000000 ; #10;       //14
read_data2=32'b0_10000110_01101000000000000000000 ; #10;       //180
read_data2=32'b1_10000001_00100111000010100011111 ; #10;       //-4.61  
read_data2=32'b0_10000100_11010000000000000000000 ; #10;       //58    
read_data2=32'b0_10000101_11100000000000000000000 ; #10;       //120
read_data2=32'b0_10000100_00000000000000100000110 ; #10;       //32.001 
read_data2=32'b1_10000110_01101000000000000000000 ; #10;       //-180
#10 $finish;
end

endmodule

