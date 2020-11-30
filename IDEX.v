module IDEX(clk, 
iRWrite, iFloat, 
iWBsrc, iMWrite
iHiLoWrite,  iHL,
iALUs, iALUc,
iRegOut1, iRegOut2, 
iDstReg,

oRWrite, oFloat, 
oWBsrc, oMWrite
oHiLoWrite, oHL, 
oALUs, oALUc,
oRegOut1, oRegOut2, 
oDstReg,
);
    input clk;

    input iRWrite,iFloat;
    input [1:0] iWBsrc;
    input iMWrite;
    input iHiLoWrite, iHL;
    input [1:0] iALUs;
    input [3:0] iALUc;
    input [31:0] iRegOut1, iRegOut2;
    input [4:0] iDstReg;

    output oRWrite,oFloat;
    output [1:0] oWBsrc;
    output oMWrite;
    output oHiLoWrite, oHL;
    output [1:0] oALUs;
    output [3:0] oALUc;
    output [31:0] oRegOut1, oRegOut2;
    output [4:0] oDstReg;

    reg internal_RWrite,internal_Float;
    reg [1:0] internal_WBsrc;
    reg internal_MWrite;
    reg internal_HiLoWrite, internal_HL;
    reg [1:0] internal_ALUs;
    reg [3:0] internal_ALUc;
    reg [31:0] internal_RegOut1, internal_RegOut2;
    reg [4:0] internal_DstReg;
    
    assign oRWrite = internal_RWrite;
    assign oFloat = internal_Float;
    assign oWBsrc = internal_WBsrc;
    assign oMWrite = internal_MWrite;
    assign oHiLoWrite = internal_HiLoWrite;
    assign oHL = internal_HL;
    assign oALUs = internal_ALUs;
    assign oALUc = internal_ALUc;
    assign oRegOut1 = internal_RegOut1;
    assign oRegOut2 = internal_RegOut2;
    assign oDstReg = internal_DstReg;


    initial begin
        internal_RWrite = 0;
        internal_Float = 0;
        internal_WBsrc = 0;
        internal_MWrite = 0;
        internal_HiLoWrite = 0;
        internal_HL = 0;
        internal_ALUs = 0;
        internal_ALUc = 0;
        internal_RegOut1 = 0;
        internal_RegOut2 = 0;
        internal_DstReg = 0;  
    end

    always @(posedge clk) begin
        internal_RWrite <= iRWrite;
        internal_Float <= iFloat;
        internal_WBsrc <= iWBsrc;
        internal_MWrite <= iMWrite;
        internal_HiLoWrite <= iHiLoWrite;
        internal_HL <= iHL;
        internal_ALUs <= iALUs;
        internal_ALUc <= iALUc;
        internal_RegOut1 <= iRegOut1;
        internal_RegOut2 <= iRegOut2;
        internal_DstReg <= iDstReg;
    end

endmodule
