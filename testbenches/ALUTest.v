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
		PC_VALUE_ <= 0;	  
		cycle <= 1;
	end	

	always @(posedge top.clk) begin	
/* Control Signals
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
        1: begin //0000 AND
           control = 4'b0000;
           in1 = 32'h55555555; // (0101 0101 0101 0101 0101 0101 0101 0101)
           in2 = 32'h000000F0; // (0000 0000 0000 0000 0000 0000 1111 0000)

           $display("result = : %h" , out, " The correct value is 50"); 
        end
        2: begin
            
        end
        3: begin
            
        end
        4: begin
            
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
        default:   $finish; ;


        endcase
        
      
        
            
        cycle = cycle + 1;
		
	end



endmodule