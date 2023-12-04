`timescale 1ns / 1ps


module top(
    input wire clk,
    input wire rst,
    output wire R_W,
    output wire[31:0] pc,
    output wire[31:0] instr,
    output wire[31:0] ALU_result,
    output wire[31:0] mem_wdata,
    input wire[31:0] mem_rdata,
    output wire zero,memtoreg,regwrite,branch,alusrc,regdst,jump,alucontrol
);

    // wire R_W;
    // wire [31:0] pc, instr, ALU_resultl, mem_wdata, mem_rdata;

    mips mips(
        .clk(clk),
        .rst(rst),
        .R_W(R_W),
        .pc(pc),
        .instr(instr),
        .ALU_result(ALU_result),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .zero(zero),
        .memtoreg(memtoreg),
        .regwrite(regwrite),
        .branch(branch),
        .alusrc(alusrc),
        .regdst(regdst),
        .jump(jump),
        .alucontrol(alucontrol)
    );



endmodule
