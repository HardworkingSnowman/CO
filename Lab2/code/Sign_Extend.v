//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
    op_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
input   [6-1:0] op_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @(*) begin

if(ALUOp_i == 3'b111) begin
  data_o={16'b0000000000000000,data_i};
  end
  
else if(ALUOp_i == 3'b110) begin
  data_o={16'b0000000000000000,data_i};
  end
  
else if({ALUOp_i, funct_i} == 9'b010000011) begin
  data_o={16'b0000000000000000,data_i};
  end
  
else begin
  data_o={{16{data_i[15]}},data_i};
  end  
end
          
endmodule      
     
