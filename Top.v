/*
stage1 : instruction fetch (IF)
stage2 : instruction decode and register fetch (ID)
stage3 : execuction stage (EXEC)
stage4 : memory stage (MEM)
stage5 : writeback stage (WB)
*/

module Top(PC_VALUE);// testbench holds the PC Value.
	input PC_VALUE;
	
	wire clk,w;
	reg [31:0] inwards;
	wire [31:0] outwards;
	wire [31:0] inverse;
	assign w = 1;
	
	PC myPC(inwards,outwards, w);
	
	clock maclock(clk);
	
	initial 
		inwards = 0;
	
    
	 MUX_2_1 mux(inwards,~inwards,inverse, clk);
		 
	always @(posedge clk) begin
	
		inwards = inwards + 1;
	
	end
	

endmodule 

