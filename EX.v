`timescale 1ns / 1ps
`include "defines.v"
module EX (
	  input rst_n
	 ,input [`AluOpBus] aluop_i
	 ,input [`AluSelBus] alusel_i
	 ,input [`RegBus] reg1_i
	 ,input [`RegBus] reg2_i
	 ,input [`RegAddrBus] reg_w_addr_i
	 ,input reg_w_en_i
	 ,input HILO_w_en_i
	 ,input HILO_w_addr_i
	 ,input [`RegBus]HILO_w_data_i	 
	 ,output reg [`RegBus] reg_o
	 ,output reg [`RegAddrBus] reg_w_addr_o
	 ,output reg reg_w_en_o
	 ,output reg HILO_w_en_o 
	 ,output reg HILO_w_addr_o
);
reg [`RegBus] logicout;
reg [`RegBus] shiftout;
reg [`RegBus] arithmicout;
reg [`RegBus] moveout;
always @ (*)
begin
	if(rst_n==`RstEnable)
	begin
		HILO_w_en_o=1'b0;
		HILO_w_addr_o=1'b0;
	end
	else
	begin
		HILO_w_en_o=  HILO_w_en_i;
		HILO_w_addr_o=HILO_w_addr_i;
	end
end // always

always @ (*)
begin
	reg_w_addr_o=reg_w_addr_i;
	case(aluop_i)
	`EXE_MOVN_OP:
	begin
		reg_w_en_o=(reg2_i==`ZeroWord)?`WriteDisable:`WriteEnable;
		moveout=reg1_i;
	end
	`EXE_MOVZ_OP:
	begin
		reg_w_en_o=(reg2_i==`ZeroWord)?`WriteEnable:`WriteDisable;
		moveout=reg1_i;
	end
	`EXE_MTLO_OP,`EXE_MTHI_OP:
	begin
		reg_w_en_o=reg_w_en_i;	
		moveout=reg1_i;
	end
	`EXE_MFLO_OP,`EXE_MFHI_OP:
	begin
		reg_w_en_o=reg_w_en_i;	
		moveout=HILO_w_data_i;
	end
	default:
	begin
		reg_w_en_o=reg_w_en_i;	
		moveout=`ZeroWord;
	end
	endcase
end // always
always @ (*)
begin
	case (aluop_i)
		`EXE_ORI_OP,`EXE_OR_OP:
		begin
			logicout=reg1_i|reg2_i;
		end
		`EXE_ANDI_OP,`EXE_AND_OP:
		begin
			logicout=reg1_i&reg2_i;
		end
		`EXE_XORI_OP,`EXE_XOR_OP:
		begin
			logicout=reg1_i^reg2_i;
		end
		`EXE_NOR_OP:
		begin
			logicout=~(reg1_i|reg2_i);
		end
		default:
		begin
			logicout=0;
		end
	endcase
end // always
always @ (*)
begin
	case (aluop_i)
	`EXE_SLL_OP,`EXE_SLLV_OP:
	begin
		shiftout=reg2_i<<reg1_i[4:0];
	end
	`EXE_SRA_OP,`EXE_SRAV_OP:
	begin
		shiftout=({32{reg2_i[31]}}<<(6'd32-reg1_i[4:0]))|(reg2_i>>reg1_i[4:0]);		
	end
	`EXE_SRL_OP,`EXE_SRLV_OP:
	begin
		shiftout=reg2_i>>reg1_i[4:0];
	end
	default:
	begin
		shiftout=0;
	end
	endcase
end // always

always @ (*)
begin
	case(alusel_i)
		`EXE_RES_LOGIC:
		begin
			reg_o=logicout;
		end
		`EXE_RES_SHIFT:
		begin
			reg_o=shiftout;
		end
		`EXE_RES_MOVE:
		begin
			reg_o=moveout;
		end
		default:
		begin
			reg_o=0;
		end
	endcase
end // always


endmodule