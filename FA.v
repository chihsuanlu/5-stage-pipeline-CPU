module FA( dataA, dataB, CarryIn, SumOut, CarryOut);
    output SumOut, CarryOut;
    input dataA, dataB, CarryIn;
    assign CarryOut = (dataA & dataB) | (dataA & CarryIn) | (dataB & CarryIn);
    assign SumOut = dataA ^ dataB ^ CarryIn;

endmodule