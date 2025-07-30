module min_tb;
reg [31:0]read_data1;
reg [31:0]read_data2;
wire [31:0]mindata_out;
reg Fmin_en;

fmin2 u1(.read_data1(read_data1),.read_data2(read_data2),.mindata_out(mindata_out),.Fmin_en(Fmin_en));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial
begin
Fmin_en=1'b1; #10;
Fmin_en=1'b1; #10;
Fmin_en=1'b1; #10;
Fmin_en=1'b0; #10;
Fmin_en=1'b1; #10;
Fmin_en=1'b1; #10;
Fmin_en=1'b1; #10;
Fmin_en=1'b1; #10;
Fmin_en=1'b1; #10;
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

