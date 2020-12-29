/*
stage1 : instruction fetch (IF)
stage2 : instruction decode and register fetch (ID)
stage3 : execuction stage (EXEC)
stage4 : memory stage (MEM)
stage5 : writeback stage (WB)
*/

module Top(PC_VALUE);// testbench holds the PC Value.
	input PC_VALUE;
	wire clk;
	clock Clock(clk);

	// *************************************************
	// **** WIRING OF STAGE 1 : INSTRUCTION FETCH ******
	// *************************************************
	
	//Wires
	wire [31:0] Branch_Address;
	wire Branch_Decision;
	wire [31:0] MUX1_Out;
	wire [31:0] Jump_Address;
	wire C_Out_Jump;
	wire [31:0] PCP4;
	wire [31:0] MUX2_Out;
	wire [31:0] PC_Out;
	wire [31:0] Instruction_Out;
	wire stall_enable;

	//Assignments and Simple Logic
	assign PCP4 = PC_Out + 4;

	//Modules
	MUX2_32 MUX1(PCP4, Branch_Address, Branch_Decision, MUX1_Out);
	MUX2_32 MUX2(MUX1_Out, Jump_Address, C_Out_Jump, MUX2_Out);
	PC ProgramCounter(MUX2_Out, PC_Out, clk, stall_enable);
	instructionMemory IM(Instruction_Out, PC_Out);

	// *************************************************
	// *************************************************

	
	// ******************* IF / ID *********************

	wire [25:0] IFID_Out_ad; //Address 
	wire [31:0] IFID_Out_Pcp4; // PC + 4
	wire [5:0] IFID_Out_Op; // OP Code
	wire [4:0] IFID_Out_RsFmt; // Register Rs or Format
	wire [4:0] IFID_Out_RtFt; // Register Rt or Register Ft
	wire [4:0] IFID_Out_RdFs; // Register Rd or Register Fs
	wire [4:0] IFID_Out_ShFd; // Shift amount or Register Fd
	wire [5:0] IFID_Out_fun; // Function
	wire [15:0] IFID_Out_Im; // Immediate Value

	//module IFID(clk, iPcp4, ins, oPcp4, op, rs_fmt, rt_ft, rd_fs, 
	//sh_fd, fun, im, ad , stall);
	IFID IF_ID(clk, PCP4, Instruction_Out, IFID_Out_Pcp4, IFID_Out_Op, IFID_Out_RsFmt,
	IFID_Out_RtFt, IFID_Out_RdFs, IFID_Out_ShFd, IFID_Out_fun, IFID_Out_Im, IFID_Out_ad, stall_enable);


	// *************************************************


	// *************************************************
	// **** WIRING OF STAGE 2 : INSTRUCTION DECODE *****
	// *************************************************

	//Wires
	//Control Unit Output Wires
	wire C_Out_JR; // Jump Register
	wire C_Out_Byte; // Store Byte
	wire C_Out_MemWrite; // Write to Memory
	wire C_Out_RegWrite; // Write to Register File
	wire C_Out_Float; // Float Instruction
	wire C_Out_Shift; // Shift Instruction
	wire [1:0] C_Out_RegDst; // Choose Destination Register
	wire C_Out_DW; // Double Write
	wire [2:0] C_Out_WBSrc; // Write Back Data Source
	wire [2:0] C_Out_ExOp; // ALU Operation
	//Register File Output Wires
	wire [31:0] RFile_Out_Out1;
	wire [31:0] RFile_Out_Out2;
	wire [31:0] RFile_Out_Out3;
	wire [31:0] RFile_Out_FOut1;
	wire [31:0] RFile_Out_FOut2;
	wire [31:0] RFile_Out_FOut1p1;
	wire [31:0] RFile_Out_FOut2p1;
	//MUX output wires
	wire [31:0] MUX4_Out;
	wire [31:0] MUX5_Out;
	wire [4:0] MUX6_Out;
	wire MUX7_Out;
	wire MUX8_Out;
	//Wires coming in from other stages
	wire IDEX_Out_Flush; // Flush signal from ID stage
	wire EXMEM_Out_Flush; // Flush signal from EX stage
	wire [31:0] MUX18_Out; // Write data at second location
	wire [31:0] MUX19_Out; // write data at first location
	wire [4:0] MEMWB_Out_DstReg; // Destination register coming back from WB stage
	wire MEMWB_Out_DW; // Double write coming back from WB Stage
	wire MEMWB_Out_Float; // Float coming back from WB Stage
	wire MEMWB_Out_Write; // Write enable coming back from WB Stage
	

	// Modules
	MUX_2_1 MUX3 ({IFID_Out_Pcp4[31:28], IFID_Out_ad , 2'b0} , RFile_Out_Out2, C_Out_JR , Jump_Address);
	ControlUnit Control_Unit(IFID_Out_Op, IFID_Out_fun, IFID_Out_RsFmt,
	C_Out_JR, C_Out_Byte, C_Out_Jump, C_Out_MemWrite, C_Out_RegWrite, C_Out_Float, 
	C_Out_Shift, C_Out_RegDst, C_Out_DW, C_Out_WBSrc, C_Out_ExOp);
	regFile registerFile(IFID_Out_RsFmt, IFID_Out_RtFt, IFID_Out_RdFs,
	MEMWB_Out_DstReg, MUX19_Out, (MEMWB_Out_Write & ~MEMWB_Out_Float), 
	RFile_Out_Out1, RFile_Out_Out2, RFile_Out_Out3,
	IFID_Out_RdFs, IFID_Out_RtFt, 
	MEMWB_Out_DstReg, MUX19_Out, MUX18_Out, 
	(MEMWB_Out_Float & MEMWB_Out_Write) , (MEMWB_Out_Float & MEMWB_Out_Write & MEMWB_Out_DW),
	RFile_Out_FOut1, RFile_Out_FOut2, RFile_Out_FOut1p1, RFile_Out_FOut2p1,
	clk);
	MUX_2_32 MUX4(RFile_Out_Out2, RFile_Out_FOut2, C_Out_Float, MUX4_Out);
	MUX_4_32 MUX5(RFile_Out_Out1, RFile_Out_FOut1, {27'b0, IFID_Out_ShFd} , 0, {C_Out_Shift, C_Out_Float} , MUX5_Out);
	MUX_4_5 MUX6(IFID_Out_RdFs, IFID_Out_RtFt, IFID_Out_ShFd, 5'b11111 , C_Out_RegDst, MUX6_Out);
	MUX_2_1 MUX7(C_Out_MemWrite, 1'b0, (IDEX_Out_Flush | EXMEM_Out_Flush) , MUX7_Out);
	MUX_2_1 MUX8(C_Out_RegWrite, 1'b0, (IDEX_Out_Flush | EXMEM_Out_Flush) , MUX8_Out);

	
	
	// *************************************************
	// *************************************************


	// ******************* ID / EX *********************

	wire IDEX_Out_MWrite; // Memory Write
	wire IDEX_Out_RWrite; // Register Write
	wire IDEX_Out_Byte; // Single Byte instruction
	wire IDEX_Out_Float; // Float instruction
	wire [1:0] IDEX_Out_WBsrc; // Write back data source
	wire IDEX_Out_DW; // Double Write flag
	wire [31:0] IDEX_Out_Pcp4; // PC + 4
	wire [2:0] IDEX_Out_ExOp; // ALU Operation
	wire [31:0] IDEX_Out_RegOut1; // Register Value 1
	wire [31:0] IDEX_Out_RegOut2; // Register Value 2
	wire [31:0] IDEX_Out_RegOut3; // Register Value 3
	wire [5:0] IDEX_Out_fun; // Function
	wire [31:0] IDEX_Out_Float1P1; // Float register at address1 + 1
	wire [31:0] IDEX_Out_Float2P1; // Float register at address2 + 1
	wire [4:0] IDEX_Out_Fmt; // Format
	wire [4:0] IDEX_Out_Ft; // Register Ft
	wire [15:0] IDEX_Out_Im; // Immediate Value
	wire [4:0] IDEX_Out_DstReg; // Destination Register
	wire [4:0] IDEX_Out_Rd; // Register Rd

		/*
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
	*/
	IDEX ID_EX(clk, stall_enable, 
	C_Out_Jump, 
	MUX8_Out, C_Out_Byte, C_Out_Float,
	C_Out_WBSrc, MUX7_Out, C_Out_DW,
	IFID_Out_Pcp4, C_Out_ExOp, 
	MUX5_Out, IFID_Out_fun, MUX5_Out, RFile_Out_Out3,
	RFile_Out_FOut1p1, RFile_Out_FOut2p1,
	IFID_Out_RsFmt, IFID_Out_RtFt, MUX6_Out, IFID_Out_Im, IFID_Out_RdFs,
	IDEX_Out_Flush, 
	IDEX_Out_RWrite, IDEX_Out_Byte, IDEX_Out_Float,
	IDEX_Out_WBsrc, IDEX_Out_MWrite, IDEX_Out_DW,
	IDEX_Out_Pcp4, IDEX_Out_ExOp,
	IDEX_Out_RegOut1, IDEX_Out_fun, IDEX_Out_RegOut2, IDEX_Out_RegOut3,
	IDEX_Out_Float1P1, IDEX_Out_Float2P1, 
	IDEX_Out_Fmt, IDEX_Out_Ft, IDEX_Out_DstReg, IDEX_Out_Im, IDEX_Out_Rd)
	

	// *************************************************
	

endmodule 

