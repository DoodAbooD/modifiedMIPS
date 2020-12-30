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
	PC program_counter(MUX2_Out, PC_Out, clk, stall_enable);
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
	registerFile regFile(IFID_Out_RsFmt, IFID_Out_RtFt, IFID_Out_RdFs,
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
	IDEX_Out_Fmt, IDEX_Out_Ft, IDEX_Out_DstReg, IDEX_Out_Im, IDEX_Out_Rd);
	

	// *************************************************
	

	// *************************************************
	// **** WIRING OF STAGE 3 : INSTRUCTION EXECUTE ****
	// *************************************************

	//Wires
	wire [31:0] MUX20_Out;
	wire [31:0] MUX21_Out;
	wire [31:0] MUX22_Out;
	wire ALUCU_Out_br; // is Branch
	wire ALUCU_Out_eqNe; // beq / bne
	wire ALUCU_Out_brS; // Branch Source
	wire [1:0] ALUCU_Out_aluSrc; // select ALU Source 
	wire ALUCU_Out_HiloR; // Read from Hi/Lo
	wire ALUCU_Out_hiloW; // Write to Hi/Lo
	wire [3:0] ALUCU_Out_Con; // ALU Control code
	wire ALUCU_Out_hiloS; // Selects Hi or Lo
	wire ALUCU_Out_FPCw; // Write to FPC
	wire ALUCU_Out_zEx; // Zero Extend rather than Sign Extend
	wire [31:0] MUX9_Out;
	wire [31:0] MUX10_Out;
	wire [31:0] LO_Out, HI_Out; // Output of LO and HI Registers
	wire [31:0] MUX11_Out;
	wire FPC_Out; // Output of FPC Register
	wire ALU_Out_Z; // Zero flag
	wire [31:0] ALU_Out_Out1; // First Output of ALU
	wire [31:0] ALU_Out_Out2; // Second Output of ALU
	wire fALU_con; // Condition from Floating ALU
	wire [63:0] fALU_out; // Output of FLoating ALU
	wire MUX12_Out; // Branch Condition
	wire MUX13_Out;  
	wire MUX16_Out;
	wire [1:0] Rs_Fwd_Control; // Controls forwarding of Register Rs value
	wire [1:0] Rt_Fwd_Control; // Controls forwarding of Register Rt value
	wire [1:0] Rd_Fwd_Control; // Controls forwarding of Register Rd value
	wire overflow;
	wire MUX14_Out;
	wire MUX15_Out;
	
	
	//Wires coming from other stages
	wire [31:0] EXMEM_Out_ALUout1; // EX Out
	wire [31:0] MUX_19_Out; // MEM Out
	wire EXMEM_Out_Write; // Write to Register File
	wire EXMEM_Out_Float; // Float Instruction
	wire [1:0] EXMEM_Out_WBsrc; // Write back data source select
	wire [4:0] EXMEM_Out_DstReg; // Destination Register from Exec Stage

	//Modules
	MUX_4_32 MUX20(IDEX_Out_RegOut1, EXMEM_Out_ALUout1, MUX19_Out, 0, Rd_Fwd_Control, MUX20_Out);
	MUX_4_32 MUX21(IDEX_Out_RegOut2, EXMEM_Out_ALUout1,MUX19_Out, 0, Rt_Fwd_Control, MUX21_Out);
	MUX_4_32 MUX22(IDEX_Out_RegOut3, EXMEM_Out_ALUout1, MUX19_Out,0, Rs_Fwd_Control, MUX22_Out);
	MUX_2_32 MUX9({{16{IDEX_Out_Im[15]}} ,IDEX_Out_Im}, {16'b0 ,IDEX_Out_Im}, ALUCU_Out_zEx, MUX9_Out);
	/*
	module ALUControlUnit(op, fun, fmt, ft,
	br, eqNe, brS, aluSrc, hiloR, hiloW,
	con, hiloS, FPCw, zEx);
	*/ 
	ALUControlUnit ALU_Control_Unit(IDEX_Out_ExOp, IDEX_Out_fun, IDEX_Out_Fmt, IDEX_Out_Ft[0], 
	ALUCU_Out_br, ALUCU_Out_eqNe, ALUCU_Out_brS, ALUCU_Out_aluSrc, ALUCU_Out_HiloR, ALUCU_Out_hiloW, 
	ALUCU_Out_Con, ALUCU_Out_hiloS, ALUCU_Out_FPCw, ALUCU_Out_zEx);
	// module reg32(in,out,w);
	reg32 LO(ALU_Out_Out1, LO_Out, ALUCU_Out_hiloW);
	reg32 HI(ALU_Out_Out2, HI_Out, ALUCU_Out_hiloW);
	MUX_2_32 MUX11(LO_Out, HI_Out, ALUCU_Out_hiloS, MUX11_Out);
	reg1 FPC(fALU_con, FPC_Out, ALUCU_Out_FPCw);
	assign Branch_Address = ({{16{IDEX_Out_Im[15]}} ,IDEX_Out_Im} << 2 ) + IDEX_Out_Pcp4;
	MUX_4_32 MUX10(MUX21_Out, MUX9_Out, MUX22_Out, 0, ALUCU_Out_aluSrc, MUX10_Out);
	//module ALU(in1,in2,out1,out2,o,z,control);
	ALU myALU (MUX20_Out, MUX10_Out, ALU_Out_Out1, ALU_Out_Out2, overflow, ALU_Out_Z, ALUCU_Out_Con);
	// module fALU(in1, in2, control, con, out);
	fALU myfALU( {MUX20_Out, IDEX_Out_Float1P1} , {MUX21_Out, IDEX_Out_Float2P1}, ALUCU_Out_Con, fALU_out);
	MUX_2_1 MUX12(ALU_Out_Z, FPC_Out, ALUCU_Out_brS, MUX12_Out);
	MUX_2_32 MUX13(ALU_Out_Out1, MUX11_Out, ALUCU_Out_HiloR, MUX13_Out);
	MUX_2_32 MUX16(MUX13_Out, fALU_out[63:32], IDEX_Out_Float, MUX16_Out);
	assign Branch_Decision = (ALUCU_Out_eqNe ^ MUX12_Out) & ALUCU_Out_br;
	MUX_2_1 MUX14(IDEX_Out_RWrite, 0, EXMEM_Out_Flush | stall_enable , MUX14_Out);
	MUX_2_1 MUX15(IDEX_Out_MWrite, 0, EXMEM_Out_Flush | stall_enable, MUX15_Out);
	/*
	module forwardingUnit(ID_Rs, ID_Rt, ID_Rd, 
	EX_Dst, MEM_Dst, EX_Write, MEM_Write, EX_Float, MEM_Float, WBSrc,
	FW_Rd, FW_Rt, FW_Rs, stall);
	*/
	forwardingUnit ForwardingUnit(IDEX_Out_Fmt, IDEX_Out_Ft, IDEX_Out_Rd,
	EXMEM_Out_DstReg, MEMWB_Out_DstReg, EXMEM_Out_Write, MEMWB_Out_Write, 
	EXMEM_Out_Float, MEMWB_Out_Float, EXMEM_Out_WBsrc,
	Rd_Fwd_Control, Rt_Fwd_Control, Rs_Fwd_Control, stall_enable);



	// *************************************************
	// *************************************************

	// ******************* EX / MEM ********************

	wire EXMEM_Out_Byte;
	wire EXMEM_Out_MWrite;
	wire EXMEM_Out_DW;
	wire [31:0] EXMEM_Out_ALUout2;
	wire [31:0] EXMEM_Out_Pcp4;
	wire [31:0] EXMEM_Out_RegOut1;
	wire [31:0] EXMEM_Out_RegOut2;
	wire [31:0] EXMEM_Out_Im;

	/*
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
	*/

	EXMEM EX_MEM (clk,
	Branch_Decision, IDEX_Out_Byte, MUX14_Out, IDEX_Out_Float, 
	IDEX_Out_WBsrc, MUX15_Out, IDEX_Out_DW, 
	MUX16_Out, fALU_out[31:0], IDEX_Out_Pcp4, 
	MUX21_Out, IDEX_Out_Float2P1, IDEX_Out_DstReg, {IDEX_Out_Im, 16'b0},
	EXMEM_Out_Flush, EXMEM_Out_Byte, EXMEM_Out_Write, EXMEM_Out_Float, 
	EXMEM_Out_WBsrc, EXMEM_Out_MWrite, EXMEM_Out_DW, 
	EXMEM_Out_ALUout1, EXMEM_Out_ALUout2, EXMEM_Out_Pcp4, 
	EXMEM_Out_RegOut1, EXMEM_Out_RegOut2, EXMEM_Out_DstReg, EXMEM_Out_Im);


	// *************************************************


	// *************************************************
	// **** WIRING OF STAGE 4 : MEMORY ACCESS   ********
	// *************************************************

	//Wires
	wire [31:0] Mem_out1;
	wire [31:0] Mem_out2;

	//Modules
	//module DataMemory (address, in1, in2, byte, write, dWrite, out1, out2);
	DataMemory Data_Memory (EXMEM_Out_ALUout1, EXMEM_Out_RegOut1, EXMEM_Out_RegOut2, 
	EXMEM_Out_Byte, EXMEM_Out_MWrite, EXMEM_Out_DW, Mem_out1, Mem_out2);


	// *************************************************
	// *************************************************


	// ******************* MEM / WB ********************
	wire [1:0] MEMWB_Out_WBsrc; // Selects the source for Write Back Data
	wire [31:0] MEMWB_Out_ALUout1; // Result from ALU
	wire [31:0] MEMWB_Out_MemOut1; // Output from Memory
	wire [31:0] MEMWB_Out_MemOut2; // Second output from memory
	wire [31:0] MEMWB_Out_Pcp4; // PC + 4
	wire [31:0] MEMWB_Out_Im; // Immediate value
	wire [31:0] MEMWB_Out_ALUout2; // Second result from ALU
	
	/*
	module MEMWB ( clk,
	iWrite, iFloat,
	iWBsrc, iDW,
	iALUout1, iMemOut1, iMemOut2,
	iPcp4, iIm, iDstReg, iALUout2, 
	oWrite, oFloat,
	oWBsrc, oDW,
	oALUout1, oMemOut1, oMemOut2,
	oPcp4, oIm, oDstReg, oALUout2, 
	);
	*/

	MEMWB MEM_WB(clk,
	EXMEM_Out_Write, EXMEM_Out_Float, 
	EXMEM_Out_WBsrc, EXMEM_Out_DW, 
	EXMEM_Out_ALUout1, Mem_out1, Mem_out2, 
	EXMEM_Out_Pcp4, EXMEM_Out_Im, EXMEM_Out_DstReg, EXMEM_Out_ALUout2,
	MEMWB_Out_Write, MEMWB_Out_Float, 
	MEMWB_Out_WBsrc, MEMWB_Out_DW,
	MEMWB_Out_ALUout1, MEMWB_Out_MemOut1, MEMWB_Out_MemOut2,
	MEMWB_Out_Pcp4, MEMWB_Out_Im, MEMWB_Out_DstReg, MEMWB_Out_ALUout2);



	// *************************************************

	// *************************************************
	// **** WIRING OF STAGE 5 : WRITE BACK   ***********
	// *************************************************

	// Modules
	MUX_4_32 MUX19(MEMWB_Out_ALUout1, MEMWB_Out_MemOut1, MEMWB_Out_Im, MEMWB_Out_Pcp4, MEMWB_Out_WBsrc, MUX19_Out);
	MUX_2_32 MUX18(MEMWB_Out_ALUout2, MEMWB_Out_MemOut2, MEMWB_Out_WBsrc[0], MUX18_Out);


	// *************************************************
	// *************************************************





	
	//Setting up initial value from PC_VALUE
	initial 
		program_counter.PCout = PC_VALUE;
	




endmodule 

