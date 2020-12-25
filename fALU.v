module fALU(in1, in2, control, con, out);
    input [63:0] in1;
    input [63:0] in2;
    input [3:0] control;
    output con;
    output [63:0] out;

    reg con;
    reg [63:0] out;
    
    wire [31:0] in1_single = in1[63:32];
    wire [31:0] in2_single = in2[63:32];

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

    //helpers
    reg carry;
    reg [22:0] large_mant_temp; 
    reg [22:0] small_mant_temp;
    reg [7:0] large_exp_temp;
    reg [7:0] small_exp_temp;
    reg [22:0] result_mant_temp;
    reg [7:0] result_exp_temp;

    reg [51:0] Dlarge_mant_temp; 
    reg [51:0] Dsmall_mant_temp;
    reg [10:0] Dlarge_exp_temp;
    reg [10:0] Dsmall_exp_temp;
    reg [51:0] Dresult_mant_temp;
    reg [10:0] Dresult_exp_temp;




    always @(*) begin
        carry = 0;
        large_mant_temp = 0;
        small_mant_temp = 0;
        large_exp_temp = 0;
        small_exp_temp = 0;
        result_mant_temp = 0;
        result_exp_temp = 0;
        Dlarge_mant_temp = 0;
        Dsmall_mant_temp = 0;
        Dlarge_exp_temp = 0;
        Dsmall_exp_temp = 0;
        Dresult_mant_temp = 0;
        Dresult_exp_temp = 0;

        case (control)
        
        4'b0000: begin // Single Float Add 
            if (i1s_sign == i2s_sign) begin // Same sign
                
                if (i1s_exp == i2s_exp) begin // Same exponent
                    // arbitrary (large or small dont matter here)
                    large_mant_temp = i1s_mant; 
                    small_mant_temp = i2s_mant;   

                    // Add mants, taking carry into account 
                    {carry, result_mant_temp} = small_mant_temp + large_mant_temp;
                    
                    //Shift mants right once
                    result_mant_temp = result_mant_temp >> 1;
                    result_mant_temp[22] = carry; //If we had a carry, then the 1 from the carry will be added here

                    //Exponent always increases by 1
                    result_exp_temp = i1s_exp + 1;

                end

                else begin  // One is higher exponent than the other

                    if (i1s_exp > i2s_exp) begin    // in1 is larger
                        large_mant_temp = i1s_mant;
                        small_mant_temp = i2s_mant;
                        large_exp_temp = i1s_exp;
                        small_exp_temp = i2s_exp;
                    end 
                    else begin                      // in2 is larger
                        large_mant_temp = i2s_mant;
                        small_mant_temp = i1s_mant;
                        large_exp_temp = i2s_exp;
                        small_exp_temp = i1s_exp;
                    end

                    //Align the 2 mants
                    small_mant_temp = small_mant_temp >> 1; // shift it once to the right
                    small_mant_temp[22] = 1; // and add the 1 which is ommitted (1.~) 
                    // then shift it right again by the difference between the exponents, minus the one shift we did earlier
                    small_mant_temp = small_mant_temp >> ((large_exp_temp - small_exp_temp) - 1); 
                    
                    // Add mants, taking carry into account
                    {carry, result_mant_temp} = small_mant_temp + large_mant_temp; 

                    //Exponent calculation
                    result_exp_temp = large_exp_temp;
                    if (carry) begin // if we have a carry from mant addition
                        result_exp_temp = result_exp_temp +1; // add one to the exponent
                        result_mant_temp = result_mant_temp >> 1; //and right shift resulting mant by 1
                    end
                
                end

                //result output
                out[63] = i1s_sign; // sign bit
                out[62:55] = result_exp_temp; // exponent
                out[54:32] = result_mant_temp; // mantissa

            end



            else begin // Different Signs

                if (i1s_exp == i2s_exp) begin // same exponent size

                    if (i1s_mant == i2s_mant) begin // equal absolute values and opposite signs --> return zero
                        out[63] = 0; // sign bit
                        out[62:55] = 0; // exponent
                        out[54:32] = 0; // mantissa
                    end

                    else begin // non-equal absolute values 

                        if (i1s_mant > i2s_mant) begin // in1 has larger absolute value
                            large_mant_temp = i1s_mant; 
                            small_mant_temp = i2s_mant;  
                            out[63] = i1s_sign; // in1 dictates the sign bit              
                        end else begin      // in2 has larger absolute value
                            large_mant_temp = i2s_mant; 
                            small_mant_temp = i1s_mant;
                            out[63] = i2s_sign; // in2 dictates the sign bit    
                        end    
                                           
                        // Subtract Mantissas
                        result_mant_temp = large_mant_temp - small_mant_temp;

                        // Exponent starts at the same value of the input exponent, and decreases depending on the number of leading zeros in mantissa
                        result_exp_temp = i1s_exp;
                        while (result_mant_temp[22] == 0) begin
                            result_mant_temp = result_mant_temp << 1; // normalizing mantissa
                            result_exp_temp = result_exp_temp - 1; 
                        end
                        // One last shift left and exponent decrease
                        result_mant_temp  = result_mant_temp << 1;
                        result_exp_temp = result_exp_temp - 1;

                        // outputs
                        out[62:55] = result_exp_temp; // exponent
                        out[54:32] = result_mant_temp; // mantissa

                    end
                    

                end

                else begin  // One is higher exponent than the other
                    
                    if (i1s_exp > i2s_exp) begin    // in1 is larger
                        large_mant_temp = i1s_mant;
                        small_mant_temp = i2s_mant;
                        large_exp_temp = i1s_exp;
                        small_exp_temp = i2s_exp;
                        out[63] = i1s_sign; // in1 dictates the sign bit 

                    end 
                    else begin                      // in2 is larger
                        large_mant_temp = i2s_mant;
                        small_mant_temp = i1s_mant;
                        large_exp_temp = i2s_exp;
                        small_exp_temp = i1s_exp;
                        out[63] = i2s_sign; // in2 dictates the sign bit 
                    end

                    //Align the 2 mants
                    small_mant_temp = small_mant_temp >> 1; // shift it once to the right
                    small_mant_temp[22] = 1; // and add the 1 which is ommitted (1.~) 
                    // then shift it right again by the difference between the exponents, minus the one shift we did earlier
                    small_mant_temp = small_mant_temp >> ((large_exp_temp - small_exp_temp) - 1); 

                    // Subtract mantissas, placing leading digit of larger as 1 , and checking if this digit was borrowed from using the carry register
                    {carry, result_mant_temp} = {1'b1, large_mant_temp} - {1'b0 , small_mant_temp};

                    // exponent starts as the larger, and decreases if leading one was borrowed from (keeps decreasing until we reach a leading 1)
                    result_exp_temp = large_exp_temp;
                    while (~carry) begin
                        {carry, result_mant_temp} = {carry, result_mant_temp} << 1;
                        result_exp_temp = result_exp_temp - 1;
                    end

                    // outputs
                    out[62:55] = result_exp_temp; // exponent
                    out[54:32] = result_mant_temp; // mantissa

                end

            end
 
        end

        4'b0001: begin // Single Float Compare eq
            con = (in1_single == in2_single);       
        end

        4'b0010: begin // Single Float Compare lt            
            if ((i1s_sign == i2s_sign)&&(i1s_sign == 0)) begin  // both positive
                if (i1s_exp < i2s_exp) con = 1;
                else if (i1s_exp == i2s_exp) begin
                    if (i1s_mant < i2s_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else if ((i1s_sign == i2s_sign)&&(i1s_sign == 1)) begin  // both negative
                if (i1s_exp > i2s_exp) con = 1;
                else if (i1s_exp == i2s_exp) begin
                    if (i1s_mant > i2s_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else    // different signs
                con = i1s_sign;                              
        end


        4'b0011: begin // Single Float Compare le
            if ((i1s_sign == i2s_sign)&&(i1s_sign == 0)) begin  // both positive
                if (i1s_exp < i2s_exp) con = 1;
                else if (i1s_exp == i2s_exp) begin
                    if (i1s_mant <= i2s_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else if ((i1s_sign == i2s_sign)&&(i1s_sign == 1)) begin  // both negative
                if (i1s_exp > i2s_exp) con = 1;
                else if (i1s_exp == i2s_exp) begin
                    if (i1s_mant >= i2s_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else    // different signs
                con = i1s_sign;
        end


        4'b0100: begin // Double Float Add 

            if (i1d_sign == i2d_sign) begin // Same sign
                
                if (i1d_exp == i2d_exp) begin // Same exponent
                    // arbitrary (large or small dont matter here)
                    Dlarge_mant_temp = i1d_mant; 
                    Dsmall_mant_temp = i2d_mant;   

                    // Add mants, taking carry into account 
                    {carry, Dresult_mant_temp} = Dsmall_mant_temp + Dlarge_mant_temp;
                    
                    //Shift mants right once
                    Dresult_mant_temp = Dresult_mant_temp >> 1;
                    Dresult_mant_temp[51] = carry; //If we had a carry, then the 1 from the carry will be added here

                    //Exponent always increases by 1
                    Dresult_exp_temp = i1d_exp + 1;

                end

                else begin  // One is higher exponent than the other

                    if (i1d_exp > i2d_exp) begin    // in1 is larger
                        Dlarge_mant_temp = i1d_mant;
                        Dsmall_mant_temp = i2d_mant;
                        Dlarge_exp_temp = i1d_exp;
                        Dsmall_exp_temp = i2d_exp;
                    end 
                    else begin                      // in2 is larger
                        Dlarge_mant_temp = i2d_mant;
                        Dsmall_mant_temp = i1d_mant;
                        Dlarge_exp_temp = i2d_exp;
                        Dsmall_exp_temp = i1d_exp;
                    end

                    //Align the 2 mants
                    Dsmall_mant_temp = Dsmall_mant_temp >> 1; // shift it once to the right
                    Dsmall_mant_temp[51] = 1; // and add the 1 which is ommitted (1.~) 
                    // then shift it right again by the difference between the exponents, minus the one shift we did earlier
                    Dsmall_mant_temp = Dsmall_mant_temp >> ((Dlarge_exp_temp - Dsmall_exp_temp) - 1); 
                    
                    // Add mants, taking carry into account
                    {carry, Dresult_mant_temp} = Dsmall_mant_temp + Dlarge_mant_temp; 

                    //Exponent calculation
                    Dresult_exp_temp = Dlarge_exp_temp;
                    if (carry) begin // if we have a carry from mant addition
                        Dresult_exp_temp = Dresult_exp_temp +1; // add one to the exponent
                        Dresult_mant_temp = Dresult_mant_temp >> 1; //and right shift resulting mant by 1
                    end
                
                end

                //result output
                out[63] = i1d_sign; // sign bit
                out[62:52] = Dresult_exp_temp; // exponent
                out[51:0] = Dresult_mant_temp; // mantissa

            end



            else begin // Different Signs

                if (i1d_exp == i2d_exp) begin // same exponent size

                    if (i1d_mant == i2d_mant) begin // equal absolute values and opposite signs --> return zero
                        out[63] = 0; // sign bit
                        out[62:52] = 0; // exponent
                        out[51:0] = 0; // mantissa
                    end

                    else begin // non-equal absolute values 

                        if (i1d_mant > i2d_mant) begin // in1 has larger absolute value
                            Dlarge_mant_temp = i1d_mant; 
                            Dsmall_mant_temp = i2d_mant;  
                            out[63] = i1d_sign; // in1 dictates the sign bit              
                        end else begin      // in2 has larger absolute value
                            Dlarge_mant_temp = i2d_mant; 
                            Dsmall_mant_temp = i1d_mant;
                            out[63] = i2d_sign; // in2 dictates the sign bit    
                        end    
                                           
                        // Subtract Mantissas
                        Dresult_mant_temp = Dlarge_mant_temp - Dsmall_mant_temp;

                        // Exponent starts at the same value of the input exponent, and decreases depending on the number of leading zeros in mantissa
                        Dresult_exp_temp = i1d_exp;
                        while (Dresult_mant_temp[51] == 0) begin
                            Dresult_mant_temp = Dresult_mant_temp << 1; // normalizing mantissa
                            Dresult_exp_temp = Dresult_exp_temp - 1; 
                        end
                        // One last shift left and exponent decrease
                        Dresult_mant_temp = Dresult_mant_temp << 1;
                        Dresult_exp_temp = Dresult_exp_temp - 1;

                        // outputs
                        out[62:52] = Dresult_exp_temp; // exponent
                        out[51:0] = Dresult_mant_temp; // mantissa

                    end
                    

                end

                else begin  // One is higher exponent than the other
                    
                    if (i1d_exp > i2d_exp) begin    // in1 is larger
                        Dlarge_mant_temp = i1d_mant;
                        Dsmall_mant_temp = i2d_mant;
                        Dlarge_exp_temp = i1d_exp;
                        Dsmall_exp_temp = i2d_exp;
                        out[63] = i1d_sign; // in1 dictates the sign bit 

                    end 
                    else begin                      // in2 is larger
                        Dlarge_mant_temp = i2d_mant;
                        Dsmall_mant_temp = i1d_mant;
                        Dlarge_exp_temp = i2d_exp;
                        Dsmall_exp_temp = i1d_exp;
                        out[63] = i2d_sign; // in2 dictates the sign bit 
                    end

                    //Align the 2 mants
                    Dsmall_mant_temp = Dsmall_mant_temp >> 1; // shift it once to the right
                    Dsmall_mant_temp[51] = 1; // and add the 1 which is ommitted (1.~) 
                    // then shift it right again by the difference between the exponents, minus the one shift we did earlier
                    Dsmall_mant_temp = Dsmall_mant_temp >> ((Dlarge_exp_temp - Dsmall_exp_temp) - 1); 

                    // Subtract mantissas, placing leading digit of larger as 1 , and checking if this digit was borrowed from using the carry register
                    {carry, Dresult_mant_temp} = {1'b1, Dlarge_mant_temp} - {1'b0 , Dsmall_mant_temp};

                    // exponent starts as the larger, and decreases if leading one was borrowed from (keeps decreasing until we reach a leading 1)
                    Dresult_exp_temp = Dlarge_exp_temp;
                    while (~carry) begin
                        {carry, Dresult_mant_temp} = {carry, Dresult_mant_temp} << 1;
                        Dresult_exp_temp = Dresult_exp_temp - 1;
                    end

                    // outputs
                    out[62:52] = Dresult_exp_temp; // exponent
                    out[51:0] = Dresult_mant_temp; // mantissa

                end

            end

        end

        4'b0101: begin // Double Float Compare eq
            con = (in1 == in2); 
        end

        4'b0111: begin // Double Float Compare lt
             if ((i1d_sign == i2d_sign)&&(i1d_sign == 0)) begin  // both positive
                if (i1d_exp < i2d_exp) con = 1;
                else if (i1d_exp == i2d_exp) begin
                    if (i1d_mant < i2d_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else if ((i1d_sign == i2d_sign)&&(i1d_sign == 1)) begin  // both negative
                if (i1d_exp > i2d_exp) con = 1;
                else if (i1d_exp == i2d_exp) begin
                    if (i1d_mant > i2d_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else    // different signs
                con = i1s_sign; 

        end

        4'b1000: begin // Double Float Compare le

            if ((i1d_sign == i2d_sign)&&(i1d_sign == 0)) begin  // both positive
                if (i1d_exp < i2d_exp) con = 1;
                else if (i1d_exp == i2d_exp) begin
                    if (i1d_mant <= i2d_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else if ((i1d_sign == i2d_sign)&&(i1d_sign == 1)) begin  // both negative
                if (i1d_exp > i2d_exp) con = 1;
                else if (i1d_exp == i2d_exp) begin
                    if (i1d_mant >= i2d_mant) con = 1;
                    else con = 0;
                end
                else con = 0;
            end

            else    // different signs
                con = i1d_sign;
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