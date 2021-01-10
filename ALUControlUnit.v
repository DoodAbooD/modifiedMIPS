/* Control Signals
0000 AND | Single Float Add 
0001 OR | Single Float Compare eq
0010 Addition | Single Float Compare lt
0011 Unsigned Subtraction | Single Float Compare le
0100 Set Less Than | Double Float Add 
0101 Set Less Than Unsigned | Double Float Compare eq
0111 NOR | Double Float Compare lt
1000 Shift Left | Double Float Compare le
1001 Shift Right
1010 Shift Right Logical
1011 Signed Subtraction
1100 Unsigned Multiply 
1101 Unsigned Divide 
1110 Signed Multiply 
1111 Signed Divide 
*/

module ALUControlUnit(op, fun, fmt, ft,
 br, eqNe, brS, aluSrc, hiloR, hiloW,
con, hiloS, FPCw, zEx);
    input [2:0] op; // From Control Unit
    input [5:0] fun; // From Instruction
    input [4:0] fmt; // From Instruction
    input ft; //For Branch on FP instructions

    output br; // Branch Instruction
    output eqNe; // Branch is Equal or Not Equal / FP True or False
    output brS; // Branch source (Integer branch or Float branch)
    output [1:0] aluSrc; //selects ALU source
    output hiloR; // Reads from HI/LO (Sends values to MEM stage)
    output hiloW; //Writes to HI/LO Registers
    output [3:0] con; // ALU Control Code
    output hiloS; // Selects HI or LO register
    output FPCw; //Write to FPC register
    output zEx; // Sets Zero Extend for immediate value

    reg br, eqNe, brS, hiloR, hiloW, hiloS, FPCw, zEx;
    reg [1:0] aluSrc;
    reg [3:0] con;
    

    always@(*) begin
        br = 0; eqNe = 0; brS = 0; aluSrc = 0; hiloR = 0; hiloW = 0;
        con = 0; hiloS = 0; FPCw = 0; zEx = 0;

        case (op)
        3'b000: begin    // Loads / Stores / LoadFP & StoreFP (Single & Double) /  Add Immediate / Addiu (for now)-> Addition, ALU 2nd source is Im
            con = 4'b0010; 
            aluSrc = 2'b01; // Select immediate value
        end 

        3'b001: begin   // beq -> br , Unsigned Subtraction
            br = 1;
            con = 4'b0011;  
        end
        3'b011: begin  // bne -> br, eqNe, Unsigned Subtraction
            br = 1;
            eqNe = 1;
            con = 4'b0011;  
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
                con = 4'b1110;
                hiloW = 1; // Write to HI/LO Registers
            end 
            6'b011001: begin // R Unsigned Multiply -> Unsigned Mult. and Write to HI/LO
                con = 4'b1100;
                hiloW = 1; // Write to HI/LO Registers
            end
            6'b010000: begin // R Move from HI -> Read from HI/LO and Select HI
                hiloR = 1; // Pass value from HILO instead of ALU
                hiloS = 1; // Select HI register
            end
            6'b010010: begin // R Move from LO -> Read from HI/LO and Select LO
                hiloR = 1; // Pass value from HILO instead of ALU
                hiloS = 0; // Select LO register
            end
            
            endcase
        end

        3'b111: begin // FLoat R Instructions 
            case (fmt)
            6'b01000: begin // Branch on FP -> br, brS
                br = 1;
                brS = 1;
                eqNe = ~ft; // bc1t/bc1f
            end

            6'b10000: begin // Single Float Arithmetic
                case (fun)
                6'b000000: con = 4'b0000; // Add Single Float

                6'b110010: begin //  Single Float Compare eq
                    FPCw = 1;
                    con = 4'b0001;
                end

                6'b111100: begin //  Single Float Compare lt
                    FPCw = 1;
                    con = 4'b0010;
                end
                
                6'b111110: begin //  Single Float Compare le
                    FPCw = 1;
                    con = 4'b0011;
                end

                endcase
            end

            6'b10001: begin // Double Float Arithmetic

                case (fun)
                6'b000000: con = 4'b0100; // Add Double Float

                6'b110010: begin //  Double Float Compare eq
                    FPCw = 1;
                    con = 4'b0101;
                end

                6'b111100: begin //  Double Float Compare lt
                    FPCw = 1;
                    con = 4'b0111;
                end
                
                6'b111110: begin //  Double Float Compare le
                    FPCw = 1;
                    con = 4'b1000;
                end

                endcase                
            
            
            end

            endcase

        end



        endcase

    end

endmodule