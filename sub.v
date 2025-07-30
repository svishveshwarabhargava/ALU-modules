module  float_sub(
  input  [31:0]operand_A                  ,
  input  [31:0]operand_B                  ,
  input        sub_en                     ,
  output [31:0]sub_res        

)                                         ;

wire           pr_enc_en_w                ;
wire     [31:0]sub_res_w                  ; 
wire   [23:0]mantissa_add_w               ;
wire            carry_w                   ;
  
wire      interrupt_en_w                  ;  
wire     [31:0]out_res_w                  ;  


  floating_sub  floating_sub_instance(
    
    .operand_A(operand_A)                 ,
    .operand_B(operand_B)                 ,
    .en(sub_en)                           ,
    .enc_out_res(out_res_w)               ,
    .interrupt_en(interrupt_en_w)         ,
    .pr_enc_en(pr_enc_en_w)               ,
    .sub_res(sub_res_w)                   ,
    .mantissa_add(mantissa_add_w)         ,
    .carry(carry_w)                       ,
    .final_sub_res(sub_res)               
    
                                    )     ;

  pr_encoder pr_encoder_instance(
  
    .in_res(sub_res_w)                    ,
    .mantissa_add_en(mantissa_add_w)      ,
    .carry(carry_w)                       ,
    .en(pr_enc_en_w)                      ,
    .interrupt_en(interrupt_en_w)         ,
    .out_res(out_res_w)                               
                                )         ;
  
endmodule



module floating_sub(
  
  input        [31:0]operand_A             , 
  input        [31:0]operand_B             ,
  input              en                    ,
  input        [31:0]enc_out_res           ,
  input              interrupt_en          ,
  output        reg  pr_enc_en             ,
  output   reg [31:0]sub_res               ,
  output   reg [23:0]mantissa_add          ,
  output        reg  carry                 ,
  output   reg [31:0]final_sub_res
  
  
  
                   )                       ;
  
  //// creating a sign , [7:0]exponent , [22:0]mantissa  bits for operand_A
  
  wire          sign_bit_a                 ;
  wire     [7:0]exponent_a                 ;
  wire     [22:0]mantissa_a                ;
  
  //// creating a sign , [7:0]exponent , [22:0]mantissa  bits for operand_B
  
  wire          sign_bit_b                 ;
  wire     [7:0]exponent_b                 ;
  wire     [22:0]mantissa_b                ;
  
   /////   to choose operration 
  
  wire      [1:0]operation                 ; 
  
  ///// to get exponent difference
  
  reg     [7:0]exponent_diff               ;
  
  ///// to get the hidden bit 
  
  reg     [23:0]mantissa_a_hidd            ;
  reg     [23:0]mantissa_b_hidd            ;
  
  ///// to store the mantissa_add and carry
  
 //reg      [23:0]mantissa_add              ;
 //reg            carry                     ;
  
  

  //// operand_A - extraction of sign , [7:0]exponent , [22:0]mantissa  bits
  
  assign sign_bit_a = operand_A[31]        ;
  assign exponent_a = operand_A[30:23]     ;
  assign mantissa_a = operand_A[22:0]      ;
  
   //// operand_B - extraction of sign , [7:0]exponent , [22:0]mantissa  bits
  
  assign sign_bit_b = operand_B[31]        ;
  assign exponent_b = operand_B[30:23]     ;
  assign mantissa_b = operand_B[22:0]      ;
  
 ////// extracting sign bit to check which operation needs to perform
  
  assign operation = {sign_bit_a,sign_bit_b} ;
  
  
  
  always@(*)
   begin

     if(en)
       begin 
         
          /////   considering hidden bit
  
             mantissa_a_hidd =  {((|exponent_a) ? 1'b1 : 1'b0),mantissa_a}       ; 
             mantissa_b_hidd =  {((|exponent_b) ? 1'b1 : 1'b0),mantissa_b}       ;
             
 //////  taking exponents differnce 
      
  if(exponent_a > exponent_b)
        begin
            exponent_diff = exponent_a - exponent_b                              ;
        end
             else if(exponent_a < exponent_b)
        begin
            exponent_diff = exponent_b - exponent_a                              ;
        end
             else
               exponent_diff = 8'b0 ;
 
  
 /////   shifting the mantissa by exponent_diff
  
  
  if(exponent_a > exponent_b)
           begin
              mantissa_b_hidd    = mantissa_b_hidd >> exponent_diff              ;
              sub_res[30:23] = exponent_a                                        ;
           end
  else
           begin
              mantissa_a_hidd = mantissa_a_hidd >> exponent_diff                 ;
              sub_res[30:23] = exponent_b                                        ;
           end
         
         
         
 ////////  sign_bit_A = +ve    and     sign_bit_B = -ve        
         
  /////// main operation
         
         case(operation)
           
       2'b01 :
         begin

           
             
      //// doing sign_bit 
     
             sub_res[31] = sign_bit_a && sign_bit_b                              ;
             
  //////  adding the two mantissa 
     
    
     {carry,mantissa_add[22:0]} = mantissa_a_hidd[22:0] + mantissa_b_hidd[22:0]  ; 
             
     
      if(carry) 
       begin
         
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd )
           begin
         sub_res[22:0]  = {carry,mantissa_add[22:0]} >> 1'b1                     ;
             sub_res[30:23] = sub_res[30:23] + 1'b1                                  ;
           end
         else
           begin
             sub_res[22:0] = mantissa_add[22:0] >> 1'b1                          ;
             sub_res[30:23] = sub_res[30:23] + 1'b1                              ;
           end
       end
     else 
       begin
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd)
           begin
             sub_res[22:0]  = mantissa_add[22:0] >> 1'b1                         ;
             sub_res[30:23] = sub_res[30:23] + 1'b1                              ;
           end
         else
           begin
             sub_res[22:0]  = mantissa_add[22:0]                                 ;
             sub_res[30:23] = sub_res[30:23]                                     ;
           end
       end
             
           final_sub_res = {{sub_res[31]},{sub_res[30:23]},{sub_res[22:0]}}      ;  
           
         end
           
           
         
         
         
         
         
         
         
         
         
   ///////   sign_bit_A = -ve    and     sign_bit_B = +ve     
         
        2'b10  :
           begin
             
             
     //// doing sign_bit 
     
             sub_res[31] = sign_bit_a || sign_bit_b                              ;         
             
    //////  adding the two mantissa 
     
    
     {carry,mantissa_add[22:0]} = mantissa_a_hidd[22:0] + mantissa_b_hidd[22:0]  ;  
  
     if(carry) 
       begin
         
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd )
           begin
         sub_res[22:0]  = {carry,mantissa_add[22:0]} >> 1'b1                     ;
         sub_res[30:23] = sub_res[30:23] + 1'b1                                  ;
           end
         else
           begin
             sub_res[22:0] = mantissa_add[22:0] >> 1'b1                          ;
             sub_res[30:23] = sub_res[30:23] + 1'b1                              ;
           end
       end
             else 
       begin
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd)
           begin
             sub_res[22:0]  = mantissa_add[22:0] >> 1'b1                         ;
             sub_res[30:23] = sub_res[30:23] + 1'b1                              ;
           end
         else
           begin
             sub_res[22:0]  = mantissa_add[22:0]                                 ;
             sub_res[30:23] = sub_res[30:23]                                     ;
           end
       end
            
          
        final_sub_res = {{sub_res[31]},{sub_res[30:23]},{sub_res[22:0]}}         ;
             
           end
         
         
         
         
         
         
         
         
         
      ////////   sign_bit_A = +ve    and   sign_bit_B = +ve 
         
         2'b00  :
           begin
             
      /////////    taking the 2's complement of op_B mantissa part
             
           mantissa_b_hidd = ~mantissa_b_hidd + 1                               ;
             
      ////////     adding the matissa part of both op_a and op_b
             
             {carry,mantissa_add[23:0]} = mantissa_a_hidd[23:0] + mantissa_b_hidd[23:0] ; 
             
             
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 sub_res = 32'd0                                                ;
               end
  
             else if(operand_A[30:0] < operand_B[30:0])                                                     
               begin 
                 mantissa_add[22:0] = ~mantissa_add[22:0] + 1                   ;
             
                   if(!carry)
               begin
                 
                     if(exponent_a == exponent_b || mantissa_a == mantissa_b)
               begin
                 sub_res[22:0] = mantissa_add[22:0]                             ;
                 sub_res[22:0] = mantissa_add[22:0] << 1                        ;
                 sub_res[30:23] = sub_res[30:23] - 1'b1                         ;
               end 
                        else
               begin
                 sub_res[22:0] = mantissa_add[22:0]                        ;
               end
               end
                   else
               begin
                 sub_res[22:0] = mantissa_add[22:0]                        ;
               end
                 sub_res[31] = ~(sign_bit_a || sign_bit_b)                         ;
               end
             
             else
               
               begin
              if(exponent_a == exponent_b || mantissa_a == mantissa_b)
                    begin
                      sub_res[22:0] = mantissa_add[22:0]                        ;
                      sub_res[22:0] = mantissa_add[22:0] << 1                   ;
                      sub_res[30:23] = sub_res[30:23] - 1'b1                    ;
                    end
                else
                  begin
                    sub_res[22:0] = mantissa_add[22:0]                          ;
                  end
                 sub_res[31] = sign_bit_a ||  sign_bit_b                        ;
               end 
         
             
             
       //////   enabling encoder for shifting
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 final_sub_res = sub_res                                        ;
                 pr_enc_en = 1'b0                                               ;
               end
             else if(sub_res[30:0] == operand_A[30:0] || sub_res[30:0] == operand_B[30:0])
               begin
                 pr_enc_en = 1'b0                                               ;
                 final_sub_res = sub_res                                        ;
               end
             else
             begin
             pr_enc_en = 1'b1                                                   ;
             end
             
             if(interrupt_en)
             begin
             final_sub_res = enc_out_res                                        ;
             end
           end
         
         
         
         
         
         
         
      ///////   sign_bit_A = -ve     and   sign_bit_B = -ve   
         
        2'b11 :
           
           begin
             
      /////////    taking the 2's complement of op_A mantissa part
             
           mantissa_a_hidd = ~mantissa_a_hidd + 1                               ;
             
      ////////     adding the matissa part of both op_a and op_b
             
             {carry,mantissa_add[23:0]} = mantissa_a_hidd[23:0] + mantissa_b_hidd[23:0] ; 
             
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 sub_res = 32'd0                                                ;
               end
             
             else if(operand_A[30:0] > operand_B[30:0])                                                     
               begin 
                 mantissa_add[22:0] = ~mantissa_add[22:0] + 1                   ;
             
                   if(!carry)
               begin
                 
                     if(exponent_a == exponent_b || mantissa_a == mantissa_b)
               begin
                 sub_res[22:0] = mantissa_add[22:0]                             ;
                 sub_res[22:0] = mantissa_add[22:0] << 1                        ;
                 sub_res[30:23] = sub_res[30:23] - 1'b1                         ;
               end 
                        else
               begin
                 sub_res[22:0] = mantissa_add[22:0]                             ;
               end
               end
                   else
               begin
                 sub_res[22:0] = mantissa_add[22:0]                             ;
               end
                 sub_res[31] = sign_bit_a || sign_bit_b                         ;
               end
             
             else 
               
               begin
              if(exponent_a == exponent_b || mantissa_a == mantissa_b)
                    begin
                      sub_res[22:0] = mantissa_add[22:0]                        ;
                      sub_res[22:0] = mantissa_add[22:0] << 1                   ;
                 sub_res[30:23] = sub_res[30:23] - 1'b1                         ;
                    end
                 else
                   begin
                     sub_res[22:0] = mantissa_add[22:0]                         ;
                   end
                
                 sub_res[31] = ~(sign_bit_a &&  sign_bit_b)                        ;
               end
             
                                        
             
             //////   enabling encoder for shifting
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 final_sub_res = sub_res                                        ;
                 pr_enc_en = 1'b0                                               ;
               end
             else if(sub_res[30:0] == operand_A[30:0] || sub_res[30:0] == operand_B[30:0])
               begin
                 pr_enc_en = 1'b0                                               ;
                 final_sub_res = sub_res                                        ;
               end
             else
             begin
              pr_enc_en = 1'b1                                                  ;
             end
             
              if(interrupt_en)
             begin
             final_sub_res = enc_out_res                                        ;
             end
             
           end
           
           default
              final_sub_res = 32'd0                                             ;
           
         endcase
         
         
       end  //end if
else
    final_sub_res = 32'b0;
     
   end  
        
      
    
  
endmodule





///////////////////////////    priority encoder for shifting



module pr_encoder(
  input        [31:0]in_res           ,
  input        [23:0]mantissa_add_en  ,
  input              carry            ,
  input        en                     ,
  output  reg  interrupt_en           ,
  output  reg  [31:0]out_res
                 )                    ;

  wire [22:0]In_res_mantissa          ;
  wire  [7:0]In_res_exponent          ;
  
  assign  In_res_mantissa = in_res[22:0]               ;
  assign  In_res_exponent = in_res[30:23]              ;
  
  always@(*)
    begin
      
  
  if(en)
    begin
      
      casex({carry,mantissa_add_en[23],In_res_mantissa})
            
         25'b111xxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 0         ;
            out_res[30:23] = in_res[30:23] - 0        ;
            
          end
        
        25'b101xxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 1        ;
            out_res[30:23] = in_res[30:23] - 1        ;
            
          end
              
        25'b1001xxxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 2         ;
            out_res[30:23] = in_res[30:23] - 2        ;
           
          end
              
        25'b10001xxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 3         ;
            out_res[30:23] = in_res[30:23] - 3        ;
           
          end
              
        25'b100001xxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 4         ;
            out_res[30:23] = in_res[30:23] - 4        ;
            
          end
              
        25'b1000001xxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 5         ;
            out_res[30:23] = in_res[30:23] - 5        ;
            
          end
              
        25'b10000001xxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 6         ;
            out_res[30:23] = in_res[30:23] - 6        ;
            
          end
              
        25'b100000001xxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 7         ;
            out_res[30:23] = in_res[30:23] - 7        ;
            
          end
              
        25'b1000000001xxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 8         ;
            out_res[30:23] = in_res[30:23] - 8        ;
            
          end
              
        25'b10000000001xxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 9         ;
            out_res[30:23] = in_res[30:23] - 9        ;
                 
          end
              
        25'b100000000001xxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 10        ;
            out_res[30:23] = in_res[30:23] - 10       ;
            
          end
              
        25'b1000000000001xxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 11        ;
            out_res[30:23] = in_res[30:23] - 11       ;
            
          end
              
        25'b10000000000001xxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 12       ;
            out_res[30:23] = in_res[30:23] - 12      ;
           
          end
              
        25'b100000000000001xxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 13       ;
            out_res[30:23] = in_res[30:23] - 13      ;
            
          end
              
        25'b1000000000000001xxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 14       ;
            out_res[30:23] = in_res[30:23] - 14      ;
           
          end
              
        25'b10000000000000001xxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 15       ;
            out_res[30:23] = in_res[30:23] - 15      ;
            
          end
              
        25'b100000000000000001xxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 16       ;
            out_res[30:23] = in_res[30:23] - 16      ;
                                   
          end
              
        25'b1000000000000000001xxxxxx    :  
          begin
            out_res[22:0] = in_res[22:0] << 17       ;
            out_res[30:23] = in_res[30:23] - 17      ;
            
          end
              
        25'b10000000000000000001xxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 18       ;
            out_res[30:23] = in_res[30:23] - 18      ; 
         
          end
              
        25'b100000000000000000001xxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 19       ;
            out_res[30:23] = in_res[30:23] - 19      ;
           
          end
              
        25'b1000000000000000000001xxx    :
          begin
            out_res[22:0] = in_res[22:0] << 20       ;
            out_res[30:23] = in_res[30:23] - 20      ;
           
          end
              
        25'b10000000000000000000001xx    :
          begin
            out_res[22:0] = in_res[22:0] << 21       ;
            out_res[30:23] = in_res[30:23] - 21      ;
           
          end
              
        25'b100000000000000000000001x    : 
          begin
            out_res[22:0] = in_res[22:0] << 22       ;
            out_res[30:23] = in_res[30:23] - 22      ;
          
          end
              
        25'b1000000000000000000000001    :
          begin
            out_res[22:0] = in_res[22:0] << 23       ;
            out_res[30:23] = in_res[30:23] - 23      ;
           
          end
        
         
         25'b00xxxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 0        ;
            out_res[30:23] = in_res[30:23] - 0       ;
            
          end
        
        
        25'b011xxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 1         ;
            out_res[30:23] = in_res[30:23] - 1        ;
            
          end
              
        25'b0101xxxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 2         ;
            out_res[30:23] = in_res[30:23] - 2        ;
           
          end
              
        25'b01001xxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 3         ;
            out_res[30:23] = in_res[30:23] - 3        ;
           
          end
              
              
        25'b0100001xxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 5         ;
            out_res[30:23] = in_res[30:23] - 5        ;
            
          end
              
        25'b01000001xxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 6         ;
            out_res[30:23] = in_res[30:23] - 6        ;
            
          end
              
        25'b010000001xxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 7         ;
            out_res[30:23] = in_res[30:23] - 7        ;
            
          end
              
        25'b0100000001xxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 8         ;
            out_res[30:23] = in_res[30:23] - 8        ;
            
          end
              
        25'b01000000001xxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 9         ;
            out_res[30:23] = in_res[30:23] - 9        ;
                 
          end
              
        25'b010000000001xxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 10        ;
            out_res[30:23] = in_res[30:23] - 10       ;
            
          end
              
        25'b0100000000001xxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 11        ;
            out_res[30:23] = in_res[30:23] - 11       ;
            
          end
              
        25'b01000000000001xxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 12       ;
            out_res[30:23] = in_res[30:23] - 12      ;
           
          end
              
        25'b010000000000001xxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 13       ;
            out_res[30:23] = in_res[30:23] - 13      ;
            
          end
              
        25'b0100000000000001xxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 14       ;
            out_res[30:23] = in_res[30:23] - 14      ;
           
          end
              
        25'b01000000000000001xxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 15       ;
            out_res[30:23] = in_res[30:23] - 15      ;
            
          end
              
        25'b010000000000000001xxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 16       ;
            out_res[30:23] = in_res[30:23] - 16      ;
                                   
          end
              
        25'b0100000000000000001xxxxxx    :  
          begin
            out_res[22:0] = in_res[22:0] << 17       ;
            out_res[30:23] = in_res[30:23] - 17      ;
            
          end
              
        25'b01000000000000000001xxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 18       ;
            out_res[30:23] = in_res[30:23] - 18      ; 
         
          end
              
        25'b010000000000000000001xxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 19       ;
            out_res[30:23] = in_res[30:23] - 19      ;
           
          end
              
        25'b0100000000000000000001xxx    :
          begin
            out_res[22:0] = in_res[22:0] << 20       ;
            out_res[30:23] = in_res[30:23] - 20      ;
           
          end
              
        25'b01000000000000000000001xx    :
          begin
            out_res[22:0] = in_res[22:0] << 21       ;
            out_res[30:23] = in_res[30:23] - 21      ;
           
          end
              
        25'b010000000000000000000001x    : 
          begin
            out_res[22:0] = in_res[22:0] << 22       ;
            out_res[30:23] = in_res[30:23] - 22      ;
          
          end
              
        25'b0100000000000000000000001    :
          begin
            out_res[22:0] = in_res[22:0] << 23       ;
            out_res[30:23] = in_res[30:23] - 23      ;
           
          end
        
        25'b0100000000000000000000000    :
          begin
            out_res[22:0] = in_res[22:0] << 24      ;
            out_res[30:23] = in_res[30:23] - 24     ;
           
          end
              
              default 
              
              out_res = in_res                       ;                                         
                  
                  
      endcase
      out_res[31] = in_res[31]                       ;
      interrupt_en = 1'b1                            ;
    end
      
    end
  
endmodule


///////////////////////////////////////////  testbench


module tb();
  reg    [31:0]operand_A         ;
  reg    [31:0]operand_B         ;
  reg          sub_en            ;
  wire   [31:0]sub_res           ;
  
  
  float_sub uut(.operand_A(operand_A),.operand_B(operand_B),.sub_en(sub_en),.sub_res(sub_res))                 ;

 
  initial
    begin
      operand_A   = 32'd0        ;
      operand_B   = 32'd0        ;
      sub_en  = 1'b0             ;
    end
  
initial
begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

  initial
    begin
       operand_A  = 32'b01000000100100000000000000000000 ;  // 4.5
      operand_B  = 32'b01000000000101000111101011100001 ;  // 2.32
      sub_en = 1'b1 ;
      
      #10
      operand_A  = 32'b01000000100100000000000000000000 ; // 4.5
      operand_B  = 32'b01000000110010100011110101110001 ; // 6.32
      sub_en = 1'b1 ;
      
       #10
      operand_A  = 32'b01000000011000000000000000000000 ; // 3.5
      operand_B  = 32'b01000010100001000000000000000000 ; // 66
      sub_en = 1'b0 ;
      
       #10
      operand_A  = 32'b01000001101110000000000000000000 ; // 23
      operand_B  = 32'b01000010010111010100011110101110 ; // 55.32
      sub_en = 1'b1 ;
      
       #10
      operand_A  = 32'b01000000001000000000000000000000 ; // 2.5
      operand_B  = 32'b01000000001010001010001111010111 ; // 2.635
      sub_en = 1'b1 ;
  
      $monitor("final_add_res = %b",sub_res)                  ;
      
    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars ;
    end
endmodule

