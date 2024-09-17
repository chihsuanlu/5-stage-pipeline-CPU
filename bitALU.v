module bitALU( dataA, dataB, Signal, Less, Invert , CarryIn, CarryOut, SumOut, FAOut );
    input dataA, dataB, CarryIn, Invert, Less ;
    input [2:0] Signal ;
    output  CarryOut, SumOut, FAOut ;
    wire XB, carryout, andOut, orOut ;

    /*
    定義各種訊號
    */

    assign XB = dataB ^ Invert ;
    assign andOut = dataA & dataB ;
    assign orOut = dataA | dataB ;

    // dataA + dataB 的加法器
    FA FULL_ADDER( .dataA(dataA), .dataB(XB), .CarryIn(CarryIn), .SumOut( FAOut ), .CarryOut(CarryOut) ) ;

    // 4to1 MUX 依照訊號選擇輸出
    MUX_4to1 MUX_4to1( .Signal(Signal), .andIn(andOut), .orIn(orOut), .FAIn(FAOut), .SLTIn(Less), .dataOut(SumOut) ) ;

endmodule
