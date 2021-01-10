module tst_11; 
	reg [31:0]PC_VALUE_;		  
	reg [31:0] cycle;
	Top top(PC_VALUE_);
	initial begin
		PC_VALUE_ <= 1100;	  
		cycle <= 1;
	end				   
	always @(posedge top.clk) begin	
if (cycle== 10)	
begin
		$display("cycle: %d" , cycle);
		$display("PC: %d",top.program_counter);				   
		$display("ALUOut_EXEC: %d" , top.ALUOut_EXEC);
		$display("$t2: %d" , top.regFile.registers_i[10], " The correct value is 32");

		$stop;
		end
		cycle = cycle + 1;
	end
endmodule