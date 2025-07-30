module floating_div(
                       input  [31:0]operand_A           ,
                       input  [31:0]operand_B           ,
                       input        en                  ,
                       output reg   div_by_zero         , 
                       output reg   overflow            ,
                       output reg   underflow           ,
                       output reg [31:0]div_res  
                    );
  
  
   //// creating a sign , [7:0]exponent , [22:0]mantissa  bits for operand_A
  
  wire          sign_bit_a                 ;
  wire     [7:0]exponent_a                 ;
  wire     [22:0]mantissa_a                ;
  
  //// creating a sign , [7:0]exponent , [22:0]mantissa  bits for operand_B
  
  wire          sign_bit_b                 ;
  wire     [7:0]exponent_b                 ;
  wire     [22:0]mantissa_b                ;
  
  ////  reg to store hidden bit 
  reg      [23:0]mantissa_a_hidd           ;
  reg      [23:0]mantissa_b_hidd           ;
  
  /////  taking a parameter constant BIAS 
  parameter [7:0]bias = 8'd127             ;
  
   /////  register to store subtraction of exponents
  reg      [7:0]exponent_sub               ;
  reg           carry                      ;
  

  
  /////   to store mantissa division   
  reg      [23:0]mantissa_div              ;
  
  
   //// operand_A - extraction of sign , [7:0]exponent , [22:0]mantissa  bits
  
  assign sign_bit_a = operand_A[31]        ;
  assign exponent_a = operand_A[30:23]     ;
  assign mantissa_a = operand_A[22:0]      ;
  
   //// operand_B - extraction of sign , [7:0]exponent , [22:0]mantissa  bits
  
  assign sign_bit_b = operand_B[31]        ;
  assign exponent_b = operand_B[30:23]     ;
  assign mantissa_b = operand_B[22:0]      ;
  
  
  always@(*)
    begin
      
      if(en)
        begin
          
           /////  considering the hidden bit 1 for multiplication 
          mantissa_a_hidd = {1'b1 , mantissa_a};
          mantissa_b_hidd = {1'b1 , mantissa_b};
          
          if(operand_A == 32'd0)        ///////   if numerator is zero o/p is zero
            begin
              div_res = 32'd0 ;
            end
          
          else if(operand_B == 32'd0)   /////     if denominator is zero reporting div_by_zero error
            begin
              div_by_zero = 1'b1    ;
            end
          
          else                          /////     if none of the operands are zero normal division operation
            begin
              
              ///////////   doing sign bit 
              div_res[31] = sign_bit_a ^ sign_bit_b                      ;
              
              //////////    calculating exponent result  
              /////////     subtracting the exponents and adding bias value
                    
              exponent_sub = (exponent_a + (~exponent_b + 1'b1) )   ;
              
              if(exponent_a > exponent_b)
                begin
                  exponent_sub = bias + exponent_sub                ;
                end
              else 
                begin
                  exponent_sub = ( bias - (~exponent_sub + 1'b1) )  ;
                end
              
              
              
              
              ////////       reporting any overflow or underflow happening 
              if(exponent_a > exponent_b)
                begin
                  if(exponent_sub == 8'b11111111)
                    begin
                      overflow = 1'b1                                     ;
                    end
                  else
                    begin
                      overflow = 1'b0                                     ;
                    end
                end
              else if(exponent_a < exponent_b)
                begin
                  if(exponent_sub == 8'b11111111)
                    begin
                      underflow = 1'b1                                     ;
                    end
                  else
                    begin
                      underflow = 1'b0                                     ;
                    end
                end
                           
      /////////////   dividing the mantissa         
              
      mantissa_div = mantissa_a_hidd % mantissa_b_hidd                     ;
              
              
      //////////      final result        
              if(mantissa_div[23] == 1'b0)
                begin
              div_res = {div_res[31],exponent_sub,mantissa_div[22:0]}                    ;
                end 
              else 
                begin
                  div_res = {div_res[31],exponent_sub,mantissa_div[23:1]}                    ;  
                end
              
               
              
              
            end //// else block
          
        end    //// if block (en)
else
     div_res=32'b0;
      
    end        //// always block
  
endmodule


//////////////////////////       testbench

/*module tb();
  reg  [31:0]operand_A ;
  reg  [31:0]operand_B ;
  reg        en        ;
  wire      div_by_zero;
  wire      overflow   ;
  wire      underflow  ;
  wire [31:0]div_res  ;
  
  floating_div uut(.operand_A(operand_A) , .operand_B(operand_B) , .en(en) ,.div_by_zero(div_by_zero) , .overflow(overflow) , .underflow(underflow) , .div_res(div_res));
 
initial 
begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

  initial
    begin
      operand_A = 32'd0  ;
      operand_B = 32'd0  ;
      en        = 1'b0   ;
    end
  
  initial
    begin
      operand_A = 32'b10111111010011001100110011001101 ;  // -0.8
      operand_B = 32'b10111111000000000000000000000000 ;  // -0.5
      en        = 1'b1 ;
      
      $monitor("div_result = %h" , div_res);
      
      #10
      
      operand_A = 32'h41200000 ;  // 10
      operand_B = 32'h40a00000 ;  // 5
      en        = 1'b1 ;
      
       $monitor("div_result = %h" ,div_res);   
      
      #10
      
      operand_A = 32'b01000000000000000000000000000000 ;  // 2
      operand_B = 32'b01000000000000000000000000000000 ;  // 2
      en        = 1'b1 ;
      
       $monitor("div_result = %h" , div_res);
      
      #10
      
       #10
      
      operand_A = 32'b01000001101111010101110000101001 ;  // 23.67
      operand_B = 32'b01000010000010100100011110101110 ;  // 34.57
      en        = 1'b1 ;
      
       $monitor("div_result = %h" , div_res);
      
      #10
      
       #10
      
      operand_A = 32'b00111111000011000100100110111010 ;  // 0.5480
      operand_B = 32'b00111111000011000100100110111010 ;  // 0.5480
      
      en        = 1'b1 ;
           
       $monitor("div_result = %h" , div_res);
      
      #10
      
      operand_A = 32'b01111111011111111111111111111111 ;  // 3.40 * 10^38
      operand_B = 32'b01111111011111111111111111111111 ;  // 3.40 * 10^38
      en        = 1'b0 ;
           
       $monitor("div_result = %h" , div_res);
      #10 $finish ;
      
     
    end

endmodule*/

