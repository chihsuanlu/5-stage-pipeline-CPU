module forwarding( EX_MEM_Regwrite, EX_MEM_Rd,
 MEM_WB_Regwrite, MEM_WB_Rd, ID_EX_Rs, ID_EX_Rt, 
 ForwardA, ForwardB);

  input EX_MEM_Regwrite, MEM_WB_Regwrite;
  input [4:0] EX_MEM_Rd, MEM_WB_Rd;
  input [4:0] ID_EX_Rs, ID_EX_Rt;
  output [1:0] ForwardA, ForwardB;

  assign ForwardA = ( EX_MEM_Regwrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs) ) ? 2'b10 :
                    ( MEM_WB_Regwrite && (MEM_WB_Rd != 5'b0) && (MEM_WB_Rd == ID_EX_Rs) && !(EX_MEM_Regwrite && ( EX_MEM_Rd != 5'b0 ))
                      &&  (MEM_WB_Rd == ID_EX_Rs))? 2'b01 :
                    2'b00;
  assign ForwardB = ( EX_MEM_Regwrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rt) ) ? 2'b10 :
                      ( MEM_WB_Regwrite && (MEM_WB_Rd != 5'b0) && (MEM_WB_Rd == ID_EX_Rt) && !(EX_MEM_Regwrite && ( EX_MEM_Rd != 5'b0 ))
                          &&  (MEM_WB_Rd == ID_EX_Rt))? 2'b01 :
                      2'b00;
endmodule