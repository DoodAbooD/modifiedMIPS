module PC (in, out);
    input [31:0] in;
    output [31:0] out;

    reg [31:0] out;

    initial 
        out = 0;

    assign out = in;

endmodule