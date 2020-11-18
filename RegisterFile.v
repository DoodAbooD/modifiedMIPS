//declares a 32x32 register file.
module registerFile(readReg1, readReg2, writeReg, writeData, regWrite, float, dataOut1, dataOut2, clk);
input [4:0] readReg1, readReg2, writeReg;
input [31:0] writeData;
input regWrite, float; //control signals
input clk;
output [31:0] dataOut1, dataOut2;
reg [31:0] dataOut1, dataOut2; 
	
reg [31:0] registers_i[31:0];	
reg [31:0] registers_f[31:0];

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
		if (writeReg != 5'b00000) begin //prevent writing on register zero
			case ({regWrite,float})
				2'b10: registers_i[writeReg] = writeData;
				2'b11: registers_f[writeReg] = writeData;
			endcase
		end
	end

	//Reading at negative clock
	if (~clk) begin
		if (float) begin
			dataOut1 = registers_f[readReg1];
			dataOut2 = registers_f[readReg2];
		end else begin
			dataOut1 = registers_i[readReg1];
			dataOut2 = registers_i[readReg2];
		end
	end
end
endmodule