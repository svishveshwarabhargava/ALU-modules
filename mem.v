module mem
(
input clk,rst,
input wr_en,
input [4:0]wr_addr,
input [31:0]wr_data,

input rd_en, 
input [4:0]read_addr1,
input [4:0]read_addr2,

output reg [31:0]read_data1,
output reg [31:0]read_data2
);

wire sign1,sign2;
wire [7:0] exponent1,exponent2;
wire [22:0] mantissa1,mantissa2;

reg [0:31]mem[31:0];

assign sign1     = read_data1[31]; 
assign sign2     = read_data2[31];
assign exponent1 = read_data1[30:23];
assign exponent2 = read_data2[30:23];
assign mantissa1 = read_data1[22:0];
assign mantissa2 = read_data2[22:0];

initial
begin
$readmemh("memory.hex", mem);
end

initial
begin
  if(rst)
read_data1=0;
read_data2=0;
end

always@(posedge clk)
begin
  if(wr_en)
   begin
mem[wr_addr]<=wr_data;
   end
end

always@(posedge clk)
begin
  if (rd_en)
  begin
read_data1<=mem[read_addr1];
read_data2<=mem[read_addr2];
  end
end
endmodule

