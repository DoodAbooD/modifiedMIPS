//declares a 32x32 register file for floats.
module registerFileF(readReg1, readReg2, writeReg, writeData, regWrite, float, dataOut1, dataOut2, clk);
    input [4:0] readReg1, readReg2, writeReg;
    input [31:0] writeData;
    input regWrite, float; //control signals
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
            if (writeReg != 5'b00000 && regWrite && float)  //not register zero, regWrite is ON, and float
                    registers_f[writeReg] = writeData;
        end

        //Reading at negative clock
        if (~clk) begin
            if (float) begin
                dataOut1 = registers_f[readReg1];
                dataOut2 = registers_f[readReg2];
            end
        end
    end
endmodule