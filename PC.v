// Dont think we need this bad boy

module PC (PCin, PCout , clk, stall);
    input [31:0] PCin;
    input clk, stall;
    output [31:0] PCout;
    reg [31:0] PCout;
	 
    initial 
        PCout = 0;

	 always @(posedge clk) begin
		if (~stall) PCout = PCin;
	 end
	 
	
endmodule