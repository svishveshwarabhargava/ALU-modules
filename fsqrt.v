module  FloatingAddition(
  input  [31:0]A                  ,
  input  [31:0]B                  ,  
  input clk,
  output [31:0]result        

)                                         ;

wire           pr_enc_en_w                ;
wire     [31:0]add_res_w                  ;
  wire   [23:0]mantissa_add_w             ;
wire            carry_w                   ; 
  
wire      interrupt_en_w                  ;  
wire     [31:0]out_res_w                  ;  


  floating_add  floating_add_instance(
    
    .operand_A(A)                 ,
    .operand_B(B)                 ,
    .en(1'b1)                           ,
    .enc_out_res(out_res_w)               ,
    .interrupt_en(interrupt_en_w)         ,
    .pr_enc_en(pr_enc_en_w)               ,
    .add_res(add_res_w)                   ,
    .mantissa_add(mantissa_add_w)         ,
    .carry(carry_w)                       ,
    .final_add_res(result)               
    
                                    )     ;

  pr_encoder pr_encoder_instance(
  
    .in_res(add_res_w)                    ,
    .mantissa_add_en(mantissa_add_w)      ,
    .carry(carry_w)                       ,
    .en(pr_enc_en_w)                      ,
    .interrupt_en(interrupt_en_w)         ,
    .out_res(out_res_w)                               
                                )         ;
  
endmodule



module floating_add(
  
  input        [31:0]operand_A             , 
  input        [31:0]operand_B             ,
  input              en                    ,
  input        [31:0]enc_out_res           ,
  input              interrupt_en          ,
  output        reg  pr_enc_en             ,
  output   reg [31:0]add_res               ,
  output   reg [23:0]mantissa_add          ,
  output        reg  carry                 ,
  output   reg [31:0]final_add_res
  
  
  
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
              add_res[30:23] = exponent_a                                        ;
           end
  else
           begin
              mantissa_a_hidd = mantissa_a_hidd >> exponent_diff                 ;
              add_res[30:23] = exponent_b                                        ;
           end
         
         
         
 ////////  sign_bit_A = +ve    and     sign_bit_B = +ve        
         
  /////// main operation
         
         case(operation)
           
       2'b00 :
         begin
             
      //// doing sign_bit 
     
             add_res[31] = sign_bit_a && sign_bit_b                              ;
             
  //////  adding the two mantissa 
     
    
     {carry,mantissa_add[22:0]} = mantissa_a_hidd[22:0] + mantissa_b_hidd[22:0]  ;
          
             
     
      if(carry) 
       begin
         
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd )
           begin
         add_res[22:0]  = {carry,mantissa_add[22:0]} >> 1'b1                     ;
         add_res[30:23] = add_res[30:23] + 1'b1                                  ;
           end
         else
           begin
             add_res[22:0] = mantissa_add[22:0] >> 1'b1                          ;
             add_res[30:23] = add_res[30:23] + 1'b1                              ;
           end
       end
     else 
       begin
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd)
           begin
             add_res[22:0]  = mantissa_add[22:0] >> 1'b1                         ;
             add_res[30:23] = add_res[30:23] + 1'b1                              ;
           end
         else
           begin
             add_res[22:0]  = mantissa_add[22:0]                                 ;
             add_res[30:23] = add_res[30:23]                                     ;
           end
       end
             
           final_add_res = {{add_res[31]},{add_res[30:23]},{add_res[22:0]}}      ;  
           
         end
           
           
         
         
         
         
         
         
         
         
         
   ///////   sign_bit_A = -ve    and     sign_bit_B = -ve     
         
        2'b11  :
           begin
                          
     //// doing sign_bit 
     
             add_res[31] = sign_bit_a && sign_bit_b                              ;         
             
    //////  adding the two mantissa 
     
    
     {carry,mantissa_add[22:0]} = mantissa_a_hidd[22:0] + mantissa_b_hidd[22:0]  ;  
  
     if(carry) 
       begin
         
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd )
           begin
         add_res[22:0]  = {carry,mantissa_add[22:0]} >> 1'b1                     ;
         add_res[30:23] = add_res[30:23] + 1'b1                                  ;
           end
         else
           begin
             add_res[22:0] = mantissa_add[22:0] >> 1'b1                          ;
             add_res[30:23] = add_res[30:23] + 1'b1                              ;
           end
       end
             else 
       begin
         if(exponent_a == exponent_b || mantissa_a_hidd == mantissa_b_hidd)
           begin
             add_res[22:0]  = mantissa_add[22:0] >> 1'b1                         ;
             add_res[30:23] = add_res[30:23] + 1'b1                              ;
           end
         else
           begin
             add_res[22:0]  = mantissa_add[22:0]                                 ;
             add_res[30:23] = add_res[30:23]                                     ;
           end
       end
            
          
        final_add_res = {{add_res[31]},{add_res[30:23]},{add_res[22:0]}}         ;
             
           end
         
         
         
         
         
         
         
         
         
      ////////   sign_bit_A = +ve    and   sign_bit_B = -ve 
         
         2'b01  :
           begin
                          
      /////////    taking the 2's complement of op_B mantissa part
             
           mantissa_b_hidd = ~mantissa_b_hidd + 1                               ;
             
      ////////     adding the matissa part of both op_a and op_b
             
             {carry,mantissa_add[23:0]} = mantissa_a_hidd[23:0] + mantissa_b_hidd[23:0] ; 
           
            
             
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 add_res = 32'd0                                                ;
               end
  
             else if(operand_A[30:0] < operand_B[30:0])                                                     
               begin 
                 mantissa_add[22:0] = ~mantissa_add[22:0] + 1                   ;
             
                   if(!carry)
               begin
                 
                     if(exponent_a == exponent_b || mantissa_a == mantissa_b)
               begin
                 add_res[22:0] = mantissa_add[22:0]                             ;
                 add_res[22:0] = mantissa_add[22:0] << 1                        ;
                 add_res[30:23] = add_res[30:23] - 1'b1                         ;
               end 
                        else
               begin
                 add_res[22:0] = mantissa_add[22:0]                             ;
               end
               end
                   else
               begin
                 add_res[22:0] = mantissa_add[22:0]                             ;
               end
                 add_res[31] = sign_bit_a || sign_bit_b                         ;
               end
             
             else
               
               begin
              if(exponent_a == exponent_b || mantissa_a == mantissa_b)
                    begin
                      add_res[22:0] = mantissa_add[22:0]                        ;
                      add_res[22:0] = mantissa_add[22:0] << 1                   ;
                      add_res[30:23] = add_res[30:23] - 1'b1                    ;
                    end
                else
                  begin
                    add_res[22:0] = mantissa_add[22:0]                          ;
                  end
                 add_res[31] = sign_bit_a &&  sign_bit_b                        ;
               end 
         
             
             
       //////   enabling encoder for shifting
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 final_add_res = add_res                                        ;
                 pr_enc_en = 1'b0                                               ;
               end
             else if(add_res[30:0] == operand_A[30:0] || add_res[30:0] == operand_B[30:0])
               begin
                 pr_enc_en = 1'b0                                               ;
                 final_add_res = add_res                                        ;
               end
             else
             begin
             pr_enc_en = 1'b1                                                   ;
             end
             
             if(interrupt_en)
             begin
             final_add_res = enc_out_res                                        ;
             end
           end
         
         
         
         
         
         
         
      ///////   sign_bit_A = -ve     and   sign_bit_B = +ve   
         
        2'b10 :
           
           begin
                          
      /////////    taking the 2's complement of op_A mantissa part
             
           mantissa_a_hidd = ~mantissa_a_hidd + 1                               ;
             
      ////////     adding the matissa part of both op_a and op_b
             
             {carry,mantissa_add[23:0]} = mantissa_a_hidd[23:0] + mantissa_b_hidd[23:0] ;
             
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 add_res = 32'd0                                                ;
               end
             
             else if(operand_A[30:0] > operand_B[30:0])                                                     
               begin 
                 mantissa_add[22:0] = ~mantissa_add[22:0] + 1                   ;
             
                   if(!carry)
               begin
                 
                     if(exponent_a == exponent_b || mantissa_a == mantissa_b)
               begin
                 add_res[22:0] = mantissa_add[22:0]                             ;
                 add_res[22:0] = mantissa_add[22:0] << 1                        ;
                 add_res[30:23] = add_res[30:23] - 1'b1                         ;
               end 
                        else
               begin
                 add_res[22:0] = mantissa_add[22:0]                             ;
               end
               end
                   else
               begin
                 add_res[22:0] = mantissa_add[22:0]                             ;
               end
                 add_res[31] = sign_bit_a || sign_bit_b                         ;
               end
             
             else 
               
               begin
              if(exponent_a == exponent_b || mantissa_a == mantissa_b)
                    begin
                      add_res[22:0] = mantissa_add[22:0]                        ;
                      add_res[22:0] = mantissa_add[22:0] << 1                   ;
                 add_res[30:23] = add_res[30:23] - 1'b1                         ;
                    end
                 else
                   begin
                     add_res[22:0] = mantissa_add[22:0]                         ;
                   end
                
                 add_res[31] = sign_bit_a &&  sign_bit_b                        ;
               end
             
                                        
             
             ///////////////  enabling priority encoder  
             if(operand_A[30:0] == operand_B[30:0])
               begin
                 final_add_res = add_res                                        ;
                 pr_enc_en = 1'b0                                               ;
               end
             else if(add_res[30:0] == operand_A[30:0] || add_res[30:0] == operand_B[30:0])
               begin
                 pr_enc_en = 1'b0                                               ;
                 final_add_res = add_res                                        ;
               end
             else
             begin
              pr_enc_en = 1'b1                                                  ;
             end
             
              if(interrupt_en)
             begin
             final_add_res = enc_out_res                                        ;
             end
             
           end
           
           default
              final_add_res = 32'd0                                             ;
           
         endcase
         
         
       end
     
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
            out_res[30:23] = in_res[30:23] - 1       ;
            
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

///////////////////////////////////////

/*module FloatingAddition (input [31:0]A,
                         input [31:0]B,
                         input clk,
                         output reg  [31:0] result);

reg Sign;
reg [7:0] Exponent;
reg [22:0] Mantissa;

reg A_sign,B_sign,Temp_sign;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
reg [23:0] A_Mantissa,B_Mantissa,Temp_Mantissa;

reg carry,comp;
reg [7:0] exp_adjust;

always @(*)
begin
  
A_Mantissa = {1'b1,A[22:0]};
A_Exponent = A[30:23] ;
A_sign = A[31] ;
  
B_Mantissa = {1'b1,B[22:0]} ;
B_Exponent =  B[30:23] ;
B_sign =  B[31] ;

diff_Exponent = A_Exponent-B_Exponent;
B_Mantissa = (B_Mantissa >> diff_Exponent);
{carry,Temp_Mantissa} =  (A_sign ~^ B_sign)? A_Mantissa + B_Mantissa : A_Mantissa-B_Mantissa ; 
exp_adjust = A_Exponent;
if(carry)
    begin
        Temp_Mantissa = Temp_Mantissa>>1;
        exp_adjust = exp_adjust+1'b1;
    end
else
    begin
    while(Temp_Mantissa[23]==0)
        begin
           Temp_Mantissa = Temp_Mantissa<<1;
           exp_adjust =  exp_adjust-1'b1;
        end
    end
Sign = A_sign;
Mantissa = Temp_Mantissa[22:0];
Exponent = exp_adjust;
result = {Sign,Exponent,Mantissa};
end
endmodule*/





module FloatingMultiplication   (input [31:0]A,
                                 input [31:0]B,
                                 input clk,
                                 output reg  [31:0] result);


reg Sign;
reg [7:0] Exponent;
reg [22:0] Mantissa;

reg A_sign,B_sign;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
reg [23:0] A_Mantissa,B_Mantissa;
reg [47:0] Temp_Mantissa;

reg [6:0] exp_adjust;

always@(*)
begin
A_Mantissa = {1'b1,A[22:0]};
A_Exponent = A[30:23];
A_sign = A[31];
  
B_Mantissa = {1'b1,B[22:0]};
B_Exponent = B[30:23];
B_sign = B[31];

Temp_Exponent = A_Exponent+B_Exponent-127;
Temp_Mantissa = A_Mantissa*B_Mantissa;
Mantissa = Temp_Mantissa[47] ? Temp_Mantissa[46:24] : Temp_Mantissa[45:23];
Exponent = Temp_Mantissa[47] ? Temp_Exponent+1'b1 : Temp_Exponent;
Sign = A_sign^B_sign;
result = {Sign,Exponent,Mantissa};
end
endmodule





module FloatingDivision (input [31:0]A,
                         input [31:0]B,
                         input clk,
                         output [31:0] result);
                         
wire overflow,underflow;

reg Sign;
wire [7:0] exp;
reg [22:0] Mantissa;

reg A_sign,B_sign;
reg [23:0] A_Mantissa,B_Mantissa,Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
wire [7:0] Exponent;

reg [7:0] A_adjust,B_adjust;

wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,debug;
wire [31:0] reciprocal;
wire [31:0] x0,x1,x2,x3;
reg [6:0] exp_adjust; 
reg en1,en2,en3,en4,en5;

//----Initial value----
FloatingMultiplication M1(.A({{1'b0,8'd126,B[22:0]}}),.B(32'h3ff0f0f1),.clk(clk),.result(temp1));
assign debug = {1'b1,temp1[30:0]};
FloatingAddition A1(.A(32'h4034b4b5),.B({1'b1,temp1[30:0]}),.clk(clk),.result(x0));

//----First Iteration----
FloatingMultiplication M2(.A({{1'b0,8'd126,B[22:0]}}),.B(x0),.clk(clk),.result(temp2));
FloatingAddition A2(.A(32'h40000000),.B({!temp2[31],temp2[30:0]}),.clk(clk),.result(temp3));
FloatingMultiplication M3(.A(x0),.B(temp3),.clk(clk),.result(x1));

//----Second Iteration----
FloatingMultiplication M4(.A({1'b0,8'd126,B[22:0]}),.B(x1),.clk(clk),.result(temp4));
FloatingAddition A3(.A(32'h40000000),.B({!temp4[31],temp4[30:0]}),.clk(clk),.result(temp5));
FloatingMultiplication M5(.A(x1),.B(temp5),.clk(clk),.result(x2));

//----Third Iteration----
FloatingMultiplication M6(.A({1'b0,8'd126,B[22:0]}),.B(x2),.clk(clk),.result(temp6));
FloatingAddition A4(.A(32'h40000000),.B({!temp6[31],temp6[30:0]}),.clk(clk),.result(temp7));
FloatingMultiplication M7(.A(x2),.B(temp7),.clk(clk),.result(x3));

//----Reciprocal : 1/B----
assign Exponent = x3[30:23]+8'd126-B[30:23];
assign reciprocal = {B[31],Exponent,x3[22:0]};

//----Multiplication A*1/B----
FloatingMultiplication M8(.A(A),.B(reciprocal),.clk(clk),.result(result));
endmodule






module FloatingSqrt (input [31:0]A,
                     input Fsqrt_en,clk,
                     output reg [31:0] result);

wire overflow,underflow;

wire [7:0] Exponent;
wire [22:0] Mantissa;
wire Sign;
assign Sign = A[31];
assign Exponent = A[30:23];
assign Mantissa = A[22:0];

wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp;
wire [31:0] x0,x1,x2,x3;
wire [31:0] sqrt_1by05,sqrt_2;
wire [7:0] Exp_2,Exp_Adjust;
wire remainder;
wire pos;
assign x0 = 32'h3f5a827a;
assign sqrt_1by05 = 32'h3fb504f3;  // 1/sqrt(0.5)        // 1/sqrt(0.5) = sqrt(2)
assign sqrt_2 = 32'h3fb504f3;


//----First Iteration----
FloatingDivision D1(.A({1'b0,8'd126,Mantissa}),.B(x0),.clk(clk),.result(temp1));
FloatingAddition A1(.A(temp1),.B(x0),.clk(clk),.result(temp2));
assign x1 = {temp2[31],temp2[30:23]-1,temp2[22:0]};

//----Second Iteration----
FloatingDivision D2(.A({1'b0,8'd126,Mantissa}),.B(x1),.clk(clk),.result(temp3));
FloatingAddition A2(.A(temp3),.B(x1),.clk(clk),.result(temp4));
assign x2 = {temp4[31],temp4[30:23]-1,temp4[22:0]};

//----Third Iteration----
FloatingDivision D3(.A({1'b0,8'd126,Mantissa}),.B(x2),.clk(clk),.result(temp5));
FloatingAddition A3(.A(temp5),.B(x2),.clk(clk),.result(temp6));
assign x3 = {temp6[31],temp6[30:23]-1,temp6[22:0]};
FloatingMultiplication M1(.A(x3),.B(sqrt_1by05),.clk(clk),.result(temp7));

assign pos = (Exponent>=8'd127) ? 1'b1 : 1'b0;
assign Exp_2 = pos ? (Exponent-8'd127)/2 : (Exponent-8'd127-1)/2 ;
assign remainder = (Exponent-8'd127)%2;
assign temp = {temp7[31],Exp_2 + temp7[30:23],temp7[22:0]};

FloatingMultiplication M2(.A(temp),.B(sqrt_2),.clk(clk),.result(temp8));


always@(*)
begin
if(Fsqrt_en)
   begin
      result = remainder ? temp8 : temp;
   end
else
   result = 32'b0;
end
endmodule
