module hazard_mux( stall, In_W, In_M, In_E, Out_W, Out_M, Out_E  );
    input stall;
    input [1:0] In_W;
    input [2:0] In_M;
    input [3:0] In_E;
    output [1:0] Out_W;
    output [2:0] Out_M;
    output [3:0] Out_E;

    assign Out_W = (stall == 1'b0) ? In_W : 2'b0;
    assign Out_M = (stall == 1'b0) ? In_M : 3'b0;
    assign Out_E = (stall == 1'b0) ? In_E : 4'b0;

endmodule