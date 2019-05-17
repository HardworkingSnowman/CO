//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
//pc
wire [32-1:0] pc_input, pc_output, pc_4, pc_instr, pc_address_without_jump;
wire [32-1:0] pc_se, pc_se_sl2, pc_se_sl2_PLUS_pc_4;

//decoder
wire RegDst, Branch, ALUSrc, RegWrite, Jump, MemRead, MemWrite, MemtoReg;
wire [3-1:0] ALUOp;

//alu
wire [32-1:0] alu_src1, alu_src2, alu_result;
wire alu_zero;
wire [4-1:0] alu_ctrl;

//reg
wire [5-1:0] reg_dst;
wire [32-1:0] reg_rs, reg_rt;

// jump
wire [5-1:0]  final_RDaddr;
wire [32-1:0] lower_jump, RDdata_without_lw;
wire [32-1:0] jump_whole, j_jal;
assign j_jal = {pc_instr[31:28], lower_jump[27:0]};

// lw, sw
wire [32-1:0] final_RDdata, mem_res_lw;

// branch
wire branch_res;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_input) ,   
	    .pc_out_o(pc_output) 
	    );
	
Adder Adder1(
        .src1_i(pc_output),     
	    .src2_i(4),     
	    .sum_o(pc_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_output),  
	    .instr_o(pc_instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(pc_instr[20:16]),
        .data1_i(pc_instr[15:11]),
        .select_i(RegDst),
        .data_o(reg_dst)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(pc_instr[25:21]) ,  
        .RTaddr_i(pc_instr[20:16]) ,  
        .RDaddr_i(final_RDaddr) ,  
        .RDdata_i(final_RDdata)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(reg_rs) ,  
        .RTdata_o(reg_rt)   
        );
	
Decoder Decoder(
        .instr_op_i(pc_instr[31:26]), 
        .func_code_i(pc_instr[5:0]),
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
	        .Branch_o(Branch),
                .Jump_o(Jump),
                .MemRead_o(MemRead),
                .MemWrite_o(MemWrite),
                .MemtoReg_o(MemtoReg)
	    );

ALU_Ctrl AC(
        .funct_i(pc_instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(alu_ctrl) 
        );
	
Sign_Extend SE(
        .data_i(pc_instr[15:0]),
        .op_i(pc_instr[31:26]),
        .ALUOp_i(ALUOp),
        .funct_i(pc_instr[5:0]),
        .data_o(pc_se)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(reg_rt),
        .data1_i(pc_se),
        .select_i(ALUSrc),
        .data_o(alu_src2)
        );	

MUX_2to1 #(.size(32)) Mux_if_sra(
        .data0_i(reg_rs),
        .data1_i({27'b0, pc_instr[10:6]}),
        .select_i(pc_instr[5:0] == 3),
        .data_o(alu_src1)
        );
		
ALU ALU(
        .src1_i(alu_src1),
	    .src2_i(alu_src2),
	    .ctrl_i(alu_ctrl),
	    .result_o(alu_result),
		.zero_o(alu_zero)
	);
		
Adder Adder2(
        .src1_i(pc_4),     
	    .src2_i(pc_se_sl2),     
	    .sum_o(pc_se_sl2_PLUS_pc_4)      
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(pc_se),
        .data_o(pc_se_sl2)
        ); 		

		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_4),
        .data1_i(pc_se_sl2_PLUS_pc_4),
        .select_i(Branch & branch_res),
        .data_o(pc_address_without_jump)
        );

// about jump	
Shift_Left_Two_32 get_jump_lower(       // to get the lower 28 bits from 25 bits instrction
        .data_i({6'b0, pc_instr[25:0]}),
        .data_o(lower_jump)
        );

MUX_2to1 #(.size(32)) MUX_get_jump_whole(       // 要用 jal/j 還是 jr
        .data0_i(reg_rs),
        .data1_i(j_jal),
        .select_i(jump),
        .data_o(jump_whole)
        );

MUX_2to1 #(.size(32)) MUX_PC_Jump(      // 要用 jal 或 j 的 還是 branch 或原本的
        .data0_i(pc_address_without_jump),
        .data1_i(jump_whole),
        .select_i(jump | ({pc_instr[31:26], pc_instr[5:0]} == 12'b000000001000)),
        .data_o(pc_input)
        );

MUX_2to1 #(.size(5)) get_final_RDaddr(         // 確認 Reg_File 的 RDaddr 是否使用 jal
        .data0_i(reg_dst),
        .data1_i(5'b11111),
        .select_i(RegWrite & jump),
        .data_o(final_RDaddr)
        );

MUX_2to1 #(.size(32)) get_RDdata_without_lw(    // 確認 Reg_File 的 RDdata 是否使用 jal
        .data0_i(alu_result),
        .data1_i(pc_4),
        .select_i(RegWrite & jump),
        .data_o(RDdata_without_lw)
        );

// lw
// R[rt] = Mem[R[rs] + SignExt(imm16)]
// sw
// Mem[R[rs] + SignExt(imm16)] = R[rt]

MUX_2to1 #(.size(32)) get_final_RDdata(
        .data0_i(alu_result),
        .data1_i(mem_res_lw),
        .select_i(MemtoReg),
        .data_o(final_RDdata)
        );

Data_Memory Data_Memory(        // sw, lw
        .clk_i(clk_i),
        .addr_i(alu_result),
        .data_i(reg_rt),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(mem_res_lw)
        );

// branch
Whether_Branch get_branch_res(
        .src1_i(alu_src1),
        .src2_i(alu_src2),
        .instr_op_i(pc_instr[31:26]),
        .branch_res_o(branch_res)
        );

endmodule
		  


