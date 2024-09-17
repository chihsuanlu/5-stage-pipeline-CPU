module MEM_WB( clk, rst, lock,
    In_W, In_alu_result, In_dmem_rdata, In_wn,
    Out_W, Out_alu_result, Out_dmem_rdata, Out_wn
    );
    input clk, rst, lock;
    input[1:0] In_W;
    input [31:0] In_alu_result, In_dmem_rdata;
    input [4:0] In_wn;
    output[1:0] Out_W;
    output [31:0] Out_alu_result, Out_dmem_rdata;
    output [4:0] Out_wn;
    reg[1:0] Out_W;
    reg [31:0] Out_alu_result, Out_dmem_rdata;
    reg [4:0] Out_wn;
    always @(posedge clk) begin
        if (rst) begin
            Out_W <= 1'b0;
            Out_alu_result <= 32'd0;
            Out_dmem_rdata <= 32'd0;
            Out_wn <= 5'd0;
        end 
        else if (lock == 1'b0)
         begin
            Out_W <= In_W;
            Out_alu_result <= In_alu_result;
            Out_dmem_rdata <= In_dmem_rdata;
            Out_wn <= In_wn;
        end
    end
endmodule