
module IFIDTest;

    wire clk;
    wire [31:0] pcp4;
    wire [31:0] ins;

    wire [5:0] op;
    wire [4:0] rs_fmt;
    wire [4:0] rt_ft;
    wire [4:0] rd_fs;
    wire [4:0] sh_fd;
    wire [5:0] fun;
    wire [15:0] im;
    wire [25:0] ad; 

    clock Clock(clk);
    IFID _IFID(clk, pcp4, ins, pcp4o, op, rs_fmt, rt_ft, rd_fs, sh_fd, fun, im, ad);

    reg [31:0] mem [4:0]; //5x32
    reg [31:0] current_instruction;
    reg [31:0] current_pcp4;
	 
	 assign ins = current_instruction;
	 assign pcp4 = current_pcp4;

    initial begin
        //R 101010 00001 00010 00011 11111 111000
        mem[0] = 32'b10101000001000100001111111111000;

        //I 101010 00001 00010 1111111111111111
        mem[1] = 32'b10101000001000101111111111111111;

        //J 101010 10101010101010101010101010
        mem[2] = 32'b10101010101010101010101010101010;

        //FR 101010 00001 00010 00011 11111 111000
        mem[3] = 32'b10101000001000100001111111111000;

        //FI 101010 00001 00010 1111111111111111
        mem[4] = 32'b10101000001000101111111111111111;

        current_instruction = mem[0];
        current_pcp4 = 0;

    end

    integer i = 0;
    always @(posedge clk) begin
        case (i) 
          0: begin
					current_instruction = mem[1];
					$display("cycle: %d - op = %b | rs = %b | rt = %b | rd = %b | shamt = %b | funct = %b | " , i,op,rs_fmt,rt_ft,rd_fs,sh_fd,fun);

          end
          1: begin
					$display("cycle: %d - op = %b | rs = %b | rt = %b | rd = %b | shamt = %b | funct = %b | " , i,op,rs_fmt,rt_ft,rd_fs,sh_fd,fun);
					current_instruction = mem[2];
              
          end
          2: begin
              
          end
          3: begin
              
          end
          4: begin
              
              
          end
          default: begin
              $stop; 
          end

        endcase
       i = i+1 ;
    end

endmodule
