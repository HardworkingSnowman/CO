//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter
assign zero_o = (result_o == 0) ^ (ctrl_i == 4'b0101);

//Main function
always@(*)
begin
	case(ctrl_i)
		//and
		4'b0000 : result_o = src1_i & src2_i;
		//ori, or
		4'b0001 : result_o = src1_i | src2_i;
		//addu, addi
		4'b0010 : result_o = src1_i + src2_i;
		//subu
		4'b0110 : result_o = src1_i - src2_i;
		//sltiu
		4'b0111 : result_o = (src1_i < src2_i) ? 1 : 0;
		//slt
		4'b1000 : result_o = ($signed(src1_i) < $signed(src2_i)) ? 1 : 0;
		//sra, srav
		4'b1001 : result_o = $signed(src2_i) >>> src1_i;
		//mul
		4'b1010 : result_o = $signed(src1_i) * $signed(src2_i);
		//lui
		4'b1011 : result_o = src2_i << 16;
	endcase
end
endmodule