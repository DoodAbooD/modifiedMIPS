//declares a 32x32 register file for floats.
module registerFileF(readReg1, readReg2, writeReg, 
writeData1, writeData2, 
regWrite, regDWrite,
dataOut1, dataOut2, dataOut1p1, dataOut2p1,
 clk);

    input [4:0] readReg1, readReg2, writeReg;
    input [31:0] writeData1, writeData2;
    input regWrite, regDWrite; //control signals
    input clk;
    output [31:0] dataOut1, dataOut2;
    reg [31:0] dataOut1, dataOut2; 
        
    reg [31:0] registers_f[31:0];	

    //initializing registers with zeros
    integer i = 0;
    initial begin
        for (i=0; i <= 31; i=i+1) 
            registers_f[i] <= 32'b0;	
    end


    always @(*) begin
        //Writing at positive clock
        if (clk) begin
            // Double Write is ON , and write register is neither 0 nor 31
            if (regDWrite && writeReg!= 5'b00000 && writeReg != 5'b11111) begin
                registers_f[writeReg] = writeData1;
                registers_f[writeReg + 1] = writeData2;
            end
            //Only regWrite is ON, and write register is not register zero, 
            else if (regWrite && writeReg != 5'b00000)  
                registers_f[writeReg] = writeData1;
        end

        //Reading at negative clock
        if (~clk) begin
            dataOut1 = registers_f[readReg1];
            dataOut1p1 = registers_f[readReg1 + 1];
            dataOut2 = registers_f[readReg2];
            dataOut2p1 = registers_f[readReg2 + 1];
        end
    end
endmodule