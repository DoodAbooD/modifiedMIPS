module reg1(in,out,w);
    input in;
    input w;
    output reg out;
    initial out = 0;
    always@(*) 
        if (w) out <= in;
endmodule