module registerFileTest;
    reg [4:0] _readReg1, _readReg2, _writeReg;
    reg [31:0] _writeData;
    reg _regWrite, _float;

    wire [31:0] _dataOut1, _dataOut2;
    wire _clk;

    clock Clock(_clk);
    integer cycle = 0;

    //module registerFile(readReg1, readReg2, writeReg, writeData, regWrite, float, dataOut1, dataOut2, clk);
    registerFile regFile(_readReg1, _readReg2, _writeReg, _writeData, _regWrite, _float, _dataOut1, _dataOut2, _clk);
    always@(posedge _clk) begin
			$display("cycle: %d" , cycle);
        case (cycle)
            0: begin


            end
            1: begin
					 //Writing 44 to register one and reading registers 1 and 2
                _float <= 0;
					 _writeReg <= 5'b1;
                _writeData <= 32'd44;
                _regWrite <= 1;
                _readReg1 <= 5'b01;
                _readReg2 <= 5'b10;
                $display("cycle: %d - Writing 44 to register one and reading registers 1 and 2" , cycle);
                $display("readReg1: %h" , _dataOut1);
                $display("readReg2: %h" , _dataOut2);
            end
            2: begin
					 //Writing ffffffff to register 2 and reading registers 1 and 2 
					 _writeReg <= 5'b10;
					 _writeData <= 32'hffffffff;
					 _readReg1 <= 5'b01;
                _readReg2 <= 5'b10;
                _regWrite <= 1;
                $display("cycle: %d - Writing ffffffff to register 2 and reading registers 1 and 2" , cycle);
                $display("readReg1: %h" , _dataOut1);
                $display("readReg2: %h" , _dataOut2);
            end
            3: begin
					//trying to write ffffffff to register $zero , reading from $zero and 2
					 _writeReg <= 5'b0;
					 _writeData <= 32'hffffffff;
					 _readReg1 <= 5'b00;
                _readReg2 <= 5'b10;
                _regWrite <= 1;
                $display("cycle: %d - trying to write ffffffff to register $zero , reading from $zero and 2" , cycle);
                $display("readReg1: %h" , _dataOut1);
                $display("readReg2: %h" , _dataOut2);
            
            end
				4: begin
					//Switching to float registers, writing f0f0f0f0 to float register 1, reading from 1 and 2
					 _float <= 1;
					 _writeReg <= 5'b1;
					 _writeData <= 32'hf0f0f0f0;
					 _readReg1 <= 5'b01;
                _readReg2 <= 5'b10;
                _regWrite <= 1;
                $display("cycle: %d - Switching to float registers, writing f0f0f0f0 to float register 1, reading from 1 and 2" , cycle);
                $display("readReg1: %h" , _dataOut1);
                $display("readReg2: %h" , _dataOut2);
            
            end
				5: begin
					// Trying to write to $fzero , reading from zero and 1
					 _float <= 1;
					 _writeReg <= 5'b0;
					 _writeData <= 32'hffffffff;
					 _readReg1 <= 5'b00;
                _readReg2 <= 5'b01;
                _regWrite <= 1;
                $display("cycle: %d - Trying to write to $fzero , reading from zero and 1" , cycle);
                $display("readReg1: %h" , _dataOut1);
                $display("readReg2: %h" , _dataOut2);
            end
				6: begin
					// switching back to integers, reading only, from registers 1 and 2 
					 _float <= 1;
					 _writeReg <= 5'b1;
					 _writeData <= 32'hffffffff;
					 _readReg1 <= 5'b01;
                _readReg2 <= 5'b10;
                _regWrite <= 0;
                $display("cycle: %d - switching back to integers, reading only, from registers 1 and 2 " , cycle);
                $display("readReg1: %h" , _dataOut1);
                $display("readReg2: %h" , _dataOut2);
            end
				7: begin
					// writing to registers 32 , reading from 31 and 32 
					 _float <= 1;
					 _writeReg <= 5'b11111;
					 _writeData <= 32'h33333333;
					 _readReg1 <= 5'b11110;
                _readReg2 <= 5'b11111;
                _regWrite <= 1;
                $display("cycle: %d - writing to registers 32 , reading from 31 and 32 " , cycle);
                $display("readReg1: %h" , _dataOut1);
                $display("readReg2: %h" , _dataOut2);
            end
				
            8: begin
            $stop;
            end
        endcase
		
        cycle = cycle + 1;
    end
	 
endmodule
