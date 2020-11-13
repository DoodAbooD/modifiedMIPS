`include "Clock.v"
`include "RegisterFile.v"

module registerFileTest;
    reg [5:0] _readReg1, _readReg2, _writeReg;
    reg [31:0] _writeData;
    reg _regWrite, _float;

    wire [31:0] _dataOut1, _dataOut2;
    wire _clk;

    clock Clock(_clk);
    reg [31:0] cycle;

    //module registerFile(readReg1, readReg2, writeReg, writeData, regWrite, float, dataOut1, dataOut2, clk);
    registerFile regFile(_readReg1, _readReg2, _writeReg, _writeData, _regWrite, _float, _dataOut1, _dataOut2, _clk);
    always@(posedge _clk) begin

        case (cycle)
            32'd0: begin
                //Writing to register one
                _writeReg <= 6'b1;
                _writeData <= 32'd44;
                _regWrite <= 1;
                _float <= 0;
                _readReg1 <= 6'b1;
                _readReg1 <= 6'b0;
                $display("cycle: %d" , cycle);
                $display("readReg1: %d" , _dataOut1);
                $display("readReg2: %d" , _dataOut2);

            end
            32'd1: begin
                _readReg1 <= 6'b1;
                _readReg1 <= 6'b0;
                _regWrite <= 0;
                $display("cycle: %d" , cycle);
                $display("readReg1: %d" , _dataOut1);
                $display("readReg2: %d" , _dataOut2);
            end
            32'd2: begin
            
            end
            32'd3: begin
            
            end
            32'd4: begin
            
            end
        endcase

        cycle = cycle + 1;
    end
endmodule
