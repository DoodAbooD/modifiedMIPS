module IDEX(clk,
iEqNe, iBranch, 
iRWrite, iFloat, 
iWBsrc, iMWrite
iHiLoWrite,  iHL,
iALUop,
iRegOut1, iFun, iRegOut2, iRegOut3,
iDstReg, iIm

oEqNe, oBranch, 
oRWrite, oFloat, 
oWBsrc, oMWrite
oHiLoWrite, oHL, 
oALUop,
oRegOut1, oFun, oRegOut2, oRegOut3,
oDstReg, oIm
);
    input clk;

    input iEqNe, iBranch;
    input iRWrite,iFloat;
    input [1:0] iWBsrc;
    input iMWrite;
    input iHiLoWrite, iHL;
    input [1:0] iALUop;
    input [31:0] iRegOut1, iRegOut2, iRegOut3;
    input [5:0] iFun;
    input [4:0] iDstReg;
    input [15:0] iIm;

    output oEqNe, oBranch;
    output oRWrite,oFloat;
    output [1:0] oWBsrc;
    output oMWrite;
    output oHiLoWrite, oHL;
    output [1:0] oALUop;
    output [31:0] oRegOut1, oRegOut2, oRegOut3;
    output [5:0] oFun;
    output [4:0] oDstReg;
    output [15:0] oIm;

    reg internal_EqNe, internal_Branch;
    reg internal_RWrite,internal_Float;
    reg [1:0] internal_WBsrc;
    reg internal_MWrite;
    reg internal_HiLoWrite, internal_HL;
    reg [1:0] internal_ALUop;
    reg [31:0] internal_RegOut1, internal_RegOut2, internal_RegOut3;
    reg [5:0] internal_Fun;
    reg [4:0] internal_DstReg;
    reg [15:0] internal_Im;

    assign oEqNe = internal_EqNe;
    assign oBranch = internal_Branch;
    assign oRWrite = internal_RWrite;
    assign oFloat = internal_Float;
    assign oWBsrc = internal_WBsrc;
    assign oMWrite = internal_MWrite;
    assign oHiLoWrite = internal_HiLoWrite;
    assign oHL = internal_HL;
    assign oALUop = internal_ALUop;
    assign oRegOut1 = internal_RegOut1;
    assign oRegOut2 = internal_RegOut2;
    assign oRegOut3 = internal_RegOut3;
    assign oFun = internal_Fun;
    assign oDstReg = internal_DstReg;
    assign oIm = internal_Im;


    initial begin
        internal_EqNe = 0;
        internal_Branch = 0;
        internal_RWrite = 0;
        internal_Float = 0;
        internal_WBsrc = 0;
        internal_MWrite = 0;
        internal_HiLoWrite = 0;
        internal_HL = 0;
        internal_ALUop = 0;
        internal_RegOut1 = 0;
        internal_RegOut2 = 0;
        internal_RegOut3 = 0;
        internal_Fun = 0;
        internal_DstReg = 0;  
        internal_Im = 0;
    end

    always @(posedge clk) begin
        internal_EqNe <= iEqNe;
        internal_Branch <= iBranch;
        internal_RWrite <= iRWrite;
        internal_Float <= iFloat;
        internal_WBsrc <= iWBsrc;
        internal_MWrite <= iMWrite;
        internal_HiLoWrite <= iHiLoWrite;
        internal_HL <= iHL;
        internal_ALUop <= iALUop;
        internal_RegOut1 <= iRegOut1;
        internal_RegOut2 <= iRegOut2;
        internal_RegOut3 <= iRegOut3;
        internal_Fun <= iFun;
        internal_DstReg <= iDstReg;
        internal_Im <= iIm;
    end

endmodule
