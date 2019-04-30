//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation

always@( * )
begin
  if(ALUOp_i == 3'b000)      ALUCtrl_o = 4'b0010; //addi
  else if(ALUOp_i == 3'b001) ALUCtrl_o = 4'b0110; //beq
  else if(ALUOp_i == 3'b101) ALUCtrl_o = 4'b1011; //lui
  else if(ALUOp_i == 3'b110) ALUCtrl_o = 4'b0001; //ori
  else if(ALUOp_i == 3'b011) ALUCtrl_o = 4'b0110; //bne
  else if(ALUOp_i == 3'b111) ALUCtrl_o = 4'01111; //sltiu
  
  else if({ALUOp_i, funct_i} == 9'b010100001) ALUCtrl_o = 4'b0010; //addu
  else if({ALUOp_i, funct_i} == 9'b010100011) ALUCtrl_o = 4'b0110; //subu
  else if({ALUOp_i, funct_i} == 9'b010100100) ALUCtrl_o = 4'b0000; //and
  else if({ALUOp_i, funct_i} == 9'b010100101) ALUCtrl_o = 4'b0001; //or
  else if({ALUOp_i, funct_i} == 9'b010101010) ALUCtrl_o = 4'b1000; //slt
  //else if({ALUOp_i, funct_i} == 9'b010101011) ALUCtrl_o = 4'b0111; //sltu
  else if({ALUOp_i, funct_i} == 9'b010000011) ALUCtrl_o = 4'b1001; //sra
  else if({ALUOp_i, funct_i} == 9'b010000111) ALUCtrl_o = 4'b1001; //srav
  else ALUCtrl_o = 4'b1111;
end
endmodule     





                    
                    
