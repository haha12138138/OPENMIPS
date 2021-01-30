`include "defines.v"
`timescale 1ns / 1ps

module pc_reg (
	 input rst_n
	,input clk
	,output reg [`InstAddrBus] pc
	,output reg ce
);

always @(negedge rst_n or posedge clk)
begin
	if(rst_n==`RstEnable) 
	begin
		ce <= `ChipDisable ;
	end
	else 
	begin
		ce<= `ChipEnable;
	end
end 
always @ (posedge clk )
begin
	if(ce==`ChipDisable)
	begin
		pc<=32'b0 ;
	end
	else
	begin
		pc<=pc+32'd4 ;
	end
end
endmodule     	