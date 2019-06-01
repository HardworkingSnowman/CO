//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: To know whether to use branch
//--------------------------------------------------------------------------------

module Whether_Branch(
  src1_i,
  src2_i,
  instr_op_i,
  branch_res_o
  );

input  [32-1:0] src1_i;
input  [32-1:0] src2_i;
input  [6-1:0]  instr_op_i;

output branch_res_o;


reg branch_res_o;

always@(*)
begin
  case(instr_op_i)
    // beq
    6'b000100: begin
      if(src1_i == src2_i) branch_res_o = 1;
      else branch_res_o = 0;
    end
    // bne, bnez
    6'b000101: begin
      if(src1_i != src2_i) branch_res_o = 1;
      else branch_res_o = 0;
    end
    // bltz
    6'b000001: begin
      if($signed(src1_i) < 0) branch_res_o = 1;
      else branch_res_o = 0;
    end
    // ble
    6'b000110: begin
      if($signed(src1_i) <= $signed(src2_i)) branch_res_o = 1;
      else branch_res_o = 0;
    end
  endcase
end

endmodule