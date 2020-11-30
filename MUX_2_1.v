module MUX_2_1 (in1, in2, out, s);

    input [31:0];
    input [31:0];
    input s;
    output [31:0] out;

    if (~s)
        assign output = in1;
    else
        assign output = in2;

endmodule