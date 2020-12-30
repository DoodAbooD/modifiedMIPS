module DataMemory (address, in1, in2, byte, write, dWrite, out1, out2);

	input [31:0] address, in1, in2;
	input byte, write, dWrite;
	output [31:0] out1, out2;

	// Intitialization for the memory 
	reg [7:0] mem [1023:0]; // building a 1k memory //
	integer i;
	
	initial begin
		for(i = 0; i <1024; i = i + 1) begin
			mem[i] <=  0;
			if((i+1)%4 == 0)
			mem[i] <= i+1;
		end		
	end
	// mem[3] 	= 4
	// mem[7] 	= 8
	// mem[11] 	= 12
	// mem[15] 	= 16
	// mem[19] 	= 20
	// mem[23] 	= 24
	// mem[27] 	= 28
	// mem[31] 	= 32	
	
	always @(*) begin
		if (write) begin // Writing
			if (dWrite) begin // Writing double floating 
				mem[address] = in1[31:24];
				mem[address + 1] = in1[23:16];
				mem[address + 2] = in1[15:8];
				mem[address + 3] = in1[7:0];
				mem[address + 4] = in2[31:24];
				mem[address + 5] = in2[23:16];
				mem[address + 6] = in2[15:8];
				mem[address + 7] = in2[7:0];
			end

			else if (byte) begin // Writing Byte
				mem[address] = in1[7:0];
			end

			else begin // Writing Word
				mem[address] = in1[31:24];
				mem[address + 1] = in1[23:16];
				mem[address + 2] = in1[15:8];
				mem[address + 3] = in1[7:0];
			end

		end

		//Reading
		if (byte) begin
			out1 = {24'0 , mem[address]};
		end
		else begin
			out1[31:24] = mem[address];
			out1[23:16] = mem[address + 1];
			out1[15:8] = mem[address + 2];
			out1[7:0] = mem[address + 3];
			out2[31:24] = mem[address + 4];
			out2[23:16] = mem[address + 5];
			out2[15:8] = mem[address + 6];
			out2[7:0] = mem[address + 7];
		end
	end


endmodule

