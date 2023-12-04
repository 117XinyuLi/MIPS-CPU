`timescale 1ns / 1ps

module mips(
    input wire clk,rst,
    output wire R_W,
    output wire[31:0] pc,
    output wire[31:0] instr,
    output wire[31:0] ALU_result,
    output wire[31:0] mem_wdata,
    output wire[31:0] mem_rdata,
    output wire zero,memtoreg,regwrite,branch,alusrc,regdst,jump,
    output wire [2:0] alucontrol
);

// wire zero,memtoreg,regwrite,branch,alusrc,regdst,jump;
// wire [2:0] alucontrol;

Controller controller(
    .Op(instr[31:26]), // instruction[31:26]
    .Funct(instr[5:0]), // instruction[5:0]
    .Zero(zero),
    .MemToReg(memtoreg),
    .MemWrite(R_W),
    .Branch(branch),
    .ALUSrc(alusrc),
    .RegDst(regdst),
    .RegWrite(regwrite),
    .Jump(jump),
    .ALUControl(alucontrol)
);

datapath datapath(
    .clk(clk),
    .rst(rst),
    .instr(instr),
    .mem_rdata(mem_rdata),
    .PC(pc),
    .ALU_result(ALU_result),
    .mem_wdata(mem_wdata),
    .jump(jump),
    .regwrite(regwrite),
    .regdst(regdst),
    .alusrc(alusrc),
    .branch(branch),
    .memtoreg(memtoreg),
    .alucontrol(alucontrol)
);



endmodule
