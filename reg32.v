module reg32(in,out,w);
    input [31:0] in;
    input w;
    output reg [31:0] out;
    initial out = 0;
    always@(*) 
        if (w) out <= in;
endmodule