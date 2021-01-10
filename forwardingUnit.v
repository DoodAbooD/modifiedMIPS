module forwardingUnit(ID_Rs, ID_Rt, ID_Rd, 
EX_Dst, MEM_Dst, EX_Write, MEM_Write, EX_Float, MEM_Float, WBSrc,
FW_Rd, FW_Rt, FW_Rs, stall);

    input [4:0] ID_Rs, ID_Rt, ID_Rd, EX_Dst, MEM_Dst;
    input EX_Write, MEM_Write, EX_Float, MEM_Float;
    input [1:0] WBSrc;
    output [1:0] FW_Rd, FW_Rt, FW_Rs;
    output stall;

    reg [1:0] FW_Rd, FW_Rt, FW_Rs;
    reg stall;

    initial begin
        FW_Rd = 0;
        FW_Rt = 0;
        FW_Rs = 0; 
        stall = 0;
    end

    always @(*) begin
        FW_Rd = 0;
        FW_Rt = 0;
        FW_Rs = 0; 
        stall = 0;
        // Load and use Hazard (Stall Condition)
        //Rs
        if ((EX_Dst == ID_Rs) && (ID_Rs != 0) && (EX_Write) && (~ EX_Float) && ((WBSrc == 1) || (WBSrc == 2))) begin
            stall = 1;
        end
        //Rst
        else if ((EX_Dst == ID_Rt) && (ID_Rt != 0) && (EX_Write) && (~ EX_Float) && ((WBSrc == 1) || (WBSrc == 2))) begin
            stall = 1;
        end
        //Rd
        else if ((EX_Dst == ID_Rd) && (ID_Rd != 0) && (EX_Write) && (~ EX_Float) && ((WBSrc == 1) || (WBSrc == 2))) begin
            stall = 1;
        end
        

        // MEM-ALU Forwarding , no need to add the condition for not ALU-ALU forwarding, since it is checked afterwards and will overwrite value if satisfied
        // Rs 
        if ((MEM_Dst == ID_Rs) && (ID_Rs != 0) && (MEM_Write) && (~ MEM_Float)) begin
            FW_Rs = 2; 
        end
        // Rt    
        if  ((MEM_Dst == ID_Rt) && (ID_Rt != 0) && (MEM_Write) && (~ MEM_Float))  begin
            FW_Rt = 2;
        end
        // Rd    
        if  ((MEM_Dst == ID_Rd) && (ID_Rd != 0) && (MEM_Write) && (~ MEM_Float))  begin
            FW_Rd = 2;
        end


        // ALU-ALU Forwarding
        // Rs
        if ((EX_Dst == ID_Rs) && (ID_Rs != 0) && (EX_Write) && (~ EX_Float)) begin
            FW_Rs = 1; 
        end
        // Rt
        if ((EX_Dst == ID_Rt) && (ID_Rt != 0) && (EX_Write) && (~ EX_Float)) begin
            FW_Rt = 1;
        end
        // Rd
        if ((EX_Dst == ID_Rd) && (ID_Rd != 0) && (EX_Write) && (~ EX_Float)) begin
            FW_Rd = 1;
        end
    end

endmodule