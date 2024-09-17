module Multiplier( clk, dataA, dataB, Signal, dataOut, reset);
input clk, reset;
input [31:0] dataA, dataB ;
input Signal ;
output [63:0] dataOut ;

reg [63:0] product;
reg [63:0] finalproduct;
reg [63:0] multiplicand;
reg [31:0] multiplier;
reg lsb;

always@( Signal ) 
begin
  if (Signal == 1'b1) 
    begin 
      multiplicand = {32'b0, dataA};
      multiplier = dataB;
      product = 64'b0;
    end 
end 

always@( posedge clk or reset )
begin
	if ( reset )
	begin
		multiplicand = {32'b0, dataA};
		multiplier = dataB;
		product = 64'b0;
		finalproduct = 64'b0;
	end

	else if ( Signal == 1'b1 )
	begin	
		lsb = multiplier[0];
		if (lsb == 1'b1) 
		begin 
			product = product + multiplicand;
		end

		multiplicand = multiplicand << 1;
		multiplier = multiplier >> 1;
			
	end
	else 


	begin
		finalproduct = product;
	end
	
	end
	


assign dataOut = product;

endmodule