module ALUControlUnit(op, fun,out);
    input [2:0] op;
    input [5:0] fun;
    output [3:0] out;

    reg [3:0] out;

    always@(*) begin

        case (op)
        2'b000: out = 4'b0010;  // Load / Store -> Add 
        2'b001: out = 4'b0011;  // Branch -> Unsigned Subtraction
        2'b010: begin // R-Type 
            case (fun)
            6'b100000: out = 4'b1010;  // R Add -> Signed Addition
            6'b010100: out = 4'b0000; // R And -> And
            6'b100001: out = 4'b1010; // R Load Word New -> signed Addition
            6'b100111: out = 4'b0111; // R Nor -> NOR
            6'b100101: out = 4'b0001; // R or -> OR
            //TODO rest of instructions
            endcase
        end 
        endcase

    end

endmodule

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
