module hazard ( clk, rst, 
    instr, ID_EX_MemRead, ID_EX_Rt, IF_ID_Rs, IF_ID_Rt, 
    stall );
    input ID_EX_MemRead, rst, clk;
    input [31:0] instr;
    input [4:0] ID_EX_Rt, IF_ID_Rs, IF_ID_Rt;
    
    output stall;
    reg stall;
    

    always @( posedge clk ) begin
        if (ID_EX_MemRead && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt)))  // stall condition
			stall = 1'b1;

        else stall = 1'b0;
        if ( stall )
            $display( "%d, --stall--", $time/10-1 );
    end


    

endmodule