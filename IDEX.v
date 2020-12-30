module IDEX(clk, stall,
iFlush,
iRWrite, iByte, iFloat, 
iWBsrc, iMWrite ,iDW,
iPcp4, iExOp,
iRegOut1, iFun, iRegOut2, iRegOut3,
iFloat1P1, iFloat2P1,
iFmt, iFt, iDstReg, iIm, iRd,

oFlush,
oRWrite, oByte, oFloat, 
oWBsrc, oMWrite , oDW,
oPcp4, oExOp,
oRegOut1, oFun, oRegOut2, oRegOut3,
oFloat1P1, oFloat2P1,
oFmt, oFt, oDstReg, oIm, oRd
);
    input clk, stall;

    input iFlush, iRWrite, iByte, iFloat, iDW;
    input [2:0] iWBsrc;
    input iMWrite;
    input [31:0] iPcp4;
    input [2:0] iExOp;
    input [31:0] iRegOut1, iRegOut2, iRegOut3, iFloat1P1, iFloat2P1;
    input [5:0] iFun;
    input [4:0] iFmt, iFt, iDstReg, iRd;
    input [15:0] iIm;

    output oFlush, oRWrite, oByte, oFloat, oDW;
    output [2:0] oWBsrc;
    output oMWrite;
    output [31:0] oPcP4;
    output [2:0] oExOp;
    output [31:0] oRegOut1, oRegOut2, oRegOut3, oFloat1P1, oFloat2P1;
    output [5:0] oFun;
    output [4:0] oFmt, oFt, oDstReg, oRd;
    output [15:0] oIm;


    reg internal_Flush, internal_RWrite, internal_Byte, internal_Float, internal_DW;
    reg [2:0] internal_WBsrc;
    reg internal_MWrite;
    reg [31:0] internal_Pcp4;
    reg [1:0] internal_ExOp;
    reg [31:0] internal_RegOut1, internal_RegOut2, internal_RegOut3;
    reg [31:0] internal_Float1P1, internal_Float2P1;
    reg [5:0] internal_Fun;
    reg [4:0] internal_Fmt, internal_Ft, internal_DstReg, internal_Rd;
    reg [15:0] internal_Im;

    assign oFlush = internal_Flush;
    assign oRWrite = internal_RWrite;
    assign oByte = internal_Byte;
    assign oFloat = internal_Float;
    assign oWBsrc = internal_WBsrc;
    assign oMWrite = internal_MWrite;
    assign oDW = internal_DW;
    assign oPcP4 = internal_Pcp4;
    assign oExOp = internal_ExOp;
    assign oRegOut1 = internal_RegOut1;
    assign oRegOut2 = internal_RegOut2;
    assign oRegOut3 = internal_RegOut3;
    assign oFloat1P1 = internal_Float1P1;
    assign oFloat2P1 = internal_Float2P1;
    assign oFun = internal_Fun;
    assign oFmt = internal_Fmt;
    assign oFt = internal_Ft;
    assign oDstReg = internal_DstReg;
    assign oIm = internal_Im;
    assign oRd = internal_Rd;


    initial begin
        internal_Flush = 0;
        internal_RWrite = 0;
        internal_Byte = 0;
        internal_Float = 0;
        internal_WBsrc = 0;
        internal_MWrite = 0;
        internal_DW = 0;
        internal_Pcp4 = 0;
        internal_ExOp = 0;
        internal_RegOut1 = 0;
        internal_RegOut2 = 0;
        internal_RegOut3 = 0;
        internal_Float1P1 = 0;
        internal_Float2P1 = 0;
        internal_Fun = 0;
        internal_Fmt = 0;
        internal_Ft = 0;
        internal_DstReg = 0;  
        internal_Im = 0;
        internal_Rd = 0;
    end

    always @(posedge clk) begin
        if (~stall) begin
            internal_Flush <= iFlush;
            internal_RWrite <= iRWrite;
            internal_Byte <= iByte;
            internal_Float <= iFloat;
            internal_WBsrc <= iWBsrc;
            internal_MWrite <= iMWrite;
            internal_Pcp4 <= iPcp4;
            internal_ExOp <= iExOp;
            internal_DW <= iDW;
            internal_RegOut1 <= iRegOut1;
            internal_RegOut2 <= iRegOut2;
            internal_RegOut3 <= iRegOut3;
            internal_Float1P1 <= iFloat1P1;
            internal_Float2P1 <= iFloat2P1;
            internal_Fun <= iFun;
            internal_Fmt <= iFmt;
            internal_Ft <= iFt;
            internal_DstReg <= iDstReg;
            internal_Im <= iIm;
            internal_Rd <= iRd;
        end
    end

endmodule
