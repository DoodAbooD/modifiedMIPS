module ALUTest;

    reg [31:0] in1,in2;
    wire [31:0] out;
    reg [3:0] control;
    wire z,o, clk;

//module ALU(in1,in2,out1,out2,o,z,control);
    ALU myALU(in1,in2,out, ,o,z,control);
    clock Clock(clk);

    reg [31:0] cycle;
    
    initial begin
		//PC_VALUE_ <= 0;	  
		cycle <= 0;

		
	end	

	always @(posedge clk) begin	
	/* Testing for all Control Signals
	0000 AND
	0001 OR
	0010 Unsigned Addition
	0011 Unsigned Subtraction
	0100 Set Less Than
	0101 Set Less Than Unsigned
	0111 NOR
	1000
	1001
	1010 Signed Addition
	1011 Signed Subtraction
	1100 Unsigned Multiply 
	1101 Unsigned Divide 
	1110 Signed Multiply 
	1111 Signed Divide 
	*/
	  case(cycle)
        
		  0: begin //0000 AND
				control = 4'b0000;
				in1 = 32'h55555555; // (0101 0101 0101 0101 0101 0101 0101 0101)
				in2 = 32'h000000F0; // (0000 0000 0000 0000 0000 0000 1111 0000)
				$strobe("result = : %h" , out, " The correct value is 00000050 | z = %b and o = %b", z,o); 
		  end
		  
		  1: begin //0001 OR
				control = 4'b0001;
				in1 = 32'h00000055; // (0000 0000 0000 0000 0000 0000 0101 0101)
				in2 = 32'h000000A0; // (0000 0000 0000 0000 0000 0000 1010 0000)
				$strobe("result = : %h" , out, " The correct value is 000000F5 | z = %b and o = %b", z,o); 
		
        end
        2: begin //0010 Unsigned Addition with overflow
            control = 4'b0010;
				in1 = 32'h80000055; // (1000 0000 0000 0000 0000 0000 0101 0101)
				in2 = 32'h80000001; // (1000 0000 0000 0000 0000 0000 0000 0001)
				$strobe("result = : %h" , out, " The correct value is 00000056 | overflow should occur! z = %b and o = %b", z,o); 
				
        end
        3: begin //0011 Unsigned Subtraction with overflow
            control = 4'b0011;
				in1 = 32'h00000055; // (0000 0000 0000 0000 0000 0000 0101 0101)
				in2 = 32'h00000001; // (0000 0000 0000 0000 0000 0000 0000 0001)
				$strobe("result = : %h" , out, " The correct value is FFFFFFAC | overflow should occur! z = %b and o = %b", z,o); 
        end
        4: begin //0011 Unsigned Subtraction with zero
            control = 4'b0011;
				in1 = 32'hF0FF0055; // (1111 0000 1111 1111 0000 0000 0101 0101)
				in2 = 32'hF0FF0055; // (1111 0000 1111 1111 0000 0000 0101 0101)
				$strobe("result = : %h" , out, " The correct value is 00000000 | zero should occur! z = %b and o = %b", z,o); 
        end
        5: begin
            
        end
        6: begin
            
        end
        7: begin
            
        end
        8: begin
            
        end
        9: begin
            
        end
        10: begin
            
        end
        11: begin
            
        end
        12: begin
            
        end
        default:   $stop; 


	  endcase
        
      
        
            
        cycle = cycle + 1;
		
	end



endmodule