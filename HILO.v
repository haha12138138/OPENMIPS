`timescale 1ns / 1ps
`include "defines.v"
module HILO (
	 input rst_n
	,input clk
	,input HILO_w_en_i
	,input HILO_w_addr_i
	,input HILO_r_en_i
	,input HILO_r_addr_i
	,input [`RegBus] HILO_w_data 
	,output reg [`RegBus] HILO_r_data
);
reg[`RegBus] HILO[1:0];
always @(negedge rst_n or posedge clk)
begin
	if(rst_n==`RstEnable) 
	begin
		HILO[0]<=`RegWidth'b0;//LO
		HILO[1]<=`RegWidth'b0;//HI
	end	
	else 
	begin
		if(HILO_w_en_i==`WriteEnable)
		begin
			HILO[HILO_w_addr_i]<=HILO_w_data;
		end
	end
end 
always @ (*)
begin
	if(rst_n==`RstEnable||HILO_r_en_i==`ReadDisable)
	begin
		HILO_r_data=`RegWidth'b0;
	end
	else
	begin
		if((HILO_w_en_i==`WriteEnable)&&(HILO_w_addr_i==HILO_r_addr_i))
		begin
			HILO_r_data=HILO_w_data;
		end
		else
		begin
			HILO_r_data=HILO[HILO_r_addr_i];
		end
	end
end // always

endmodule     	