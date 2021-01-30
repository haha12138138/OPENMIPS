`timescale 1ns / 1ps
`include "defines.v"
module ID (
	 input rst_n
	,input [`RegBus] pc_i
	,input [`InstBus] inst_i

	/*Regfile*/
	/*GPR*/
	,input [`RegBus] reg1_data_i
	,output reg [`RegAddrBus] reg1_addr_o
	,output reg [`RegBus] reg1_data_o
	,output reg reg1_r_en 

	,input [`RegBus] reg2_data_i
	,output reg [`RegAddrBus] reg2_addr_o
	,output reg [`RegBus] reg2_data_o
	,output reg reg2_r_en 
	/*HILO*/
	,input [`RegBus] HILO_data_i

	,output reg  HILO_r_en_o
	,output reg  HILO_r_addr_o
	
	/*MEM*/
	,input [`RegAddrBus] mem_waddr
	,input [`RegBus] mem_wdata
	,input mem_we

	,input mem_HILO_we
	,input mem_HILO_waddr
	,input [`RegBus] mem_HILO_wdata
	/*EX*/
	/*FROM*/
	,input [`RegAddrBus] ex_waddr
	,input [`RegBus] ex_wdata
	,input ex_we
	,input ex_HILO_we
	,input ex_HILO_waddr
	,input [`RegBus] ex_HILO_wdata
	/*To*/
	,output reg reg_w_en
	,output reg[`RegAddrBus] reg_w_addr
	,output reg [`AluOpBus]aluop_o
	,output reg [`AluSelBus]alusel_o
	,output reg  [`RegBus] HILO_w_data_o
	,output reg  HILO_w_en_o
	,output reg  HILO_w_addr_o
);
wire[5:0] op=inst_i[31:26];
wire[4:0] op2=inst_i[10:6];
wire[5:0] op3=inst_i[5:0];
wire[5:0] op4=inst_i[20:16];

reg [`RegBus]imm;
always @ (*)
begin
	if(~rst_n)
	begin
		//reg1_data_o=0;
		reg1_addr_o=`NOPRegAddr;
		reg1_r_en=1'b0;
		//reg2_data_o=0;
		reg2_addr_o=`NOPRegAddr;
		reg2_r_en=1'b0;
		reg_w_en=1'b0;
		reg_w_addr=`NOPRegAddr;
		aluop_o=`EXE_NOP_OP;
		alusel_o=`EXE_RES_NOP;
		imm=0;
		HILO_r_en_o=1'b0;
		HILO_r_addr_o=1'b0;
		HILO_w_data_o=`ZeroWord;
		HILO_w_en_o=1'b0;
		HILO_w_addr_o=1'b0;
	end
	else
	begin
			//reg1_data_o=0;
			reg1_addr_o=inst_i[25:21];
			//2_data_o=0;
			reg2_addr_o=inst_i[20:16];
			HILO_r_en_o=1'b0;
			HILO_r_addr_o=1'b0;
			HILO_w_data_o=`ZeroWord;
			HILO_w_en_o=1'b0;
			HILO_w_addr_o=1'b0;

			case(op)
			`EXE_SPECIAL_INST:
			begin
				case(op2)
				5'b0:
				begin
					case(op3)
					`EXE_OR:
					begin
						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_OR_OP;
						alusel_o=`EXE_RES_LOGIC;
					end
					`EXE_AND:
					begin
						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_AND_OP;
						alusel_o=`EXE_RES_LOGIC;
					end
					`EXE_XOR:
					begin
						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_XOR_OP;
						alusel_o=`EXE_RES_LOGIC;
					end
					`EXE_NOR:
					begin
						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_NOR_OP;
						alusel_o=`EXE_RES_LOGIC;
					end
					`EXE_SLLV:
					begin
						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_SLLV_OP;
						alusel_o=`EXE_RES_SHIFT;
					end
					`EXE_SRLV:
					begin
						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_SRLV_OP;
						alusel_o=`EXE_RES_SHIFT;
					end
					`EXE_SRAV:
					begin
						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_SRAV_OP;
						alusel_o=`EXE_RES_SHIFT;
					end
					`EXE_SYNC:
					begin
						reg1_r_en=1'b0;
						reg2_r_en=1'b0;
						imm=`ZeroWord;
						reg_w_en=1'b0;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_NOP_OP;
						alusel_o=`EXE_RES_NOP;
					end
					`EXE_MFHI:
					begin
						HILO_r_en_o=1'b1;
						HILO_r_addr_o=1'b1;
						HILO_w_data_o=HILO_data_i;
						HILO_w_en_o=1'b0;
						HILO_w_addr_o=1'b0;

						reg1_r_en=1'b0;
						reg2_r_en=1'b0;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_MFHI_OP;//doesn't matter
						alusel_o=`EXE_RES_MOVE;
					end
					`EXE_MFLO:
					begin
						HILO_r_en_o=1'b1;
						HILO_r_addr_o=1'b0;
						HILO_w_data_o=HILO_data_i;
						HILO_w_en_o=1'b0;
						HILO_w_addr_o=1'b0;

						reg1_r_en=1'b0;
						reg2_r_en=1'b0;
						imm=`ZeroWord;
						reg_w_en=1'b1;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_MFLO_OP;//doesn't matter
						alusel_o=`EXE_RES_MOVE;
					end
					`EXE_MTHI:
					begin
						HILO_r_en_o=1'b0;
						HILO_r_addr_o=1'b0;
						HILO_w_data_o=`ZeroWord;
						HILO_w_en_o=1'b1;
						HILO_w_addr_o=1'b1;

						reg1_r_en=1'b1;
						reg2_r_en=1'b0;
						imm=`ZeroWord;
						reg_w_en=1'b0;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_MTHI_OP;//doesn't matter
						alusel_o=`EXE_RES_MOVE;
					end
					`EXE_MTLO:
					begin
						HILO_r_en_o=1'b0;
						HILO_r_addr_o=1'b0;
						HILO_w_data_o=`ZeroWord;
						HILO_w_en_o=1'b1;
						HILO_w_addr_o=1'b0;

						reg1_r_en=1'b1;
						reg2_r_en=1'b0;
						imm=`ZeroWord;
						reg_w_en=1'b0;
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_MTLO_OP;//doesn't matter
						alusel_o=`EXE_RES_MOVE;
					end
					`EXE_MOVN:
					begin
						HILO_r_en_o=1'b0;
						HILO_r_addr_o=1'b0;
						HILO_w_data_o=`ZeroWord;
						HILO_w_en_o=1'b0;
						HILO_w_addr_o=1'b1;

						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b0;//it doesn't matter
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_MOVN_OP;
						alusel_o=`EXE_RES_MOVE;
					end
					`EXE_MOVZ:
					begin
						HILO_r_en_o=1'b0;
						HILO_r_addr_o=1'b0;
						HILO_w_data_o=`ZeroWord;
						HILO_w_en_o=1'b0;
						HILO_w_addr_o=1'b0;

						reg1_r_en=1'b1;
						reg2_r_en=1'b1;
						imm=`ZeroWord;
						reg_w_en=1'b0;//it doesn't matter
						reg_w_addr=inst_i[15:11];
						aluop_o=`EXE_MOVZ_OP;
						alusel_o=`EXE_RES_MOVE;
					end
					default://invalid inst
					begin
						reg1_addr_o=`NOPRegAddr;
						reg1_r_en=1'b0;
						//reg2_data_o=0;
						reg2_addr_o=`NOPRegAddr;
						reg2_r_en=1'b0;
						reg_w_en=1'b0;
						reg_w_addr=`NOPRegAddr;
						aluop_o=`EXE_NOP_OP;
						alusel_o=`EXE_RES_NOP;
						imm=0;
					end
					endcase
				end
				default://invalid inst
				begin
					reg1_addr_o=`NOPRegAddr;
					reg1_r_en=1'b0;
					//reg2_data_o=0;
					reg2_addr_o=`NOPRegAddr;
					reg2_r_en=1'b0;
					reg_w_en=1'b0;
					reg_w_addr=`NOPRegAddr;
					aluop_o=`EXE_NOP_OP;
					alusel_o=`EXE_RES_NOP;
					imm=0;
				end
				endcase
			end
			`EXE_ORI:
			begin
				reg1_r_en=1'b1;
				reg2_r_en=1'b0;
				imm={16'b0,inst_i[15:0]};
				reg_w_en=1'b1;
				reg_w_addr=inst_i[20:16];
				aluop_o=`EXE_ORI_OP;
				alusel_o=`EXE_RES_LOGIC;
			end
			`EXE_ANDI:
			begin
				reg1_r_en=1'b1;
				reg2_r_en=1'b0;
				imm={16'b0,inst_i[15:0]};
				reg_w_en=1'b1;
				reg_w_addr=inst_i[20:16];
				aluop_o=`EXE_ANDI_OP;
				alusel_o=`EXE_RES_LOGIC;
			end
			`EXE_XORI:
			begin
				reg1_r_en=1'b1;
				reg2_r_en=1'b0;
				imm={16'b0,inst_i[15:0]};
				reg_w_en=1'b1;
				reg_w_addr=inst_i[20:16];
				aluop_o=`EXE_XORI_OP;
				alusel_o=`EXE_RES_LOGIC;
			end
			`EXE_LUI:
			begin
				reg1_r_en=1'b1;
				reg2_r_en=1'b0;
				imm={inst_i[15:0],16'b0};
				reg_w_en=1'b1;
				reg_w_addr=inst_i[20:16];
				aluop_o=`EXE_OR_OP;
				alusel_o=`EXE_RES_LOGIC;
			end
			`EXE_PREF:
			begin
				reg1_r_en=1'b0;
				reg2_r_en=1'b0;
				imm={16'b0,inst_i[15:0]};
				reg_w_en=1'b0;
				reg_w_addr=inst_i[20:16];
				aluop_o=`EXE_NOP_OP;
				alusel_o=`EXE_RES_NOP;
			end
			default:
			begin
				//reg1_data_o=0;
				reg1_addr_o=`NOPRegAddr;
				reg1_r_en=1'b0;
				//reg2_data_o=0;
				reg2_addr_o=`NOPRegAddr;
				reg2_r_en=1'b0;
				reg_w_en=1'b0;
				reg_w_addr=`NOPRegAddr;
				aluop_o=`EXE_NOP_OP;
				alusel_o=`EXE_RES_NOP;
				imm=0;
			end
			endcase
		if(inst_i[31:21]==11'b0)
		begin
			// reg1_addr_o=inst_i[25:21];
			// //2_data_o=0;
			// reg2_addr_o=inst_i[20:16];
			// HILO_r_en_o=1'b0;
			// HILO_r_addr_o=1'b0;
			// HILO_w_data_o=`ZeroWord;
			// HILO_w_en_o=1'b0;
			// HILO_w_addr_o=1'b0;
			case(op3)
			`EXE_SLL:
			begin
				reg1_r_en=1'b0;
				reg2_r_en=1'b1;
				imm[4:0]=inst_i[10:6];
				reg_w_en=1'b1;
				reg_w_addr=inst_i[15:11];
				aluop_o=`EXE_SLL_OP;
				alusel_o=`EXE_RES_SHIFT;
			end
			`EXE_SRL:
			begin
				reg1_r_en=1'b0;
				reg2_r_en=1'b1;
				imm[4:0]=inst_i[10:6];
				reg_w_en=1'b1;
				reg_w_addr=inst_i[15:11];
				aluop_o=`EXE_SRL_OP;
				alusel_o=`EXE_RES_SHIFT;
			end
			`EXE_SRA:
			begin
				reg1_r_en=1'b0;
				reg2_r_en=1'b1;
				imm[4:0]=inst_i[10:6];
				reg_w_en=1'b1;
				reg_w_addr=inst_i[15:11];
				aluop_o=`EXE_SRA_OP;
				alusel_o=`EXE_RES_SHIFT;
			end
			endcase
		end
	end
end // always
always @ (*)
begin
	if(rst_n==`RstEnable)
	begin
		HILO_w_data_o=0;
	end
	else
	begin
		if((HILO_r_en_o&ex_HILO_we)&(HILO_r_addr_o==ex_HILO_waddr))
		begin
			HILO_w_data_o=ex_HILO_wdata;
		end
		else if((HILO_r_en_o&mem_HILO_we)&(HILO_r_addr_o==mem_HILO_waddr))
		begin
			HILO_w_data_o=mem_HILO_wdata;
		end
		else
		begin
			HILO_w_data_o=HILO_data_i;
		end
	end
end // always

always @ (*)
begin
	if(~rst_n)
	begin
		reg1_data_o=0;
	end
	else
	begin
		if((reg1_r_en&ex_we)&(reg1_addr_o==ex_waddr))
		begin
			reg1_data_o=ex_wdata;
		end
		else if((reg1_r_en&mem_we)&(reg1_addr_o==mem_waddr))
		begin
			reg1_data_o=mem_wdata;
		end
		else
		begin
			reg1_data_o=(reg1_r_en)?reg1_data_i:imm;
		end
		
	end
end // always

always @ (*)
begin
	if(~rst_n)
	begin
		reg2_data_o=0;
	end
	else
	begin
		if((reg2_r_en&ex_we)&(reg2_addr_o==ex_waddr))
		begin
			reg2_data_o=ex_wdata;
		end
		else if((reg2_r_en&mem_we)&(reg2_addr_o==mem_waddr))
		begin
			reg2_data_o=mem_wdata;
		end
		else
		begin
			reg2_data_o=(reg2_r_en)?reg2_data_i:imm;
		end
	end
end // always

endmodule     	