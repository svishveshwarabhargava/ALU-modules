module F_alu(clk,read_data1,read_data2,Fadd_en,Fsub_en,Fmul_en,Fdiv_en,
Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en,data_out);

input wire [31:0]read_data1,read_data2;
input wire Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en,Fadd_en,Fsub_en,Fmul_en,Fdiv_en;
input clk;

output reg [31:0] data_out;


wire sign1,sign2;
wire [7:0] exponent1,exponent2;
wire [22:0] mantissa1,mantissa2;

assign sign1     = read_data1[31]; 
assign sign2     = read_data2[31];
assign exponent1 = read_data1[30:23];
assign exponent2 = read_data2[30:23];
assign mantissa1 = read_data1[22:0];
assign mantissa2 = read_data2[22:0];

wire [31:0] sqrtdata_out,maxdata_out,mindata_out,eqdata_out,ltdata_out,leqdata_out,adddata_out,subdata_out,divdata_out,muldata_out;


float_add add(
              .operand_A(read_data1),
              .operand_B(read_data2),
              .add_en(Fadd_en),
              .add_res(adddata_out)        

              ); 

float_sub sub(
              .operand_A(read_data1), 
              .operand_B(read_data2),
              .sub_en(Fsub_en),
              .sub_res(subdata_out)        

             ); 


floatingmultiplication mul(.A(read_data1),
                           .B(read_data2),
                           .Fmul_en(Fmul_en),
                           .result(muldata_out)
                           );

FloatingDivision div(.A(read_data1),
                     .B(read_data2),
                     .clk(clk),
                     .result(divdata_out)
                     );
                    
FloatingSqrt sqrt(
             .clk(clk),
             .A(read_data1),
             .Fsqrt_en(Fsqrt_en),
             .result(sqrtdata_out)
             );

fmax2 max (
           .read_data1(read_data1),
           .read_data2(read_data2),
           .maxdata_out(maxdata_out),
           .Fmax_en(Fmax_en)
            );

fmin2 min(
          .read_data1(read_data1),
          .read_data2(read_data2),
          .mindata_out(mindata_out),
          .Fmin_en(Fmin_en)
          );

Feq    equal(
              .read_data1(read_data1),
              .read_data2(read_data2),
              .eqdata_out(eqdata_out),
              .Feq_en(Feq_en)
             );

Flt  less_than(
               .read_data1(read_data1),
               .read_data2(read_data2),
               .ltdata_out(ltdata_out),
               .Flt_en(Flt_en)
               );

Fleq  less_or_equal(
                    .read_data1(read_data1),
                    .read_data2(read_data2),
                    .leqdata_out(leqdata_out),
                    .Fleq_en(Fleq_en)
                    );

always@(posedge clk)
begin
case({Fadd_en,Fsub_en,Fmul_en,Fdiv_en,Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en})   

10'b1000000000 : data_out<=adddata_out;
10'b0100000000 : data_out<=subdata_out;
10'b0010000000 : data_out<=muldata_out;
10'b0001000000 : data_out<=divdata_out;
10'b0000100000 : data_out<=sqrtdata_out;
10'b0000010000 : data_out<=maxdata_out;
10'b0000001000 : data_out<=mindata_out;
10'b0000000100 : data_out<=eqdata_out;
10'b0000000010 : data_out<=ltdata_out;
10'b0000000001 : data_out<=leqdata_out;
default: data_out<=0;

endcase
end
endmodule



