module MUX_2_1 (in1, in2, out, s);
    input [31:0] in1;
    input [31:0] in2;
    input s;
    output [31:0] out;

	 assign out = (~s)? in1 : in2;

endmodule