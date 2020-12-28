module IFID(clk, iPcp4, ins, oPcp4, op, rs_fmt, rt_ft, rd_fs, sh_fd, fun, im, ad , stall);
    input clk, stall;
    input [31:0] iPcp4;
    input [31:0] ins;
    output [31:0] oPcp4;
    output [5:0] op;
    output [4:0] rs_fmt;
    output [4:0] rt_ft;
    output [4:0] rd_fs;
    output [4:0] sh_fd;
    output [5:0] fun;
    output [15:0] im;
    output [25:0] ad;

    reg [31:0] internal_pcp4;
    reg [31:0] internal_ins;

    assign oPcp4 = internal_pcp4;
    assign op = internal_ins[31:26];
    assign rs_fmt = internal_ins[25:21];
    assign rt_ft = internal_ins[20:16];
    assign rd_fs = internal_ins[15:11];
    assign sh_fd = internal_ins[10:6];
    assign fun = internal_ins[5:0];
    assign im = internal_ins[15:0];
    assign ad = internal_ins[25:0];


    initial begin
        internal_pcp4 = 32'b0;
        internal_ins = 32'b0;   
    end

    always @(posedge clk) begin
		if (~stall) begin	
            internal_pcp4 <= iPcp4;
            internal_ins <= ins;
        end
    end

endmodule
