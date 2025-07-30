module floatingpoint(instruction,clk,rst,data_out);

input [31:0] instruction;
input clk,rst;
output [31:0] data_out;

wire Fadd_en_w,Fsub_en_w,Fmul_en_w,Fdiv_en_w;
wire Fsqrt_en_w,Fmax_en_w,Fmin_en_w,Feq_en_w,Flt_en_w,Fleq_en_w;
wire rd_en_w , wr_en_w;
wire [31:0] read_data1_w,read_data2_w;
wire [4:0]rs1_w,rs2_w,rd_w;
wire [31:0] data_out_w;

decoder decoder(.instruction(instruction),
                .clk(clk),
                .rst(rst),
                .Fadd_en(Fadd_en_w),
                .Fsub_en(Fsub_en_w),
                .Fmul_en(Fmul_en_w),
                .Fdiv_en(Fdiv_en_w),
                .Fsqrt_en(Fsqrt_en_w),
                .Fmax_en(Fmax_en_w),
                .Fmin_en(Fmin_en_w),
                .Feq_en(Feq_en_w),
                .Flt_en(Flt_en_w),
                .Fleq_en(Fleq_en_w),
                .rs1(rs1_w),.rs2(rs2_w),.rd(rd_w),
                .rd_en(rd_en_w),.wr_en(wr_en_w)
               );

memory     mem(.clk(clk),
               .rst(rst),
               .rd_en(rd_en_w),
               .wr_en(wr_en_w),
               .read_addr1(rs1_w),
               .read_addr2(rs2_w),
               .wr_addr(rd_w),.wr_data(data_out_w),
               .read_data1(read_data1_w),
               .read_data2(read_data2_w)
              );

F_alu      alu(.clk(clk),
               .Fadd_en(Fadd_en_w),
               .Fsub_en(Fsub_en_w),
               .Fmul_en(Fmul_en_w),
               .Fdiv_en(Fdiv_en_w),
               .Fsqrt_en(Fsqrt_en_w),
               .Fmax_en(Fmax_en_w),
               .Fmin_en(Fmin_en_w),
               .Feq_en(Feq_en_w),
               .Flt_en(Flt_en_w),
               .Fleq_en(Fleq_en_w),
               .read_data1(read_data1_w),
               .read_data2(read_data2_w),
               .data_out(data_out_w)
               );


assign data_out = data_out_w;
endmodule

