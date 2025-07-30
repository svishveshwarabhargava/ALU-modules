module decoder(instruction,clk,rst,Fadd_en,Fsub_en,Fdiv_en,Fmul_en,Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en,rs1,rs2,rd,rd_en,wr_en);

input [31:0]instruction;
input clk,rst;
output reg Fadd_en,Fsub_en,Fdiv_en,Fmul_en,Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en,rd_en,wr_en;
output reg [4:0]rs1,rs2,rd;

  wire [6:0]opcode                     ;
  wire [6:0]func7                      ; 
  wire [2:0]rm                         ;
  
  assign opcode = instruction[6:0]     ;
  assign func7  = instruction[31:25]   ; 
  assign rm     = instruction[14:12]   ;
 
always@(*)
begin
if(rst==1'b1)
   begin
   Fadd_en  = 1'b0 ; Fsub_en =1'b0   ; Fdiv_en = 1'b0 ; Fmul_en=1'b0   ;
   Fsqrt_en = 1'b0 ; Fmax_en = 1'b0  ; Fmin_en = 1'b0 ; Feq_en  = 1'b0 ;
   Flt_en   = 1'b0 ; Fleq_en = 1'b0  ; rd_en   = 1'b0 ; wr_en   = 1'b0 ;
   rs1      = 1'b0 ; rs2     = 1'b0  ; rd      = 1'b0 ;
   end //endif

else
  case(opcode)
     7'b1010011 :
     if(func7 == 7'b0000000)
          begin
                                                   // addition
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b1            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end

          else if(func7 == 7'b0000100)
          begin
                                                   // addition
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b1            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end

          else if(func7 == 7'b0001100)
          begin
                                                   // division
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b1            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end

          else if(func7 == 7'b0001000)
          begin
                                                   // multiplication
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b1            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end
       
        else if(func7 == 7'b0101100 && rs2 == 5'b0)
          begin
                                                   // square root
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b1            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end

       else if(func7 ==  7'b0010100 && rm == 3'b001)
          begin
                                                   // maximum
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b1            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end
        
        else if(func7 ==  7'b0010100 && rm == 3'b000)
          begin
                                                   // minimum
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b1            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end

       else if(func7 ==  7'b1010000 && rm == 3'b010)
          begin
                                                  // equal
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b1            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end

       else if(func7 ==  7'b1010000 && rm == 3'b001)
          begin
                                                // less than
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b1            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end


       else if(func7 ==  7'b1010000 && rm == 3'b000)
          begin
                                               //less than or equal
               rs1 = instruction[19:15]    ;
               rs2 = instruction[24:20]    ;
               rd  = instruction[11:7]     ;
            
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b1            ;
           
               rd_en  = 1'b1               ;
               wr_en  = 1'b1               ;
          end      
        else
          begin
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b0               ;
               wr_en  = 1'b0               ;

           end
                                        
             default :
              begin
               Fadd_en   = 1'b0            ;
               Fsub_en   = 1'b0            ; 
               Fdiv_en   = 1'b0            ; 
               Fmul_en   = 1'b0            ;
               Fsqrt_en  = 1'b0            ;
               Fmax_en   = 1'b0            ;
               Fmin_en   = 1'b0            ;
	       Feq_en    = 1'b0            ;
               Flt_en    = 1'b0            ;
               Fleq_en   = 1'b0            ;
           
               rd_en  = 1'b0               ;
               wr_en  = 1'b0               ;
             
              end
      endcase  //endcase                             
end//end always
endmodule
