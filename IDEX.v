module IDEX(clk,
iRWrite, iFloat, 
iWBsrc, iMWrite
iALUop,
iRegOut1, iFun, iRegOut2, iRegOut3,
iFloat1P1, iFloat2P1,
iFmt, iDstReg, iIm

oRWrite, oFloat, 
oWBsrc, oMWrite
oALUop,
oRegOut1, oFun, oRegOut2, oRegOut3,
oFloat1P1, oFloat2P1,
oFmt, oDstReg, oIm
);
    input clk;

    input iRWrite, iFloat;
    input [1:0] iWBsrc;
    input iMWrite;
    input [1:0] iALUop;
    input [31:0] iRegOut1, iRegOut2, iRegOut3, iFloat1P1, iFloat2P1;
    input [5:0] iFun;
    input [4:0] iFmt, iDstReg;
    input [15:0] iIm;

    output oRWrite, oFloat;
    output [1:0] oWBsrc;
    output oMWrite;
    output [1:0] oALUop;
    output [31:0] oRegOut1, oRegOut2, oRegOut3, oFloat1P1, oFloat2P1;
    output [5:0] oFun;
    output [4:0] oFmt, oDstReg;
    output [15:0] oIm;

    reg internal_RWrite, internal_Float;
    reg [1:0] internal_WBsrc;
    reg internal_MWrite;
    reg [1:0] internal_ALUop;
    reg [31:0] internal_RegOut1, internal_RegOut2, internal_RegOut3;
    reg [31:0] internal_Float1P1, internal_Float2P1;
    reg [5:0] internal_Fun;
    reg [4:0] internal_Fmt, internal_DstReg;
    reg [15:0] internal_Im;

    assign oRWrite = internal_RWrite;
    assign oFloat = internal_Float;
    assign oWBsrc = internal_WBsrc;
    assign oMWrite = internal_MWrite;
    assign oALUop = internal_ALUop;
    assign oRegOut1 = internal_RegOut1;
    assign oRegOut2 = internal_RegOut2;
    assign oRegOut3 = internal_RegOut3;
    assign oFloat1P1 = internal_Float1P1;
    assign oFloat2P1 = internal_Float2P1;
    assign oFun = internal_Fun;
    assign oFmt = internal_Fmt;
    assign oDstReg = internal_DstReg;
    assign oIm = internal_Im;


    initial begin
        internal_RWrite = 0;
        internal_Float = 0;
        internal_WBsrc = 0;
        internal_MWrite = 0;
        internal_ALUop = 0;
        internal_RegOut1 = 0;
        internal_RegOut2 = 0;
        internal_RegOut3 = 0;
        internal_Float1P1 = 0;
        internal_Float2P1 = 0;
        internal_Fun = 0;
        internal_Fmt = 0;
        internal_DstReg = 0;  
        internal_Im = 0;
    end

    always @(posedge clk) begin
        internal_RWrite <= iRWrite;
        internal_Float <= iFloat;
        internal_WBsrc <= iWBsrc;
        internal_MWrite <= iMWrite;
        internal_ALUop <= iALUop;
        internal_RegOut1 <= iRegOut1;
        internal_RegOut2 <= iRegOut2;
        internal_RegOut3 <= iRegOut3;
        internal_Float1P1 <= iFloat1P1;
        internal_Float2P1 <= iFloat2P1;
        internal_Fun <= iFun;
        internal_Fmt <= iFmt;
        internal_DstReg <= iDstReg;
        internal_Im <= iIm;
    end

endmodule
