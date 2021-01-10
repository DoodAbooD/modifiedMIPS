module tst_10; 
	reg [31:0]PC_VALUE_;		  
	reg [31:0] cycle;
	Top top(PC_VALUE_);
	initial begin
		PC_VALUE_ <= 1000;	  
		cycle <= 1;
	end				   
	always @(posedge top.clk) begin	
if (cycle== 10)	
begin
		$display("cycle: %d" , cycle);
		$display("PC: %d",top.program_counter);				   
		$display("ALUOut_EXEC: %d" , top.ALUOut_EXEC);
		$display("$s1: %d" , top.regFile.registers_i[19], " The correct value is 20");

		$finish;
		end
		cycle = cycle + 1;
	end
endmodule