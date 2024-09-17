//	Title: MIPS Single-Cycle Processor
//	Editor: Selene (Computer System and Architecture Lab, ICE, CYCU)
module mips_pipeline( clk, rst );
	input clk, rst;
	
	// instruction bus
	wire[31:0] instr;
	
	// break out important fields from instruction
	wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] immed;
    wire [31:0] extend_immed, b_offset;
    wire [25:0] jumpoffset;
	
	// datapath signals
    wire [4:0] rfile_wn;
    wire [31:0] rfile_rd1, rfile_rd2, rfile_wd, alu_out, b_tgt, pc_next,
                pc, pc_incr, dmem_rdata, jump_addr, branch_addr, EX_MEM_b_tgt;

	

    // W = {RegWrite, MemtoReg}
	// M = {MemRead, MemWrite, Branch}
	// E = {ALUOp, RegDst, ALUSrc}

    wire [1:0] W_1, W_2, W_3, W_4;
    wire [2:0] M_1, M_2, M_3;
    wire [3:0] E_1, E_2;
	
	
	// jump offset shifter & concatenation
    wire ID_EX_Jump, EX_MEM_Jump, flush, Zero;
    wire [25:0] ID_EX_jumpoffset, EX_MEM_jumpoffset;
	assign jump_addr = { pc_incr[31:28], ID_EX_jumpoffset <<2 };

	// module instantiations
	
    wire PCSrc, Jump, stall, pause;


    // IF
    or flush_or( flush, PCSrc, ID_EX_Jump );

    and BR_AND(PCSrc, M_2[0], Zero);

    mux2 PCMUX( .sel(PCSrc), .a(pc_incr), .b(b_tgt), .y(branch_addr) );

    mux2 JMUX( .sel(ID_EX_Jump), .a(branch_addr), .b(jump_addr), .y(pc_next) );

    reg32 PC( .clk(clk), .rst(rst), .lock(stall||pause), .d_in(pc_next), .d_out(pc) );

    
    memory InstrMem( .clk(clk), .MemRead(1'b1&&!(pause||stall)), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(instr) );


    add32 PCADD( .a(pc), .b(32'd4), .result(pc_incr) );



      
    // IF/ID
    wire [31:0] IF_ID_instr, IF_ID_pc_incr;
    IF_ID IF_ID( .clk(clk), .rst(rst||flush), .lock(stall||pause),
            .In_instr(instr), .In_pc_incr(pc_incr), 
            .Out_instr(IF_ID_instr), .Out_pc_incr(IF_ID_pc_incr) );

    
   
    // control signals
    wire RegWrite, Branch, RegDst, MemtoReg, MemRead, MemWrite, ALUSrc, Shift;
    wire [1:0] ALUOp;
    wire [2:0] Operation;
	wire [31:0] extend_shamt;

    assign opcode = IF_ID_instr[31:26];
    assign rs = IF_ID_instr[25:21];
    assign rt = IF_ID_instr[20:16];
    assign rd = IF_ID_instr[15:11];
    assign funct = IF_ID_instr[5:0];
    assign immed = IF_ID_instr[15:0];
    
    assign extend_shamt =  { 27'b0, IF_ID_instr[10:6] };
    // { , IF_ID_instr[10:6] };

    // ID
    wire WB_RegWrite;
    
    control Control(.opcode(opcode), .funct(funct), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
                       .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), 
                       .Jump(Jump), .ALUOp(ALUOp), .Shift(Shift));

    reg_file RegFile( .clk(clk), .RegWrite(WB_RegWrite&&!(pause||stall)), .RN1(rs), .RN2(rt), .WN(rfile_wn), 
					  .WD(rfile_wd), .RD1(rfile_rd1), .RD2(rfile_rd2) );
    
    
	sign_extend SignExt( .immed_in(immed), .ext_immed_out(extend_immed) );


    

    // ID/EX
    wire [4:0] ID_EX_rt, ID_EX_rd, ID_EX_rs;
    wire [31:0] ID_EX_rd_1, ID_EX_rd_2;
    wire [31:0] ID_EX_extend_immed, ID_EX_pc_incr, ID_EX_shamt;
    wire ID_EX_Shift;

    hazard_mux hazard_mux( .stall(stall), .In_W({RegWrite, MemtoReg}), .In_M({ MemRead, MemWrite, Branch}), .In_E( { ALUOp, RegDst, ALUSrc }), .Out_W(W_1), .Out_M(M_1), .Out_E(E_1) );

    ID_EX ID_EX( .clk(clk), .rst(rst), .lock(pause), .flush(flush),
    .In_W(W_1), .In_M(M_1), .In_E(E_1), .In_pc_incr(IF_ID_pc_incr), 
    .In_rd_1(rfile_rd1), .In_rd_2(rfile_rd2), .In_extend_immed(extend_immed), .In_rt( rt ), .In_rd( rd ), .In_rs(rs),
    .In_jumpoffset(IF_ID_instr[25:0]), .In_Jump(Jump), .In_shamt(extend_shamt), .In_Shift(Shift),

    .Out_W(W_2), .Out_M(M_2), .Out_E(E_2), .Out_pc_incr(ID_EX_pc_incr), 
    .Out_rd_1(ID_EX_rd_1), .Out_rd_2(ID_EX_rd_2), .Out_extend_immed(ID_EX_extend_immed), .Out_rt( ID_EX_rt ), .Out_rd( ID_EX_rd ), .Out_rs(ID_EX_rs),
    .Out_jumpoffset(ID_EX_jumpoffset), .Out_Jump(ID_EX_Jump), .Out_shamt(ID_EX_shamt), .Out_Shift(ID_EX_Shift)
    );
    

    // EX
    wire [4:0] EX_wn;
    wire [1:0] ForwardA, ForwardB;
    wire [31:0] alu_a, alu_b, temp_a, Rd2_extend_mux, EX_MEM_alu_result;
    // branch offset shifter
    assign b_offset = ID_EX_extend_immed << 2;
    add32 BRADD( .a(ID_EX_pc_incr), .b(b_offset), .result(b_tgt) );

    
    mux2 ALUMUX( .sel(E_2[0]), .a(ID_EX_rd_2), .b(ID_EX_extend_immed), .y(Rd2_extend_mux) );   
    assign temp_a = (ID_EX_Shift) ? ID_EX_shamt : ID_EX_rd_1;
    mux3 forwarda( .sel(ForwardA), .a(temp_a), .b(rfile_wd), .c(EX_MEM_alu_result), .out(alu_a) );
    mux3 forwardb( .sel(ForwardB), .a(Rd2_extend_mux), .b(rfile_wd), .c(EX_MEM_alu_result), .out(alu_b) );

    TotalALU ALU_and_ALUControl( .clk(clk), .ALUOp(E_2[3:2]), .dataA(alu_a), .dataB(alu_b), .Funct(ID_EX_extend_immed[5:0]), 
                                .Output(alu_out), .reset(rst), .pause(pause) );

    
    assign Zero = (alu_out == 32'd0) ? 1'b1 : 1'b0;

    assign EX_wn = ( E_2[1] == 1'b0 ) ? ID_EX_rt : ID_EX_rd;


    // EX/MEM
    wire [31:0] EX_MEM_wd;
    wire [4:0] EX_MEM_wn;
    EX_MEM EX_MEM( .clk(clk), .rst(rst), .lock(pause),
    .In_W(W_2), .In_M(M_2),
    .In_alu_result(alu_out), .In_wd(ID_EX_rd_2), .In_wn(EX_wn),
    .In_Jump(ID_EX_Jump), .In_jumpoffset(ID_EX_jumpoffset),

    .Out_W(W_3), .Out_M(M_3),
    .Out_alu_result(EX_MEM_alu_result), .Out_wd(EX_MEM_wd), .Out_wn(EX_MEM_wn),
    .Out_Jump(EX_MEM_Jump), .Out_jumpoffset(EX_MEM_jumpoffset)
    );


    // MEM

    
    memory DatMem( .clk(clk), .MemRead(M_3[2]&&!pause), .MemWrite(M_3[1]&&!pause), .wd(EX_MEM_wd), 
				   .addr(EX_MEM_alu_result), .rd(dmem_rdata) );	   
    
    // MEM/WB
    wire [31:0] MEM_WB_dmem_rdata, MEM_WB_alu_result;
    wire [4:0] MEM_WB_wn;
    MEM_WB MEM_WB( .clk(clk), .rst(rst), .lock(pause),
    .In_W(W_3), .In_alu_result(EX_MEM_alu_result), .In_dmem_rdata(dmem_rdata), .In_wn(EX_MEM_wn),
    .Out_W(W_4), .Out_alu_result(MEM_WB_alu_result), .Out_dmem_rdata(MEM_WB_dmem_rdata), .Out_wn(MEM_WB_wn)
    );


    // WB
    assign rfile_wd = ( W_4[0] == 1'b0 ) ? MEM_WB_alu_result : MEM_WB_dmem_rdata;
    assign WB_RegWrite = W_4[1];
    assign rfile_wn = MEM_WB_wn;


	

	// forwarding unit
    forwarding forwarding_unit( .EX_MEM_Regwrite(W_3[1]), .EX_MEM_Rd(EX_MEM_wn),
                .MEM_WB_Regwrite(W_4[1]), .MEM_WB_Rd(MEM_WB_wn), .ID_EX_Rs(ID_EX_rs), .ID_EX_Rt(ID_EX_rt), 
                .ForwardA(ForwardA), .ForwardB(ForwardB));

 

	// hazard detection unit
    hazard hazard_detection_unit( .clk(clk), .rst(rst), .instr(IF_ID_instr),
    .ID_EX_MemRead(M_2[2]), .ID_EX_Rt(ID_EX_rt), .IF_ID_Rs(rs), .IF_ID_Rt(rt),
     .stall(stall) );


	
				   
endmodule
