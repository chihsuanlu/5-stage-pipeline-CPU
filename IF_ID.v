module IF_ID( clk, rst, lock, In_instr, In_pc_incr, Out_instr, Out_pc_incr );
    input clk, rst, lock;
    input [31:0] In_instr, In_pc_incr;
    output [31:0] Out_instr;
    output [31:0] Out_pc_incr;
    reg [31:0] Out_instr;
    reg [31:0] Out_pc_incr;
    always @(posedge clk) begin
        if (rst) begin
            Out_instr <= 32'd0;
            Out_pc_incr <= 32'd0;
        end
         else if (lock == 1'b0) begin
            Out_instr <= In_instr;
            Out_pc_incr <= In_pc_incr;
        end
    end
endmodule