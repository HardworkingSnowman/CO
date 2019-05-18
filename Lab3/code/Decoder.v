//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    func_code_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
  Jump_o,
  MemRead_o,
  MemWrite_o,
  MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] func_code_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         Jump_o;
output         MemRead_o;
output         MemWrite_o;
output         MemtoReg_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            Jump_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            MemtoReg_o;

//Parameter


//Main function

always@(*)
begin
  if({instr_op_i, func_code_i} == 12'b000000000000)  // NOP
  begin
    RegDst_o=1'b0;
    ALUSrc_o=1'b0;
    RegWrite_o=1'b0;
    Branch_o=1'b0;
    ALU_op_o=3'b000;
    Jump_o=1'b0;
    MemRead_o=1'b0;
    MemWrite_o=1'b0;
    MemtoReg_o=1'b0;
  end
  else if(instr_op_i==6'b000000) // R type
  begin
    RegDst_o=1'b1;
    ALUSrc_o=1'b0;
    RegWrite_o=1'b1;
    Branch_o=1'b0;
    ALU_op_o=3'b010;
    Jump_o=1'b0;
    MemRead_o=1'b0;
    MemWrite_o=1'b0;
    MemtoReg_o=1'b0;
  end
  else if(instr_op_i[5:1] == 5'b00001) // j, jal
  begin
    RegDst_o=1'b0;
    ALUSrc_o=1'b0;
    Branch_o=1'b0;
    Jump_o=1'b1;
    MemRead_o=1'b0;
    MemWrite_o=1'b0;
    MemtoReg_o=1'b0;
    ALU_op_o=3'b000;
    if(instr_op_i == 6'b000010) RegWrite_o = 1'b0;  // j
    else if(instr_op_i == 6'b000011) RegWrite_o = 1'b1; //jal
  end
  else if(instr_op_i[5:3] == 3'b000) // branch
  begin
    RegDst_o = 1'b0;
    ALUSrc_o = 1'b0;
    RegWrite_o = 1'b0;
    Branch_o = 1'b1;
    Jump_o=1'b0;
    MemRead_o=1'b0;
    MemWrite_o=1'b0;
    MemtoReg_o=1'b0;
    ALU_op_o = 3'b000;
  end
  else if(instr_op_i[5:3] == 3'b001) // I type
  begin
    RegDst_o=1'b0;
    ALUSrc_o=1'b1;
    RegWrite_o=1'b1;
    Branch_o=1'b0;
    Jump_o=1'b0;
    MemRead_o=1'b0;
    MemWrite_o=1'b0;
    MemtoReg_o=1'b0;
    if(instr_op_i[2:0] == 3'b000) ALU_op_o = 3'b000; // addi
    else if(instr_op_i[2:0] == 3'b011) ALU_op_o = 3'b111; // sltiu
    else if(instr_op_i[2:0] == 3'b111) ALU_op_o = 3'b101; // lui
    else if(instr_op_i[2:0] == 3'b101) ALU_op_o = 3'b110; // ori
    else if(instr_op_i[2:0] == 3'b111) ALU_op_o = 3'b000; // li
  end
  else if(instr_op_i == 6'b100011) // lw
  begin
    RegDst_o=1'b0;
    ALUSrc_o=1'b1;
    RegWrite_o=1'b1;
    Branch_o=1'b0;
    Jump_o=1'b0;
    MemRead_o=1'b1;
    MemWrite_o=1'b0;
    MemtoReg_o=1'b1;
    ALU_op_o = 3'b000;
  end
  else if(instr_op_i == 6'b101011) // sw
  begin
    RegDst_o=1'b0;
    ALUSrc_o=1'b1;
    RegWrite_o=1'b0;
    Branch_o=1'b0;
    Jump_o=1'b0;
    MemRead_o=1'b0;
    MemWrite_o=1'b1;
    MemtoReg_o=1'b0;
    ALU_op_o = 3'b000;
  end
end

endmodule





                    
                    
