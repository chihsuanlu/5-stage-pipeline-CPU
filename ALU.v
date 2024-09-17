module ALU(dataA, dataB, Signal, dataOut, reset);
	input reset;
	input [31:0] dataA;
	input [31:0] dataB;
	input [2:0] Signal;
	output [31:0] dataOut;
	  
	wire O = 1'b0; 
	wire[32:0] Carry;
	wire Invert, Less;
	wire [31:0] temp;
	  
	parameter AND = 3'b000; 
	parameter OR  = 3'b001; 
	parameter ADD = 3'b010; 
	parameter SUB = 3'b110;
	parameter SLT = 3'b111; 
	  
	/*
	=====================================================
	下面為32bit ALU
	=====================================================
	*/
	assign Invert = ( Signal == SUB || Signal == SLT ) ? 1'b1 : 1'b0 ;

	// 串接32個bitALU
	bitALU bitALU0( .dataA(dataA[0]), .dataB(dataB[0]), .Signal(Signal), .Less(Less), .Invert(Invert) , .CarryIn(Invert), .CarryOut(Carry[1]), .FAOut(), .SumOut(dataOut[0]) ) ;
	bitALU bitALU1( .dataA(dataA[1]), .dataB(dataB[1]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[1]), .CarryOut(Carry[2]), .FAOut(), .SumOut(dataOut[1]) ) ;
	bitALU bitALU2( .dataA(dataA[2]), .dataB(dataB[2]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[2]), .CarryOut(Carry[3]), .FAOut(), .SumOut(dataOut[2]) ) ;
	bitALU bitALU3( .dataA(dataA[3]), .dataB(dataB[3]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[3]), .CarryOut(Carry[4]), .FAOut(), .SumOut(dataOut[3]) ) ;
	bitALU bitALU4( .dataA(dataA[4]), .dataB(dataB[4]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[4]), .CarryOut(Carry[5]), .FAOut(), .SumOut(dataOut[4]) ) ;
	bitALU bitALU5( .dataA(dataA[5]), .dataB(dataB[5]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[5]), .CarryOut(Carry[6]), .FAOut(), .SumOut(dataOut[5]) ) ;
	bitALU bitALU6( .dataA(dataA[6]), .dataB(dataB[6]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[6]), .CarryOut(Carry[7]), .FAOut(), .SumOut(dataOut[6]) ) ;
	bitALU bitALU7( .dataA(dataA[7]), .dataB(dataB[7]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[7]), .CarryOut(Carry[8]), .FAOut(), .SumOut(dataOut[7]) ) ;
	bitALU bitALU8( .dataA(dataA[8]), .dataB(dataB[8]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[8]), .CarryOut(Carry[9]), .FAOut(), .SumOut(dataOut[8]) ) ;
	bitALU bitALU9( .dataA(dataA[9]), .dataB(dataB[9]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[9]), .CarryOut(Carry[10]), .FAOut(), .SumOut(dataOut[9]) ) ;
	bitALU bitALU10( .dataA(dataA[10]), .dataB(dataB[10]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[10]), .CarryOut(Carry[11]), .FAOut(), .SumOut(dataOut[10]) ) ;
	bitALU bitALU11( .dataA(dataA[11]), .dataB(dataB[11]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[11]), .CarryOut(Carry[12]), .FAOut(), .SumOut(dataOut[11]) ) ;
	bitALU bitALU12( .dataA(dataA[12]), .dataB(dataB[12]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[12]), .CarryOut(Carry[13]), .FAOut(), .SumOut(dataOut[12]) ) ;
	bitALU bitALU13( .dataA(dataA[13]), .dataB(dataB[13]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[13]), .CarryOut(Carry[14]), .FAOut(), .SumOut(dataOut[13]) ) ;
	bitALU bitALU14( .dataA(dataA[14]), .dataB(dataB[14]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[14]), .CarryOut(Carry[15]), .FAOut(), .SumOut(dataOut[14]) ) ;
	bitALU bitALU15( .dataA(dataA[15]), .dataB(dataB[15]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[15]), .CarryOut(Carry[16]), .FAOut(), .SumOut(dataOut[15]) ) ;
	bitALU bitALU16( .dataA(dataA[16]), .dataB(dataB[16]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[16]), .CarryOut(Carry[17]), .FAOut(), .SumOut(dataOut[16]) ) ;
	bitALU bitALU17( .dataA(dataA[17]), .dataB(dataB[17]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[17]), .CarryOut(Carry[18]), .FAOut(), .SumOut(dataOut[17]) ) ;
	bitALU bitALU18( .dataA(dataA[18]), .dataB(dataB[18]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[18]), .CarryOut(Carry[19]), .FAOut(), .SumOut(dataOut[18]) ) ;
	bitALU bitALU19( .dataA(dataA[19]), .dataB(dataB[19]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[19]), .CarryOut(Carry[20]), .FAOut(), .SumOut(dataOut[19]) ) ;
	bitALU bitALU20( .dataA(dataA[20]), .dataB(dataB[20]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[20]), .CarryOut(Carry[21]), .FAOut(), .SumOut(dataOut[20]) ) ;
	bitALU bitALU21( .dataA(dataA[21]), .dataB(dataB[21]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[21]), .CarryOut(Carry[22]), .FAOut(), .SumOut(dataOut[21]) ) ;
	bitALU bitALU22( .dataA(dataA[22]), .dataB(dataB[22]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[22]), .CarryOut(Carry[23]), .FAOut(), .SumOut(dataOut[22]) ) ;
	bitALU bitALU23( .dataA(dataA[23]), .dataB(dataB[23]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[23]), .CarryOut(Carry[24]), .FAOut(), .SumOut(dataOut[23]) ) ;
	bitALU bitALU24( .dataA(dataA[24]), .dataB(dataB[24]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[24]), .CarryOut(Carry[25]), .FAOut(), .SumOut(dataOut[24]) ) ;
	bitALU bitALU25( .dataA(dataA[25]), .dataB(dataB[25]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[25]), .CarryOut(Carry[26]), .FAOut(), .SumOut(dataOut[25]) ) ;
	bitALU bitALU26( .dataA(dataA[26]), .dataB(dataB[26]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[26]), .CarryOut(Carry[27]), .FAOut(), .SumOut(dataOut[26]) ) ;
	bitALU bitALU27( .dataA(dataA[27]), .dataB(dataB[27]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[27]), .CarryOut(Carry[28]), .FAOut(), .SumOut(dataOut[27]) ) ;
	bitALU bitALU28( .dataA(dataA[28]), .dataB(dataB[28]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[28]), .CarryOut(Carry[29]), .FAOut(), .SumOut(dataOut[28]) ) ;
	bitALU bitALU29( .dataA(dataA[29]), .dataB(dataB[29]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[29]), .CarryOut(Carry[30]), .FAOut(), .SumOut(dataOut[29]) ) ;
	bitALU bitALU30( .dataA(dataA[30]), .dataB(dataB[30]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[30]), .CarryOut(Carry[31]), .FAOut(), .SumOut(dataOut[30]) ) ;
	bitALU bitALU31( .dataA(dataA[31]), .dataB(dataB[31]), .Signal(Signal), .Less(O), .Invert(Invert) , .CarryIn(Carry[31]), .CarryOut(Carry[32]), .FAOut(Less), .SumOut(dataOut[31]) ) ;

	assign dataOut = reset?32'b0:temp ;
	/*
	=====================================================
	上面為32bit ALU
	=====================================================
	*/

endmodule