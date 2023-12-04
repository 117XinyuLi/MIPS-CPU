`timescale 1ns / 1ps


module sim_CPU();
    reg CLK;
    reg Rst;
    wire R_W;
    wire [31:0] pc, instr, ALU_result;
    wire zero,memtoreg,regwrite,branch,alusrc,regdst,jump;
    wire [2:0] alucontrol;
    wire [31:0] PC_branchM, imm_sl2, PC_plus4E, PC_plus4D;
    wire [1:0] forwardAE, forwardBE;
    wire [31:0] mem_wdata, mem_rdata;
    wire pc_src;

    initial 
    begin
        CLK = 1;
        forever #50 CLK = ~CLK;
        #2000 $stop(0);
    end
    initial
    begin
        Rst = 0;
        #0 Rst=1;
        #10 Rst=0;
    end
    mips CPU(
        .clk(CLK),
        .rst(Rst),
        .R_W(R_W),
        .pc(pc),
        .instr(instr),
        .ALU_result(ALU_result),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .zeroM(zero),
        .memtoreg(memtoreg),
        .regwrite(regwrite),
        .branch(branch),
        .alusrc(alusrc),
        .regdst(regdst),
        .jump(jump),
        .alucontrol(alucontrol),
        .PC_branchM(PC_branchM),
        .imm_sl2(imm_sl2),
        .PC_plus4E(PC_plus4E),
        .PC_plus4D(PC_plus4D),
        .forwardAE(forwardAE),
        .forwardBE(forwardBE),
        .pc_src(pc_src)
    );
endmodule
