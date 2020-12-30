module EXMEM ( clk,
iFlush, iByte, iWrite, iFloat,
iWBsrc, iMWrite, iDW,
iALUout1, iALUout2, iPcp4,
iRegOut1, iRegOut2, iDstReg, iIm,
oFlush, oByte, oWrite, oFloat,
oWBsrc, oMWrite, oDW,
oALUout1, oALUout2, oPcp4,
oRegOu1, oRegOut2, oDstReg, oIm
);


    input clk;

    input iFlush, iByte, iWrite, iFloat;
    input [1:0] iWBsrc;
    input iMWrite, iDW;
    input [31:0] iALUout1, iALUout2, iPcp4; 
    input [31:0] iRegOut1, iRegOut2, iIm;
    input [4:0] iDstReg;

    output oFlush, oByte, oWrite, oFloat;
    output [1:0] oWBsrc;
    output oMWrite, oDW;
    output [31:0] oALUout1, oALUout2, oPcp4; 
    output [31:0] oRegOut1, oRegOut2, oIm;
    output [4:0] oDstReg;

    reg internal_Flush, internal_Byte, internal_Write, internal_Float;
    reg [1:0] internal_WBsrc; 
    reg internal_MWrite, DW;
    reg [31:0] internal_ALUout1, internal_ALUout2, Pcp4;
    reg [31:0] internal_RegOut1, RegOut2, Im;
    reg [4:0] DstReg;

    assign oFlush = internal_Flush;
    assign oByte = internal_Byte; 
    assign oWrite = internal_Write; 
    assign oFloat = internal_Float;
    assign oWBsrc = internal_WBsrc;
    assign oMWrite = internal_MWrite;
    assign oDW = internal_DW;
    assign oALUout1 = internal_ALUout1;
    assign oALUout2 = internal_ALUout2;
    assign oPcp4 = internal_Pcp4;
    assign oRegOut1 = internal_RegOut1;
    assign oRegOut2 = internal_RegOut2; 
    assign oIm = internal_Im;
    assign oDstReg = internal_DstReg; 

    initial begin
        internal_Flush = 0;
        internal_Byte = 0;
        internal_Write = 0;
        internal_Float = 0;
        internal_WBsrc= 0;
        internal_MWrite = 0;
        internal_DW = 0;
        internal_ALUout1 = 0;
        internal_ALUout2 = 0;
        internal_Pcp4 = 0;
        internal_RegOut1 = 0;
        internal_RegOut2 = 0;
        internal_Im = 0;
        internal_DstReg = 0;
    end

    always @(posedge clk) begin
        internal_Flush <= iFlush;
        internal_Byte <= iByte;
        internal_Write <= iWrite;
        internal_Float <= iFloat;
        internal_WBsrc <= iWBsrc;
        internal_MWrite <= iMWrite;
        internal_DW <= iDW;
        internal_ALUout1 <= iALUout1;
        internal_ALUout2 <= iALUout2;
        internal_Pcp4 <= iPcp4;
        internal_RegOut1 <= iRegOut1;
        internal_RegOut2 <= iRegOut2;
        internal_Im <= iIm;
        internal_DstReg <= iDstReg;
    end

endmodule