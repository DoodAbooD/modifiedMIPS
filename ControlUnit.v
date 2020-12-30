module ControlUnit(opCode, fun, fmt,
JR, Byte, Jump, MemWrite, RegWrite, Float, Shift, RegDst, DW, WBSrc, ExOp
);

input [5:0] opCode, fun;
input [4:0] fmt;
output JR, Byte, Jump, MemWrite, RegWrite, Float, Shift, DW;
output [1:0] RegDst;
output [2:0] ExOp, WBSrc;



always @(*) begin
    JR <= 0; Byte <=0; Jump <= 0; MemWrite <= 0; RegWrite <= 0;
    Float <= 0; Shift <= 0; RegDst <= 0; DW <= 0; WBSrc <= 0; ExOp <= 0;
    case (opCode)

    6'b000011: begin  // R-Type Instructions
    
    /* 
    Control Unit divides R Instructions into 6 different categories: 
     1- Writes Back to RD
     2- Writes Back to RT
     3- Writes Back to RD and uses Shift Value 
     4- Writes to Memory
     5- Does not Write back, though it could write to miscellaneous registers in EX stage like Hi/Lo
     6- Does not Write back, and activates a Jump  
     */
    
    // ExOp is common between all of them
        ExOp <= 3'b010; // Execution Stage opCode = 010 (Refer to ALUControlUnit.v)
  

        //Type 2
        if (fun == 6'b100001)  begin  // Load Word New
            RegWrite <= 1; // Writing to Register File
            RegDst <= 1; // Writing to Register Rt
            WBSrc <= 1; // From Memory 
        end

        //Type 4
        else if (fun == 6'b010011)   // Store Word New
            MemWrite <= 1;   // Writing to Memory     

        //Type 6
        else if (fun == 6'b011000) begin  // Jump Register
            JR <= 1; // Jump Register
            Jump <= 1; // Jump Instruction

        end
        //Type 3
        else if (fun < 4) begin // Shift instructions 
            RegWrite <= 1; // Writing to Register File
            Shift <= 1; // Using the Shift Value as operand instead of Rs
        end

        //Type 5
        else if (fun > 23 && fun < 28) ;  //  Divides and Multiplies
        // Nothing is activated (All default values)


        //Type 1
        else   // Remaining regular R instructions (Add, or .. etc)
            RegWrite <= 1; // Writing to Register File
        
    
     
    end 

    6'b001001: begin  // Add Immediate
        RegWrite <= 1; // Writing to RegisterFile
        RegDst <= 1; // Writing to Register Rt
        
    end

    6'b001100: begin  // And Immediate
        RegWrite <= 1; // Writing to Register File
        RegDst <= 1; // Writing to Register Rt
        ExOp <= 3'b100; // Execution Stage opCode = 100 (Refer to ALUControlUnit.v)
    end

    6'b000101:   // Branch on Equal
        ExOp <= 3'b001; // Execution Stage opCode = 001 (Refer to ALUControlUnit.v)
    

    6'b000100:   // Branch on Not Equal
        ExOp <= 3'b011; // Execution Stage opCode = 011 (Refer to ALUControlUnit.v)
    
    6'b000010:   // Jump 
        Jump <= 1; // Activate Jump Flag
    
    6'b000010: begin   // Jump and Link  
        Jump <= 1;  // Activate Jump Flag
        RegWrite <= 1; // Write to RegisterFile
        RegDst <= 3;  // Select Destination 3 (31)
        WBSrc <= 3;  // Writing Back the value of PC+4
    end

    6'b100010: begin   // Load Byte Unsigned
        Byte <= 1; // Writing a Byte only
        RegWrite <= 1; // Writing to RegisterFile
        RegDst <= 1; // Selecting Rt as Destination Register
        WBSrc <= 1;  // Writing Back the zero extended byte
        ExOp <= 3'b000; // EXopCode = 000
    end

    6'b001111: begin   // Load Upper Imm.
        RegWrite <= 1; // Writing to RegisterFile
        RegDst <= 1;  // Selecting Rt as Destination Register
        WBSrc <= 2; // Writing Back the shifted Immediate Value
    end

    6'b010010: begin   // Load Word
        RegWrite <= 1; // Writing to RegisterFile
        RegDst <= 1;  // Selecting Rt as Destination Register
        WBSrc <= 1; // Writing Back the read word from memory
        ExOp <= 3'b000; // EXopCode = 000
    end

    6'b001110: begin   // Or Immediate
        RegWrite <= 1; // Writing to RegisterFile
        RegDst <= 1; // Selecting Rt as Destination Register
        ExOp <= 3'b101; // EXopCode = 011
    end

    6'b101000: begin   // Store Byte
        Byte <=1; // Writing a Byte only
        MemWrite <= 1; // Storing in memory
        ExOp <= 3'b000; // EXopCode = 000
    end

    6'b101011: begin   // Store Word
        MemWrite <= 1; // Storing in memory
        ExOp <= 3'b000; // EXopCode = 000
    end



    6'b010001: begin  // FR / FI-Type Instructions 

        // ExOp is common between all of them
        ExOp <= 3'b111; // Execution Stage opCode = 111 (Refer to ALUControlUnit.v)

        if (fmt == 5'b01000) ; // Branch on FP True/False
        //nothing is needed, taken care of in Exec stage

        else if (fmt == 5'b10000) begin // FP Add Single / FP Compare Single
            if (fun == 0) begin // FP Add Single
                RegWrite <= 1; // Write to Register File
                Float <= 1; // Float instruction
                RegDst <= 2; // Select Fd as destination Register
            end

            else  // FP Compare Single
                Float <= 1; // Float instruction   
        end

        else if (fmt == 5'b10001) begin // FP Add Double / FP Compare Double
            DW <= 1;
            if (fun == 0) begin // FP Add Single
                RegWrite <= 1; // Write to Register File
                Float <= 1; // Float instruction
                RegDst <= 2; // Select Fd as destination Register
            end

            else  // FP Compare Double
                Float <= 1; // Float instruction  
        end
          
    end

    6'b110001: begin // Load FP Single
        RegWrite <= 1; // Writing to register
        Float <= 1;  // Float instruction
        RegDst <= 1;  // Selecting ft as destination register
        WBSrc <= 1;  // Selecting memory output as WB source
        ExOp <= 3'b000; // Execution stage op code
    end
    
    6'b110101: begin // Load FP Double
        RegWrite <= 1; // Writing to register
        Float <= 1;  // Float instruction
        RegDst <= 1;  // Selecting ft as destination register
        DW <= 1; // Double Precision
        WBSrc <= 1;  // Selecting memory output as WB source
        ExOp <= 3'b000; // Execution stage op code
        
    end

    6'b111001: begin // Store FP Single
        MemWrite <= 1; // Write to Memory
        Float <= 1; // Float instruction
        ExOp <= 3'b000; // Execution stage op code
    end

    6'b111101: begin // Store FP Single
        MemWrite <= 1; // Write to Memory
        Float <= 1; // Float instruction
        DW <= 0; // Double Precision
        ExOp <= 3'b000; // Execution stage op code
    end

    endcase
end


endmodule