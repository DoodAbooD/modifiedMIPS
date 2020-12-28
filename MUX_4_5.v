module mux_4_5(in0, in1, in2, in3, sel, out);
    input [4:0] in0,in1,in2,in3;
    input [1:0] sel;
    output reg [4:0] out;  
    
    always @(*) begin
        case (sel)
            0:  out <= in0;
            1:  out <= in1;
            2:  out <= in2;
            3:  out <= in3;
        endcase
    end
endmodule