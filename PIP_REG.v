`timescale 1ns / 1ps
`include defines.v
module PIP_REG (
	 input rst_n
	,input clk
	,input [`InstAddrBus] addr_i
	,input [`RegBus] data_i
	,output reg [`InstAddrBus] addr_o
	,output reg [`RegBus] data_o
);

always @(negedge rst_n or posedge clk)
begin
	if(!rst_n) 
		addr_o<=(`RegWidth)'b0;
		data_o<=(`RegWidth)'b0;
	else 
	begin
		addr_o<=addr_i;
		data_o<=data_o;
	end
end 

endmodule     	