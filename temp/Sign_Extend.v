//0616088
//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer: 0616088     
//----------------------------------------------
//Date: 5/19       
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
	//isOri_i,
    data_i,
    data_o
);

parameter size = 1;

//I/O ports
//input	isOri_i;
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @(data_i)
begin
	if ( data_i[15] == 0 )
		data_o = {16'd0,data_i};
	else
		data_o = {16'd1,data_i};
end
endmodule