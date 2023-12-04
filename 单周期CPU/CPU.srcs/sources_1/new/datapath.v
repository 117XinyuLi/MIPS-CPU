`timescale 1ns / 1ps

module datapath(
        input wire clk, rst,
        output wire[31:0] instr,
        output wire[31:0] PC, ALU_result, mem_wdata, mem_rdata,
        input wire jump, regwrite, regdst, alusrc, branch, memtoreg,
        input wire [2:0] alucontrol
    );

    wire [31:0] PC_plus4, rd1, imm_extend, imm_sl2, PC_next;
    wire [31:0] wd3, write2reg, PC_branch, PC_next_jump, alu_src, rd2;
    wire zero, pcsrc;

    assign pcsrc = branch & zero;

    // mux for pc_next
    mux2 #(32) mux2_pc_next(
        .a(PC_branch),
        .b(PC_plus4),
        .s(pcsrc),
        .y(PC_next)
    );

    // mux for pc jump
    mux2 #(32) mux2_pc_jump(
        .a({PC_plus4[31:28], instr[25:0], 2'b00}),
        .b(PC_next),
        .s(jump),
        .y(PC_next_jump)
    );
    
    // PC
    pc pc1(
        .clk(clk),
        .rst(rst),
        .d(PC_next_jump),
        .q(PC)
    );

    // 指令存储器
    IMem IMem1(
        .Addr(PC/4),
        .RD(instr),
        .CLK(clk)
    );

    // PC + 4
    adder adder_plus_4(
        .a(PC),
        .b(32'd4),
        .y(PC_plus4)
    );

    // left shift 2
    sl2 sl2_1(
        .a(imm_extend),
        .y(imm_sl2)
    );

    // pc_branch
    adder adder_branch(
        .a(PC_plus4),
        .b(imm_sl2),
        .y(PC_branch)
    );

    // 有符号扩展
    signext signext1(
        .a(instr[15:0]),
        .y(imm_extend)
    );

    // mux for wd3
    mux2 #(32) mux2_wd3(
        .a(mem_rdata),
        .b(ALU_result),
        .s(memtoreg), // memtoreg
        .y(wd3)
    );

    // mux for wa3
    mux2 #(5) mux2_wa3(
        .a(instr[15:11]),
        .b(instr[20:16]),
        .s(regdst), // regdst
        .y(write2reg)
    );

    // 寄存器堆
    RegFile regfile1(
        .clk(clk),
	    .we3(regwrite), // regwrite
	    .ra1(instr[25:21]),
        .ra2(instr[20:16]),
        .wa3(write2reg),
	    .wd3(wd3),
	    .rd1(rd1),
        .rd2(rd2)
    );

    assign mem_wdata = rd2;

    // mux for alu src
    mux2 #(32) mux2_alu_src(
        .a(imm_extend),
        .b(rd2),
        .s(alusrc), // alusrc
        .y(alu_src)
    );

    // ALU
   ALU ALU1(
        .a(rd1),
        .b(alu_src),
        .op(alucontrol), // alucontrol
        .y(ALU_result),
        .zero(zero),
        .overflow()
    );
    
    // 数据存储器
    RAM RAM1(
        .WriteData(mem_wdata),
        .ReadData(mem_rdata),
        .Addr(ALU_result/4), 
        .R_W(R_W),
        .CLK(clk)
    );


endmodule
