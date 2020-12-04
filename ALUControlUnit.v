module ALUControlUnit(op, fun, aluSrc, hiloW, con, zEx);
    input [2:0] op;
    input [5:0] fun;
    output [3:0] con; // ALU Control Code
    output hiloW, zEx; // Writes to HI/LO Registers | Sets Zero Extend to immediate value
    output [1:0] aluSrc; //selects ALU source


    reg [3:0] con;
    reg hiloW, zEx;
    reg [1:0] aluSrc;

    always@(*) begin
        hiloW = 0;
        zEx = 0;
        case (op)
        2'b000: con = 4'b0010;  // Load / Store -> Add 
        2'b001: con = 4'b0011;  // Branch -> Unsigned Subtraction
        2'b010: begin // R-Type Integers
            case (fun)
            6'b100000: con = 4'b1010;  // R Add -> Signed Addition
            6'b010100: con = 4'b0000; // R And -> And
            6'b100001: con = 4'b1010; // R Load Word New -> Signed Addition
            6'b100111: con = 4'b0111; // R Nor -> NOR
            6'b100101: con = 4'b0001; // R or -> OR
            6'b101010: con = 4'b0100; // R slt -> slt
            6'b101011: con = 4'b0101; // R sltu -> sltu
            6'b000000: con = 4'b1000; // R sll -> sll
            6'b000010: con = 4'b1001; // R srl -> srl
            6'b010011: con = 4'b1010; // R Store Word New -> Signed Addition
            6'b100100: con = 4'b1011; // R Signed Sub -> Signed Sub
            6'b100010: con = 4'b0011; // R Unsigned Sub -> Unsigned Sub
            6'b011010: begin
                con = 4'b1111; // R Divide -> Signed Divide
                hiloW = 1; // Write to HI/LO Registers
            end
            6'b011011: begin
                con = 4'b1101; // R Unsigned Divide -> Unsigned Divide
                hiloW = 1; // Write to HI/LO Registers
            end

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
1000 Shift Left
1001 Shift Right
1010 Signed Addition
1011 Signed Subtraction
1100 Unsigned Multiply 
1101 Unsigned Divide 
1110 Signed Multiply 
1111 Signed Divide 
*/
