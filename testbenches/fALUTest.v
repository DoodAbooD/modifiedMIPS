    /* Control Signals
    0000 AND | Single Float Add 
    0001 OR | Single Float Compare eq
    0010 Addition | Single Float Compare lt
    0011 Unsigned Subtraction | Single Float Compare le
    0100 Set Less Than | Double Float Add 
    0101 Set Less Than Unsigned | Double Float Compare eq
    0111 NOR | Double Float Compare lt
    1000 Shift Left | Double Float Compare le */


module fALUTest();
    wire [63:0] in1 , in2 , out;
    wire [3:0] control;
    wire con , clk;

    //module fALU(in1, in2, control, con, out);
    fALU myfALU(in1 , in2, control, con, out);
    //clock(clk);
    clock myClock(clk);

    wire [31:0] in1_single = in1[63:32];
    wire [31:0] in2_single = in2[63:32];
    wire [31:0] out_single = out[63:32];


    integer cycle = 0;

    always @(posedge clk) begin
        case (cycle) 
            0: ;
            1:  begin
                in1_single <= 32'h3FA00000;
                in1_single <= 32'h3F900000;
                control <= 4'b0000;
                $strobe("result = : %h" , out, " The correct value is 40180000"); 
            end

            2:  begin
                in1_single <= 32'h3C0C0923;
                in1_single <= 32'hBF929EED;
                control <= 4'b0000;
                $strobe("result = : %h" , out, " The correct value is BF9186DB"); 
            end

            3:  begin
                in1_single <= 32'hD213D7E9;
                in1_single <= 32'hD0761229;
                control <= 4'b0000;
                $strobe("result = : %h" , out, " The correct value is D223390C"); 
            end

            
            
        endcase
    end




endmodule