module mux3( a, b, c, sel, out );
    input [31:0] a, b, c;
    input [1:0] sel;
    output [31:0] out;
    assign out = (sel == 2'b00) ? a :
                 (sel == 2'b01) ? b :
                 c;

endmodule 