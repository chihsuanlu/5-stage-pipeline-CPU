 /*
	Title:	ALU Control Unit
	Author: Garfield (Computer System and Architecture Lab, ICE, CYCU)
	Input Port
		1. ALUOp: 控制alu是要用+還是-或是其他指令
		2. Funct: 如果是其他指令則用這邊6碼判斷
	Output Port
		1. ALUOperation: 最後解碼完成之指令
*/

module alu_ctl( clk, reset, ALUOp, Funct, AddSignal, SignaltoALU, SignaltoSHT, SignaltoMULTU, SignaltoMUX, pause, last );
	input clk, reset ;
    input [1:0] ALUOp;
    input [5:0] Funct;
	reg [2:0] ALUOperation ;
	reg [1:0] MUXOperation ;
	reg MULTUOperation, AddOperation ;
	reg [6:0] counter ;

	output [2:0] SignaltoALU ;
	output SignaltoMULTU, AddSignal, pause, last ;
	output [1:0] SignaltoMUX ;
	output [2:0] SignaltoSHT ;

    reg pause, last;

    // symbolic constants for instruction function code
	parameter AND = 6'b100100;
	parameter OR  = 6'b100101;
	parameter ADD = 6'b100000;
	parameter SUB = 6'b100010;
	parameter SLT = 6'b101010;
	parameter ZERO = 6'b000000;
	parameter SRL = 6'b000010;
	parameter MULTU = 6'b011001;
	parameter MADDU = 6'b000001;
	parameter MFHI = 6'b010000;
	parameter MFLO = 6'b010010;
	
    // symbolic constants for ALU Operations	
    parameter ALU_and = 3'b000;
    parameter ALU_or  = 3'b001;
    parameter ALU_add = 3'b010;
    parameter ALU_sub = 3'b110;
    parameter ALU_slt = 3'b111;
    parameter SHT_srl = 3'b011;
	parameter MUL_mfhi= 3'b100;
	parameter MUL_mflo = 3'b101;

    always @( ALUOp or Funct )
    begin
		MUXOperation = 2'b00 ;
        case ( ALUOp ) 
            2'b00 : ALUOperation = ALU_add; // lw or sw
            2'b01 : ALUOperation = ALU_sub; // beq a - b = 0 ?
            2'b10 : case (Funct) 
                        ADD : ALUOperation = ALU_add;
                        SUB : ALUOperation = ALU_sub;
                        AND : ALUOperation = ALU_and;
                        OR  : ALUOperation = ALU_or;
                        SLT : ALUOperation = ALU_slt;
						SRL :
							begin
								ALUOperation = SHT_srl;
								MUXOperation = 2'b11 ;
							end
						
                        MFHI : begin 
								ALUOperation = MUL_mfhi;
								MUXOperation = 2'b01 ;
                                AddOperation = 1'b0;
								end
                        MFLO : begin
								ALUOperation = MUL_mflo;
								MUXOperation = 2'b10 ;
                                AddOperation = 1'b0;
								end
						MULTU :begin
                                pause = 1'b1;
						 		MULTUOperation = 1'b1;
								end
						
						MADDU : begin
                                pause = 1'b1;
						 		MULTUOperation = 1'b1;
								end
                        default begin
							ALUOperation = 3'bxxx;
							MULTUOperation = 1'b0;
						end
                    endcase
            default begin
				ALUOperation = 3'bxxx;
				MULTUOperation = 1'b0;
			end
        endcase
		
    end
	
	always @( negedge clk) begin
		if (counter == 33 && pause == 1'b0)
		begin
			counter = 40;
		end
		else if ( counter == 40 && ALUOp == 2'b10 && ( Funct == MADDU  || Funct == MULTU ) )
		begin
			MULTUOperation = 1'b1;
			pause = 1'b1;
			counter = 0 ;
		end
	end
	
	always @( posedge clk )
	begin
		if ( counter == 33 && pause == 1'b1 )
		begin
			pause = 1'b0;
		end
	end

	always @( posedge clk or reset  )
	begin

        if( reset == 1'b1 )
        begin
            ALUOperation = 3'bxxx;
			MULTUOperation = 1'b0;
			MUXOperation = 2'b00 ;
			AddOperation = 1'b0;
			counter = 0 ;
			pause = 1'b0;
			last = 1'b0;
        end

		if ( MULTUOperation == 1'b1 )
	    begin
			counter = counter + 1 ;
			if ( counter >= 33 )
			begin
				MULTUOperation = 1'b0; 
                AddOperation = 1'b0;
                last = 1'b0;
			end

            if ( counter == 32 && ALUOp == 2'b10 && Funct == MADDU )
            begin
                AddOperation = 1'b1;
                last = 1'b1;
            end
            else if( counter == 32 && ALUOp == 2'b10 && Funct != MADDU )
            begin
                last = 1'b1;
            end

		end
		
	end
	
	assign SignaltoALU = ALUOperation ;
	assign SignaltoMULTU = MULTUOperation ;
	assign SignaltoMUX = MUXOperation ;
	assign SignaltoSHT = ALUOperation ;
	assign AddSignal = AddOperation ;
endmodule

