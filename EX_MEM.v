module EX_MEM( clk, rst, lock,
    In_W, In_M,
    In_alu_result, In_wd, In_wn,
    In_Jump, In_jumpoffset,

    Out_W, Out_M,
    Out_alu_result, Out_wd, Out_wn,
    Out_Jump, Out_jumpoffset
    );
    input clk, rst, lock;
    input [1:0] In_W;
    input [2:0] In_M;
    input [31:0] In_alu_result, In_wd;
    input [4:0] In_wn;
    input [25:0] In_jumpoffset;
    input In_Jump;
    
    output [1:0] Out_W;
    output [2:0] Out_M;
    output [31:0] Out_alu_result, Out_wd;
    output [4:0] Out_wn;
    output [25:0] Out_jumpoffset;
    output Out_Jump;

    reg [1:0] Out_W;
    reg [2:0] Out_M;
    reg [31:0] Out_alu_result, Out_wd;
    reg [4:0] Out_wn;
    reg [25:0] Out_jumpoffset;
    reg Out_Jump;

    always @(posedge clk) begin
        if (rst) begin
            Out_W <= 1'b0;
            Out_M <= 1'b0;
            Out_alu_result <= 32'd0;
            Out_wd <= 32'd0;
            Out_wn <= 5'd0;
            Out_jumpoffset <= 26'd0;
            Out_Jump <= 1'b0;
        end
         else if (lock == 1'b0)
         begin
            Out_W <= In_W;
            Out_M <= In_M;
            Out_alu_result <= In_alu_result;
            Out_wd <= In_wd;
            Out_wn <= In_wn;
            Out_jumpoffset <= In_jumpoffset;
            Out_Jump <= In_Jump;
        end
    end
endmodule
