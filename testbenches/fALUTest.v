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
				

            6:  begin
                in1 = 64'h40109E6660F0B59C;
                in2 = 64'h4010BA02224BD249;
                control = 4'b0000;
                $strobe("result = : %h" , out, " The correct value is 4020AC34419E43F2"); 
            end

            7:  begin
                in1 = 64'h40109E6660F0B59C;
                in2 = 64'hC0B1D17CD10164DA;
                control = 4'b0000;
                $strobe("result = : %h" , out, " The correct value is C0B1CD55376928AD"); 
            end

            8:  begin
                in1 = 64'h3EB00D5AABBE29E6;
                in2 = 64'h3EBEF71923F4E584;
                control = 4'b0000;
                $strobe("result = : %h" , out, " The correct value is 3EC78239E7D987B5"); 
            end



				// Condition Tests

            9:  begin
                in1 = 64'h3EB00D5AABBE29E6;
                in2 = 64'h3EB00D5AABC55E93;
                control = 4'b0111; // less than 
                $strobe("condition = : %h" , con, " The correct value is 1"); 
            end

            10:  begin
                in1 = 64'h41008851FB9E0611;
                in2 = 64'h41008851FB9E0610;
                control = 4'b0111; // less than 
                $strobe("condition = : %h" , con, " The correct value is 0"); 
            end

            11:  begin
                in1 = 64'h41008851FB9E0611;
                in2 = 64'h41008851FB9E0611;
                control = 4'b0111; // less than 
                $strobe("condition = : %h" , con, " The correct value is 0"); 
            end

            12:  begin
                in1 = 64'h41008851FB9E0611;
                in2 = 64'h41008851FB9E0611;
                control = 4'b1000; // less than or equal 
                $strobe("condition = : %h" , con, " The correct value is 1"); 
            end



            13:  begin
                in1[63:32] = 32'h43CE63D7;
                in2[63:32] = 32'h3F652867;
                control = 4'b0001; // eq
                $strobe("condition = : %h" , con, " The correct value is 0"); 
            end

            14:  begin
                in1[63:32] = 32'h43CE63D7;
                in2[63:32] = 32'h3F652867;
                control = 4'b0010; // lt
                $strobe("condition = : %h" , con, " The correct value is 1"); 
            end

            15:  begin
                in1[63:32] = 32'h43CE63D7;
                in2[63:32] = 32'h3F652867;
                control = 4'b0011; // le
                $strobe("condition = : %h" , con, " The correct value is 1"); 
            end

            16:  begin
                in1[63:32] = 32'h4902B8D9;
                in2[63:32] = 32'h4902B8D9;
                control = 4'b0001; // eq
                $strobe("condition = : %h" , con, " The correct value is 1"); 
            end

            17:  begin
                in1[63:32] = 32'h4902B8D9;
                in2[63:32] = 32'hD15F7FAF;
                control = 4'b0010; // lt
                $strobe("condition = : %h" , con, " The correct value is 0"); 
            end
            
            
            
        endcase
		  cycle = cycle + 1;
    end




endmodule