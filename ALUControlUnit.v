/* ALU Operations
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

module ALUControlUnit(op, fun, br, eqNe, brS, aluSrc, hiloW, hiloR, hiloS, con, zEx, SnDb);
    input [2:0] op; // From Control Unit
    input [5:0] fun; // From Instruction

    output br; // Branch
    output eqNe; // Branch Equal or Not Equal (For Floating, FP True or False)
    output brS; // Branch condition Source (Zero Flag or FPC)
    output [3:0] con; // ALU Control Code
    output hiloW; // Write to HI/LO Registers
    output hiloR; // Read from HI/LO (Sends values to MEM stage)
    output hiloS; // Select HI or LO register
    output zEx; // Set Zero Extend for immediate value (Instead of Sign extend)
    output [1:0] aluSrc; //selects ALU source
    output SnDb; // Single or Double Instruction
    


    reg [3:0] con;
    reg br, eqNe, brS, hiloW, zEx, hiloR, hiloS, SnDb;
    reg [1:0] aluSrc;

    always@(*) begin
        br = 0; eqNe = 0; brS = 0;
        hiloW = 0; zEx = 0; aluSrc = 0; 
        hiloR = 0; hiloS = 0; SnDb = 0;
        case (op)
        3'b000: begin    // Loads / Stores / Add Immediate / Addiu (for now)-> Addition, ALU 2nd source is Im
            con = 4'b0010; 
            aluSrc = 2'b01; // Select immediate value
        end 

        3'b001: begin  // beq --> Unsigned Subtraction, set branch
            con = 4'b0011;
            br = 1;
        end
        3'b011: begin  // bne --> Unsigned Subtraction, set branch, set eqNe
            con = 4'b0011;
            br = 1;
            eqNe = 1;
        end

        3'b110: begin  // branch on FP True --> set branch, set branch source
            br = 1;
            brS = 1;
        end

        3'b111: begin  // branch on FP False --> set branch, set branch source, set eqNe
            br = 1;
            brS = 1;
            eqNe = 1;
        end


        3'b100: begin  // And Immediate -> And operation, Alu 2nd src is Immediate, Immediate is zero extended
            con = 4'b0000;
            aluSrc = 2'b01; // Select immediate value
            zEx = 1; //Zero extension
        end

        3'b101: begin  // Or Immediate -> Or operation, Alu 2nd src is Immediate, Immediate is zero extended
            con = 4'b0001;
            aluSrc = 2'b01; // Select immediate value
            zEx = 1; //Zero extension
        end

        3'b010: begin // Integers R-Type Ins.
            case (fun)
            6'b100000: con = 4'b0010;  // R Add -> Addition
            6'b010100: con = 4'b0000; // R And -> And
            6'b100001: begin    // R Load Word New -> Addition and ALU 2nd source is Rd
                con = 4'b0010; 
                aluSrc = 2'b10; // Rd to ALU
            end
            6'b010011:begin     // R Store Word New -> Addition and ALU 2nd source is Rd
                con = 4'b0010;
                aluSrc = 2'b10; // Rd to ALU
            end 
            6'b100111: con = 4'b0111; // R Nor -> NOR
            6'b100101: con = 4'b0001; // R or -> OR
            6'b101010: con = 4'b0100; // R slt -> slt
            6'b101011: con = 4'b0101; // R sltu -> sltu
            6'b000000: con = 4'b1000; // R sll -> sll
            6'b000010: con = 4'b1001; // R srl -> srl
            6'b000011: con = 4'b1010; // R sra -> sra
            6'b100100: con = 4'b1011; // R Signed Sub -> Signed Sub
            6'b100010: con = 4'b0011; // R Unsigned Sub -> Unsigned Sub
            6'b011010: begin    // R Divide -> Signed Divide and write to HI/LO
                con = 4'b1111; 
                hiloW = 1; // Write to HI/LO Registers
            end
            6'b011011: begin  // R Unsigned Divide -> Unsigned Divide and write to HI/LO
                con = 4'b1101; 
                hiloW = 1; // Write to HI/LO Registers
            end
            6'b011000: begin // R Multiply -> Signed Mult. and Write to HI/LO
                con = 4'b1111;
                hiloW = 1; // Write to HI/LO Registers
            end 
            6'b011001: begin // R Unsigned Multiply -> Unsigned Mult. and Write to HI/LO
                con = 4'b1100;
                hiloW = 1; // Write to HI/LO Registers
            end
            6'b010000: begin // R Move from HI -> Read from HI/LO and Select HI
                hiloR = 1; // Pass value from HILO instead of ALU
                hiloS = 0; // Select HI register
            end
            6'b010010: begin // R Move from LO -> Read from HI/LO and Select LO
                hiloR = 1; // Pass value from HILO instead of ALU
                hiloS = 1; // Select LO register
            end
            
            endcase
        end

        endcase

    end

endmodule

