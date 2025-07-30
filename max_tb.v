module max_tb;
reg [31:0]read_data1;
reg [31:0]read_data2;
wire [31:0]maxdata_out;
reg Fmax_en;

fmax2 u1(.read_data1(read_data1),.read_data2(read_data2),.maxdata_out(maxdata_out),.Fmax_en(Fmax_en));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin
Fmax_en=1'b1; #10;
Fmax_en=1'b1; #10;
Fmax_en=1'b1; #10;
Fmax_en=1'b0; #10;
Fmax_en=1'b1; #10;
Fmax_en=1'b0; #10;
Fmax_en=1'b1; #10;
end

initial
begin
read_data1=32'hEF12;     #10;
read_data1=32'h0234EF12; #10;
read_data1=32'hF811AB12; #10;
read_data1=32'hED12;     #10;
read_data1=32'hEF0E2;    #10;
read_data1=32'hA156BF12; #10;
read_data1=32'h7FF12001; #10;
read_data1=32'h00000000; #10;
read_data1=32'h80000000; #10;
end

initial
begin
read_data2=32'hEF12;      #10;   
read_data2=32'hF234DF12;  #10;
read_data2=32'hF42AB12;   #10;
read_data2=32'hEBA12;     #10;
read_data2=32'hEF90E2;    #10;
read_data2=32'hB9FA6BF2;  #10;
read_data2=32'h123;       #10;
read_data2=32'h80000000;  #10;
read_data2=32'h00000000;  #10;
#10 $finish;
end

endmodule

/*initial
begin
read_data1=32'b0_10000000_01000000000000000000000 ; #10;        //2.5   
read_data2=32'b0_10000010_11000000000000000000000 ; #10;        //14    max
read_data2=32'b0_10000001_00100111000010100011111 ; #10;        //4.61  max
read_data1=32'b0_10000100_11010000000000000000000 ; #10;        //58    
read_data1=32'b0_10000101_11000000000000000000000 ; #10;        //112  
read_data1=32'b0_10000100_00000000000000000000000 ; #10;        //32    
read_data1=32'b1_10000101_10111100000000000000000 ; #10;        //-111   //max
end

initial
begin
read_data2=32'b0_10000000_01000000000000000000000 ; #10;       //2.5 
read_data1=32'b1_10000010_10000110011001100110011 ; #10;       //-12.2    
read_data1=32'b0_10000001_00100110011001100110011 ; #10;       //4.6 
read_data2=32'b0_10000100_11010000000000000000000 ; #10;       //58    
read_data2=32'b0_10000101_11100000000000000000000 ; #10;       //120
read_data2=32'b0_10000100_00000000000000100000110 ; #10;       //32.001 
read_data2=32'b1_10000110_00000100000000000000000 ; #10;       //-130
#10 $finish;
end

endmodule*/

