module tst_12; 
	reg [31:0]PC_VALUE_;		  
	reg [31:0] cycle;
	Top top(PC_VALUE_);
	initial begin
		PC_VALUE_ <= 1200;	  
		cycle <= 1;
	end				   
	always @(posedge top.clk) begin	
if (cycle== 25)	
begin
		$display("cycle: %d" , cycle);
		$display("PC: %d",top.program_counter);				   
		$display("ALUOut_EXEC: %d" , top.ALUOut_EXEC);
		$display("$t2: %h" , top.regFile.registers_f[10], " The correct value is D223390C");

		$stop;
		end
		cycle = cycle + 1;
	end
endmodule