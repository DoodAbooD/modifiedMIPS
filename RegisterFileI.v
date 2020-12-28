//declares a 32x32 register file.
module registerFileI(readReg1, readReg2, readReg3, writeReg, writeData, regWrite, dataOut1, dataOut2, dataOut3, clk);
	input [4:0] readReg1, readReg2, readReg3, writeReg;
	input [31:0] writeData;
	input regWrite; //control signals
	input clk;
	output [31:0] dataOut1, dataOut2, dataOut3;
	reg [31:0] dataOut1, dataOut2, dataOut3;
		
	reg [31:0] registers_i[31:0];	

	//initializing registers with zeros
	integer i = 0;
	initial begin
		for (i=0; i <= 31; i=i+1) 
			registers_i[i] <= 32'b0;	
	end


	always @(*) begin
		//Writing at positive clock
		if (clk) begin
			if (writeReg != 5'b00000 && regWrite)  //not register zero, regWrite is ON
					registers_i[writeReg] = writeData;
		end

		//Reading at negative clock
		if (~clk) begin
			dataOut1 = registers_i[readReg1];
			dataOut2 = registers_i[readReg2];
			dataOut3 = registers_i[readReg3];
		end
	end
endmodule

