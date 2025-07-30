module memory_tb;
reg clk,rst;
reg wr_en;
reg [4:0]wr_addr;
reg [31:0]wr_data;

reg rd_en;
reg [4:0] read_addr1,read_addr2;
wire [31:0]read_data1,read_data2;

mem uut(.clk(clk),.rst(rst),.wr_en(wr_en),.wr_addr(wr_addr),.wr_data(wr_data),.rd_en(rd_en),.read_addr1(read_addr1),
.read_addr2(read_addr2),.read_data1(read_data1),.read_data2(read_data2));

initial 
begin
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
rst=1; #10; 
rst=0;
end

initial
begin
if(wr_en)
begin
rd_en=0;
end
else
wr_en=0;
end

initial
begin
wr_en=1; rd_en=0; #10;
wr_en=1; rd_en=0; #10;
wr_en=1; rd_en=0; #10;
wr_en=0; rd_en=1; #10;
wr_en=0; rd_en=1; #10;
wr_en=0; rd_en=1; #10;
end

initial 
begin
wr_addr=5'b10010;  wr_data=32'b0_10000000_01000000000000000000000 ; #10;        //2.5         
wr_addr=5'b01101;  wr_data=32'b1_10000010_10000110011001100110011 ; #10;        //-12.2
wr_addr=5'b10011;  wr_data=32'b0_10000001_01000000000000000000000 ; #10;        //5

read_addr1=5'b10011;  read_addr2=5'b01101;  #10;
read_addr1=5'b01101;  read_addr2=5'b10011;  #10;
read_addr1=5'b10010;  read_addr2=5'b10010;  #10;
#10 $finish;
end
endmodule
