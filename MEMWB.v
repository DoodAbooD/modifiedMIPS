module MEMWB ( clk,
iWrite, iFloat,
iWBsrc, iDW,
iALUout1, iMemOut1, iMemOut2,
iPcp4, iIm, iDstReg, iALUout2, 

oWrite, oFloat,
oWBsrc, oDW,
oALUout1, oMemOut1, oMemOut2,
oPcp4, oIm, oDstReg, oALUout2 
);


    input clk;

    input iWrite, iFloat;
    input [1:0] iWBsrc;
    input iDW;
    input [31:0] iALUout1, iMemOut1, iMemOut2;
    input [31:0] iPcp4, iIm;
    input [4:0] iDstReg;
    input [31:0] iALUOut2;

    output oWrite, oFloat;
    output [1:0] oWBsrc;
    output oDW;
    output [31:0] oALUout1, oMemOut1, oMemOut2;
    output [31:0] oPcp4, oIm;
    output [4:0] oDstReg;
    output [31:0] oALUOut2;

    reg internal_Write, internal_Float;
    reg [1:0] internal_WBsrc;
    reg internal_DW;
    reg [31:0] internal_ALUout1, internal_MemOut1, internal_MemOut2;
    reg [31:0] internal_Pcp4, internal_Im;
    reg [4:0] internal_DstReg;
    reg [31:0] internal_ALUOut2;

    assign oWrite = internal_Write; 
    assign oFloat = internal_Float;
    assign oWBsrc = internal_WBsrc;
    assign oDW = internal_DW;
    assign oALUout1 = internal_ALUout1;
    assign oMemOut1 = internal_MemOut1;
    assign oMemOut2 = internal_MemOut2;
    assign oPcp4 = internal_Pcp4;
    assign oIm = internal_Im;
    assign oDstReg = internal_DstReg;
    assign oALUout2 = internal_ALUout2;
 

    initial begin
        internal_Write = 0; 
        internal_Float = 0;
        internal_WBsrc = 0;
        internal_DW = 0;
        internal_ALUout1 = 0;
        internal_MemOut1 = 0;
        internal_MemOut2 = 0;
        internal_Pcp4 = 0;
        internal_Im = 0;
        internal_DstReg = 0;
        internal_ALUout2 = 0;
    end

    always @(posedge clk) begin
        internal_Write <= iWrite; 
        internal_Float <= iFloat;
        internal_WBsrc <= iWBsrc;
        internal_DW <= iDW;
        internal_ALUout1 <= iALUout1;
        internal_MemOut1 <= iMemOut1;
        internal_MemOut2 <= iMemOut2;
        internal_Pcp4 <= iPcp4;
        internal_Im <= iIm;
        internal_DstReg <= iDstReg;
        internal_ALUout2 <= iALUout2;
    end

endmodule