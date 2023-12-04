`timescale 1ns / 1ps


module sim_CPU();
    reg CLK;
    reg Rst;
    wire R_W;
    wire [31:0] pc, instr, ALU_result, mem_wdata, mem_rdata;
    wire zero,memtoreg,regwrite,branch,alusrc,regdst,jump;
    wire [2:0] alucontrol;

    initial 
    begin
        CLK = 0;#50
        forever #50 CLK = ~CLK;
        #2000 $stop(0);
    end
    initial
    begin
        Rst = 0;
        #50 Rst=1;
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
