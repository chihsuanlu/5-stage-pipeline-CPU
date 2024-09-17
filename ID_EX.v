module ID_EX (  clk, rst, lock, flush,
                In_W, In_M, In_E, In_pc_incr, 
                In_rd_1, In_rd_2, In_extend_immed, In_rt, In_rd, In_rs,
                In_jumpoffset, In_Jump, In_shamt, In_Shift,

                Out_W, Out_M, Out_E, Out_pc_incr, 
                Out_rd_1, Out_rd_2, Out_extend_immed, Out_rt, Out_rd, Out_rs, 
                Out_jumpoffset, Out_Jump,  Out_shamt, Out_Shift
            );
    input clk, rst, lock, flush;
    input [1:0] In_W;
    input [2:0] In_M;
    input [3:0] In_E;
    input [31:0] In_pc_incr;
    input [31:0] In_rd_1, In_rd_2, In_extend_immed ;
    input [4:0] In_rt, In_rd, In_rs;
    input [25:0] In_jumpoffset;
    input [31:0] In_shamt;
    input In_Jump, In_Shift;

    output [1:0] Out_W;
    output [2:0] Out_M;
    output [3:0] Out_E;

    output [31:0] Out_pc_incr;
    output [31:0] Out_rd_1, Out_rd_2, Out_extend_immed;
    output [4:0] Out_rt, Out_rd, Out_rs;
    output [25:0] Out_jumpoffset;
    output Out_Jump, Out_Shift;
    output [31:0] Out_shamt;

    reg [1:0] Out_W;
    reg [2:0] Out_M;
    reg [3:0] Out_E;
    reg [31:0] Out_pc_incr;
    reg [31:0] Out_rd_1, Out_rd_2, Out_extend_immed;
    reg [4:0] Out_rt, Out_rd, Out_rs;
    reg [25:0] Out_jumpoffset;
    reg Out_Jump;
    reg Out_Shift;
    reg [31:0] Out_shamt;

    always @(posedge clk) begin
        if (rst||flush) begin
            Out_W <= 1'b0;
            Out_M <= 2'b0;
            Out_E <= 4'b0;
            Out_pc_incr <= 32'd0;
            Out_rd_1 <= 32'd0;
            Out_rd_2 <= 32'd0;
            Out_extend_immed <= 32'd0;
            Out_rt <= 4'd0;
            Out_rd <= 4'd0;
            Out_rs <= 4'd0;
            Out_jumpoffset <= 26'd0;
            Out_Jump <= 1'b0;
            Out_Shift <= 1'b0;
            Out_shamt <= 32'd0;
        end else if (lock == 1'b0)
        begin
            Out_W <= In_W;
            Out_M <= In_M;
            Out_E <= In_E;
            Out_pc_incr <= In_pc_incr;
            Out_rd_1 <= In_rd_1;
            Out_rd_2 <= In_rd_2;
            Out_extend_immed <= In_extend_immed;
            Out_rt <= In_rt;
            Out_rd <= In_rd;
            Out_rs <= In_rs;
            Out_jumpoffset <= In_jumpoffset;
            Out_Jump <= In_Jump;
            Out_Shift <= In_Shift;
            Out_shamt <= In_shamt;
        end
    end


endmodule