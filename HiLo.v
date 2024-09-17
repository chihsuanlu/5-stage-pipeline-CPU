module HiLo( clk, MultuAns, last, AddSignal, Signal, HiOut, LoOut, reset );
	input clk ;
	input reset, AddSignal, last ;
	input [1:0] Signal ;
	input [63:0] MultuAns ;
	output [31:0] HiOut ;
	output [31:0] LoOut ;

	reg [63:0] HiLo, tmp_HiLo ;


	always@( last )

	begin
		if ( reset )
		begin
		HiLo = 64'b0 ;
		tmp_HiLo = 64'b0 ;
		end

		
		if (AddSignal == 1'b1 && last)
		begin
		HiLo = HiLo + MultuAns ;
		
		end
		else if (last == 1'b1)
		begin
		HiLo = MultuAns ;
		end
	end

	assign HiOut = HiLo[63:32] ;
	assign LoOut = HiLo[31:0] ;

endmodule