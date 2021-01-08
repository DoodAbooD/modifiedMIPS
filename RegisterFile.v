//declares a 32x32 register file.
module registerFile(
readReg1, readReg2, readReg3, 
writeReg, writeData, regWrite, 
dataOut1, dataOut2, dataOut3,

readReg1f, readReg2f, 
writeRegf, writeData1f, writeData2f, 
regWritef, regDWritef,
dataOut1f, dataOut2f, dataOut1p1f, dataOut2p1f,
clk);

	// Integers
	input [4:0] readReg1, readReg2, readReg3, writeReg;
	input [31:0] writeData;
	input regWrite; //control signals
	output [31:0] dataOut1, dataOut2, dataOut3;
	reg [31:0] dataOut1, dataOut2, dataOut3;		
	reg signed [31:0] registers_i[31:0];

	// Floats
	input [4:0] readReg1f, readReg2f, writeRegf;
    input [31:0] writeData1f, writeData2f;
    input regWritef, regDWritef; //control signals
    output [31:0] dataOut1f, dataOut2f, dataOut1p1f, dataOut2p1f;
    reg [31:0] dataOut1f, dataOut2f, dataOut1p1f, dataOut2p1f;        
    reg signed [31:0] registers_f[31:0];	

    input clk;


	//initializing registers with zeros
	integer i = 0;
	initial begin
		for (i=0; i <= 31; i=i+1) begin
			registers_i[i] <= 32'b0;
			registers_f[i] <= 32'b0;
		end		
	end


	always @(*) begin
		//Writing at positive clock
		if (clk) begin
			//Integers
			//regWrite is ON and not register zero,
			if (regWrite && writeReg != 5'b00000)   
					registers_i[writeReg] = writeData;

			//Floats
			// Double Write is ON , and write register is neither 0 nor 31
            else if (regDWritef && writeRegf != 5'b00000 && writeRegf != 5'b11111) begin
                registers_f[writeRegf] = writeData1f;
                registers_f[writeRegf + 1] = writeData2f;
            end
            //Only regWrite is ON, and write register is not register zero, 
            else if (regWritef && writeRegf != 5'b00000)  
                registers_f[writeReg] = writeData1f;
			
		end

		//Reading at negative clock
		if (~clk) begin
			//Integers
			dataOut1 = registers_i[readReg1];
			dataOut2 = registers_i[readReg2];
			dataOut3 = registers_i[readReg3];
			//Floats
			dataOut1f = registers_f[readReg1f];
            dataOut1p1f = registers_f[readReg1f + 1];
            dataOut2f = registers_f[readReg2f];
            dataOut2p1f = registers_f[readReg2f + 1];
		end
	end



endmodule
