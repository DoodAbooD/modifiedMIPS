/* Control Signals
0000 AND
0001 OR
0010 Addition
0011 Unsigned Subtraction
0100 Set Less Than
0101 Set Less Than Unsigned
0111 NOR
1000 Shift Left
1001 Shift Right
1010 Shift Right Logical
1011 Signed Subtraction
1100 Unsigned Multiply 
1101 Unsigned Divide 
1110 Signed Multiply 
1111 Signed Divide 
*/

//in1 = rs
//in2 = rt and others

module ALU(in1,in2,out1,out2,o,z,control);
    input [31:0] in1, in2;
    input [3:0] control;
    output [31:0] out1, out2;
    output o,z;

    reg [31:0] out1, out2, helper1, helper2;  //helpers are used to temporarily store some values in signed mult/div operations
    reg o; //overflow
    reg z; //zero
    
    initial begin
        out1 = 0; out2 = 0; helper1 = 0; helper2 = 0; z = 0; o = 0;
    end

    always @(*) begin
    out1 = 0; out2 = 0; helper1 = 0; helper2 = 0; z = 0; o = 0;
        case(control) 
            
            // AND
            4'b0000: out1 = in1 & in2; 

            // OR
            4'b0001: out1 = in1 | in2; 
            
            // Unsigned Add with overflow calculation
            4'b0010: {o,out1} = in1 + in2; // place o at MSB of out, if it is set after addition then overflow occured
            
            // Unsigned Sub with overflow calculation
            4'b0011: begin  
                o = 1'b1;
                {o,out1} = {o,in2} - {1'b0,in1}; // place a 1 at the MSB of in2, see if its used when subtracting
                o = ~o;  // if it was used (it became 0), an overflow occured.
            end 

            //Signed SLT
            4'b0100: begin  
                if (in1[31] != in2[31])  //different sign
                    out1 = in1[31];   // result is 1 if in1 is negative (defintely less than positive)
                else if (in1[31] == 1'b1) // same sign
                    out1 = (in1 < in2)? 1 : 0;
            end         

            //Set Less Than Unsigned
            4'b0101: out1 = (in1 < in2)? 1 : 0;  
            
            // NOR
            4'b0111: out1 = ~(in1 | in2); 

            // Shift Left
            4'b1000: out1 = in2 << in1;

            // Shift Right
            4'b1001: out1 = in2 >> in1;
            
            
            // Shift Right Logical
            4'b1010: out1 = in2 >>> in1;

            // Signed Subtraction
            4'b1011: begin
                out1 = in2 - in1;
                if ( (in1[31] != in2[31]) && (in2[31] != out1[31]) ) o = 1; // if different sign inputs, and result sign changed from first operand (in2) --> overflow occured
            end

            //1100 Unsigned Multiply 
            4'b1100: {out2,out1} = in1 * in2;

            //1101 Unsigned Divide     
            4'b1101: begin
                if (in2) begin // if in2 is not zero
                    out1 = in1 / in2;
                    out2 = in1 % in2;
                end
                else begin
                    out1 = 0;
                    out2 = 0;
                    o = 1;  // here overflow and zero flag will both be set, indicating a division by zero exception
                end
                
            end
 
            //1110 Signed Multiply
            4'b1110: begin
                if ((!in1)||(!in2)) begin // catch multiplication by zero right away to prevent size mismatch problems when later taking 2's compliment 
                    out1 = 0;
                    out2 = 0;
                end
                else if ((in1[31] == in2[31])&&(in1[31] == 1'b0)) begin // both positive
                    {out2, out1} = in1 * in2;
                end 
                else if ((in1[31] == in2[31])&&(in1[31] == 1'b1)) begin // both negative
                    helper1 = (~in1) + 1; //2's compliment , convert both to positive. (temporarily in helper1 and 2)
                    helper2 = (~in2) + 1;
                    {out2, out1} = helper1 * helper2; // calculate positive multiplication result
                end
                else if (in1[31] == 1'b1) begin //first operand is negative
                    helper1 = (~in1) + 1; //2's compliment , convert first operant to positive. (temporarily in helper1)
                    {out2, out1} = helper1 * in2;
                    {out2, out1} = ~{out2, out1} + 1; // convert result to negative
                end
                else begin //second operand is negative
                    helper2 = (~in2) + 1; //2's compliment , convert second operant to positive. (temporarily in helper2)
                    {out2, out1} = in1 * helper2;
                    {out2, out1} = ~{out2, out1} + 1; // convert result to negative
                end                
            end

            //1111 Signed Divide 
            4'b1111: begin
                if (in2) begin //if in2 is not zero
                
                    if (!in1) begin // catch division of zero right away to prevent size mismatch problems when later taking 2's compliment 
                        out1 = 0;
                        out2 = 0;
                    end
                    else if ((in1[31] == in2[31])&&(in1[31] == 1'b0)) begin // both positive
                        out1 = in1 / in2;
                        out2 = in1 % in2;
                    end 
                    else if ((in1[31] == in2[31])&&(in1[31] == 1'b1)) begin // both negative
                        helper1 = (~in1) + 1; //2's compliment , convert both to positive. (temporarily in helper1 and 2)
                        helper2 = (~in2) + 1;
                        out1 = helper1 / helper2;
                        out2 = helper1 % helper2;
                    end
                    else if (in1[31] == 1'b1) begin //first operand is negative
                        helper1 = (~in1) + 1; //2's compliment , convert first operant to positive. (temporarily in helper1)
                        out1 = helper1 / in2;
                        out2 = helper1 % in2;
                        out1 = (~out1) + 1; // convert quotient to negative
                    end
                    else begin //second operand is negative
                        helper2 = (~in2) + 1; //2's compliment , convert second operant to positive. (temporarily in helper2)
                        out1 = in1 / helper2;
                        out2 = in1 % helper2;
                        out1 = (~out1) + 1; // convert quotient to negative
                    end                

            end
			
				default: ;
		  endcase

    //zero flag evaluation
    z = ((!out1)&&(!out2)); 
    end


endmodule
