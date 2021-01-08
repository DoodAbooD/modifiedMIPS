module tst_8; 
	reg [31:0]PC_VALUE_;		  
	reg [31:0] cycle;
	Top top(PC_VALUE_);
	initial begin
		PC_VALUE_ <= 800;	  
		cycle <= 1;
	end				   
	always @(posedge top.clk) begin	
if (cycle== 8)	
begin
		$display("wcycle: %d" , cycle);
		$display("PC: %d",top.program_counter);				   
		$display("ALUOut_EXEC: %d" , top.ALUOut_EXEC);
		$display("$s1: %d" , top.regFile.registers_i[19], " The correct value is 10");
		$display("$s2: %d" , top.regFile.registers_i[20], " The correct value is 20");			

		$finish;
		end
		cycle = cycle + 1;
	end
endmodule