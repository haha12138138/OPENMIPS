//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2014 leishangwen@163.com                       ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  openmips
// File:    openmips.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: OpenMIPS处理器的顶层文件
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module openmips(

	input	wire										clk,
	input wire										rst,
	
 
	input wire[`RegBus]           rom_data_i,
	output wire[`RegBus]           rom_addr_o,
	output wire                    rom_ce_o
	
);

	wire[`InstAddrBus] pc;
	wire[`InstAddrBus] id_pc_i;
	wire[`InstBus] id_inst_i;
	
	//连接译码阶段ID模块的输出与ID/EX模块的输入
	wire[`AluOpBus] id_aluop_o;
	wire[`AluSelBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	wire[`RegBus] id_HILO_data_o;
	wire          id_HILO_w_en;
	wire 		  id_HILO_w_addr;
	//连接ID/EX模块的输出与执行阶段EX模块的输入
	wire[`AluOpBus] ex_aluop_i;
	wire[`AluSelBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;
	wire ex_HILO_w_en_i;
	wire ex_HILO_w_addr_i;
	wire [`RegBus]ex_HILO_w_data_i;
	//连接执行阶段EX模块的输出与EX/MEM模块的输入
	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;
	wire ex_HILO_w_en_o;
	wire ex_HILO_w_addr_o;
	//连接EX/MEM模块的输出与访存阶段MEM模块的输入
	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;
	wire mem_HILO_w_en_i;
	wire mem_HILO_w_addr_i;
	//连接访存阶段MEM模块的输出与MEM/WB模块的输入
	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;
	wire mem_HILO_w_en_o;
	wire mem_HILO_w_addr_o;
	//连接MEM/WB模块的输出与回写阶段的输入	
	wire wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;
	wire wb_HILO_w_en_i;
	wire wb_HILO_w_addr_i;
	//连接译码阶段ID模块与通用寄存器Regfile模块
  wire reg1_read;
  wire reg2_read;
  wire[`RegBus] reg1_data;
  wire[`RegBus] reg2_data;
  wire[`RegAddrBus] reg1_addr;
  wire[`RegAddrBus] reg2_addr;
  wire[`RegBus]	HILO_data;
  wire          HILO_r_en;
  wire 			HILO_r_addr;
  //pc_reg例化
	pc_reg pc_reg0(
		.clk(clk),
		.rst_n(rst),
		.pc(pc),
		.ce(rom_ce_o)	
			
	);
	
  assign rom_addr_o = pc;

  //IF/ID模块例化
	if_id if_id0(
		.clk(clk),
		.rst(rst),
		.if_pc(pc),
		.if_inst(rom_data_i),
		.id_pc(id_pc_i),
		.id_inst(id_inst_i)      	
	);
	
	//译码阶段ID模块
	ID id0(
		.rst_n(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),

		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

		//送到regfile的信息
		.reg1_r_en(reg1_read),
		.reg2_r_en(reg2_read), 	  

		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr), 
	  	
	  	.mem_waddr(mem_wd_o),
	  	.mem_wdata(mem_wdata_o),
	  	.mem_we(mem_wreg_o),

	  	.ex_waddr(ex_wd_o),
	  	.ex_wdata(ex_wdata_o),
	  	.ex_we(ex_wreg_o),
		//送到ID/EX模块的信息
		.aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),
		.reg1_data_o(id_reg1_o),
		.reg2_data_o(id_reg2_o),
		.reg_w_addr(id_wd_o),
		.reg_w_en(id_wreg_o),

		.HILO_data_i(HILO_data),
		.HILO_w_data_o(id_HILO_data_o),
		.HILO_w_en_o(id_HILO_w_en),
		.HILO_w_addr_o(id_HILO_w_addr),
		.HILO_r_en_o(HILO_r_en),
		.HILO_r_addr_o(HILO_r_addr),
		.ex_HILO_we(ex_HILO_w_en_o),
		.ex_HILO_waddr(ex_HILO_w_addr_o),
		.ex_HILO_wdata(ex_wdata_o),

		.mem_HILO_we(mem_HILO_w_en_i),
		.mem_HILO_waddr(mem_HILO_w_addr_i),
		.mem_HILO_wdata(mem_wdata_i)
	);
	HILO HILO_regfile(
		.clk(clk),
		.rst_n(rst),
		.HILO_w_en_i(wb_HILO_w_en_i),
		.HILO_w_addr_i(wb_HILO_w_addr_i),
		.HILO_r_en_i(HILO_r_en),
		.HILO_r_addr_i(HILO_r_addr),
		.HILO_w_data(wb_wdata_i),
		.HILO_r_data(HILO_data)
		);
  //通用寄存器Regfile例化
	regfile regfile1(
		.clk (clk),
		.rst (rst),
		.we	(wb_wreg_i),
		.waddr (wb_wd_i),
		.wdata (wb_wdata_i),
		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),
		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data)
	);

	//ID/EX模块
	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		
		//从译码阶段ID模块传递的信息
		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_HILO_w_en(id_HILO_w_en),
		.id_HILO_w_addr(id_HILO_w_addr),
		.id_HILO_w_data(id_HILO_data_o),
		//传递到执行阶段EX模块的信息
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.ex_HILO_w_en(ex_HILO_w_en_i),
		.ex_HILO_w_addr(ex_HILO_w_addr_i),
		.ex_HILO_w_data(ex_HILO_w_data_i)
	);		
	//EX模块
	EX ex0(
		.rst_n(rst),
	
		//送到执行阶段EX模块的信息
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.reg_w_addr_i(ex_wd_i),
		.reg_w_en_i(ex_wreg_i),
	  
	  //EX模块的输出到EX/MEM模块信息
		.reg_w_addr_o(ex_wd_o),
		.reg_w_en_o(ex_wreg_o),
		.reg_o(ex_wdata_o),
		.HILO_w_en_i(ex_HILO_w_en_i),
		.HILO_w_addr_i(ex_HILO_w_addr_i),
		.HILO_w_data_i(ex_HILO_w_data_i),
		.HILO_w_en_o(ex_HILO_w_en_o),
		.HILO_w_addr_o(ex_HILO_w_addr_o)

	);

  //EX/MEM模块
  ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
	  
		//来自执行阶段EX模块的信息	
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
		.ex_HILO_w_en_i(ex_HILO_w_en_o),
		.ex_HILO_w_addr_i(ex_HILO_w_addr_o),

		//送到访存阶段MEM模块的信息
		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),
		.mem_HILO_w_en_o(mem_HILO_w_en_i),
		.mem_HILO_w_addr_o(mem_HILO_w_addr_i)
						       	
	);
	
  //MEM模块例化
	mem mem0(
		.rst(rst),
	
		//来自EX/MEM模块的信息	
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
	  	.HILO_w_en_i(mem_HILO_w_en_i),
	  	.HILO_w_addr_i(mem_HILO_w_addr_i),
		//送到MEM/WB模块的信息
		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),
		.HILO_w_en_o(mem_HILO_w_en_o),
		.HILO_w_addr_o(mem_HILO_w_addr_o)
	);

  //MEM/WB模块
	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),

		//来自访存阶段MEM模块的信息	
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),
		.mem_HILO_w_en_i(mem_HILO_w_en_o),
		.mem_HILO_w_addr_i(mem_HILO_w_addr_o),
		//送到回写阶段的信息
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i),
		.wb_HILO_w_en_o(wb_HILO_w_en_i),
	    .wb_HILO_w_addr_o(wb_HILO_w_addr_i)						       	
	);

endmodule