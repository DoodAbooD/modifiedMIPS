module mathTester();
	reg [7:0] x;
	reg [7:0] y;
	wire [15:0] x_ext;
	wire [15:0] y_ext;
	wire [15:0] z;
	
	assign x_ext = {{8{x[7]}},x};
	assign y_ext = {{8{y[7]}},y};
	assign z = x_ext*y_ext;
	
	
	
	initial begin
		x = 8'b11111011; //-5
		y = 8'b00000010; //2
	end
	
endmodule
