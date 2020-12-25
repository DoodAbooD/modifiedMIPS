    /* Control Signals
    0000 AND | Single Float Add 
    0001 OR | Single Float Compare eq
    0010 Addition | Single Float Compare lt
    0011 Unsigned Subtraction | Single Float Compare le
    0100 Set Less Than | Double Float Add 
    0101 Set Less Than Unsigned | Double Float Compare eq
    0111 NOR | Double Float Compare lt
    1000 Shift Left | Double Float Compare le */


module fALUTest();
    reg [63:0] in1 , in2;
	 wire [63:0] out;
	 reg [3:0] control;
	 wire clk , con;
	 

    //module fALU(in1, in2, control, con, out);
    fALU myfALU(in1 , in2, control, con, out);
    //clock(clk);
    clock myClock(clk);
		
		
	 

    integer cycle = 0;

    always @(posedge clk) begin
	 
        case (cycle) 
            
				0: ;
				
				// Single Precision tests
				
            1:  begin
                in1[63:32] = 32'h3FA00000;
                in2[63:32] = 32'h3F900000;
                control = 4'b0000;
					 $strobe("first mantissa is %b" , myfALU.i1s_mant);
					 $strobe("second mantissa is %b" , myfALU.i2s_mant);

                $strobe("result = : %h" , out[63:32], " The correct value is 40180000"); 
            end

            2:  begin
                in1[63:32] = 32'h3C0C0923;
                in2[63:32] = 32'hBF929EED;
                control = 4'b0000;
                $strobe("result = : %h" , out[63:32], " The correct value is BF9186DB"); 
            end

            3:  begin
                in1[63:32] = 32'hD213D7E9;
                in2[63:32] = 32'hD0761229;
                control = 4'b0000;
                $strobe("result = : %h" , out[63:32], " The correct value is D223390C"); 
            end
				
				
				4:  begin
                in1[63:32] = 32'h43CE63D7;
                in2[63:32] = 32'h3F652867;
                control = 4'b0000;
                $strobe("result = : %h" , out[63:32], " The correct value is 43CED66B"); 
            end
				
				
				5:  begin
                in1[63:32] = 32'h43CE7E70;
                in2[63:32] = 32'hC3CE7E70;
                control = 4'b0000;
                $strobe("result = : %h" , out[63:32], " The correct value is 00000000"); 
            end
				
				
				// Double Precision tests
				
				
				

				
				
				
            
            
        endcase
		  cycle = cycle + 1;
    end




endmodule