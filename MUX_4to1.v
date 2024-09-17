module MUX_4to1( Signal, andIn, orIn, FAIn, SLTIn, dataOut );

input [2:0] Signal ;
input andIn, orIn, FAIn, SLTIn ;
output dataOut ;
wire temp ;

parameter AND = 3'b000;
parameter OR  = 3'b001;
parameter ADD = 3'b010;
parameter SUB = 3'b110;
parameter SLT = 3'b111;

assign dataOut = ( Signal == AND ) ? andIn :
               ( Signal == OR ) ? orIn :
               ( Signal == ADD || Signal == SUB ) ? FAIn :
               ( Signal == SLT ) ? SLTIn :
               temp ;


endmodule