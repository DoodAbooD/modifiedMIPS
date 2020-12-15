module fALU(in1, in2, control, con, out);
    input [63:0] in1;
    input [63:0] in2;
    input [3:0] control;
    output con;
    output [63:0] out;

    reg con;
    reg [63:0] out;

    wire [31:0] in1_single = in1[63:32];
    wire [31:0] in2_single = in1[63:32];

    //Single Precision
    wire [22:0] i1s_mant = in1_single[22:0]; // Mantissa of first input for single
    wire [22:0] i2s_mant = in2_single[22:0]; // Mantissa of second input for single
    wire [7:0] i1s_exp = in1_single [30:23]; // Exponent of first input for single
    wire [7:0] i2s_exp = in2_single [30:23]; // Exponent of second input for single
    wire i1s_sign = in1_single[31]; // Sign of first input for single
    wire i2s_sign = in2_single[31]; // Sign of second input for single

    //Double Precision
    wire [51:0] i1d_mant = in1[51:0]; // Mantissa of first input for double
    wire [51:0] i2d_mant = in2[51:0]; // Mantissa of second input for double
    wire [10:0] i1d_exp = in1[62:52]; // Exponent of first input for double
    wire [10:0] i2d_exp = in2[62:52]; // Exponent of second input for double
    wire i1d_sign = in1[63]; // Sign of first input for double
    wire i2d_sign = in2[63]; // Sign of second input for double

    initial begin
        con = 0; 
        out = 0;
    end

    always @(*) begin
        case (control)
        
        4'b0000: begin // Single Float Add 
            
        end

        4'b0001: begin // Single Float Compare eq
            
        end

        4'b0010: begin // Single Float Compare lt
            
        end

        4'b0011: begin // Single Float Compare le
            
        end

        4'b0100: begin // Double Float Add 
            
        end

        4'b0101: begin // Double Float Compare eq
            
        end

        4'b0111: begin // Double Float Compare lt
            
        end

        4'b1000: begin // Double Float Compare le
            
        end


        endcase
    end

    /* Control Signals
    0000 AND | Single Float Add 
    0001 OR | Single Float Compare eq
    0010 Addition | Single Float Compare lt
    0011 Unsigned Subtraction | Single Float Compare le
    0100 Set Less Than | Double Float Add 
    0101 Set Less Than Unsigned | Double Float Compare eq
    0111 NOR | Double Float Compare lt
    1000 Shift Left | Double Float Compare le */


endmodule