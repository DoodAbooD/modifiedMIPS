module PC (in, out, w);
    input [31:0] in;
    output [31:0] out;
	 output w;

    reg [31:0] out;
	 

    initial 
        out = 0;

	 always @(*) begin
		if (w) out = in;
	 end
	 
	
endmodule