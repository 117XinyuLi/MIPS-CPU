`timescale 1ns / 1ps

module mips(
    input wire clk,rst,
    output wire R_W,
    output wire[31:0] pc,
    output wire[31:0] instr,
    output wire[31:0] ALU_result,
    output wire[31:0] mem_wdata,
    output wire[31:0] mem_rdata,
    output wire zeroM,memtoreg,regwrite,branch,alusrc,regdst,jump,
    output wire [2:0] alucontrol,
    output wire [31:0] PC_branchM,
    output wire [31:0] imm_sl2,
    output wire [31:0] PC_plus4E,
    output wire [31:0] PC_plus4D,
    output wire [1:0] forwardAE,
    output wire [1:0] forwardBE,
    output wire pc_src
);

// wire zero,memtoreg,regwrite,branch,alusrc,regdst,jump;
// wire [2:0] alucontrol;
wire zero, regwriteM, memtoregE, regwriteE;
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
    .ALUControl(alucontrol),
    .clk(clk),
    .reset(rst),
    .regwriteM(regwriteM),
    .memtoregE(memtoregE),
    .regwriteE(regwriteE)
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
    .alucontrol(alucontrol),
    .zero(zeroM),
    .PC_branchM(PC_branchM),
    .imm_sl2(imm_sl2),
    .PC_plus4E(PC_plus4E),
    .PC_plus4D(PC_plus4D),
    .regwriteM(regwriteM),
    .memtoregE(memtoregE),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE),
    .regwriteE(regwriteE),
    .pcsrc(pc_src)
);



endmodule
