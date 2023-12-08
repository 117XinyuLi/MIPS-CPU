`timescale 1ns / 1ps

module datapath(
        input wire clk, rst,
        output wire[31:0] instr,
        output wire[31:0] PC, ALU_result, mem_wdata, mem_rdata,
        input wire jump, regwrite, regdst, alusrc, branch, memtoreg,
        input wire [2:0] alucontrol,
        output wire zero,
        output wire [31:0] PC_branchM,
        output wire [31:0] imm_sl2, PC_plus4E,
        output wire [31:0] PC_plus4D,
        input wire regwriteM, memtoregE,
        output wire[1:0] forwardAE, forwardBE,
        input wire regwriteE,
        output wire pcsrc
    );

    wire [31:0] PC_plus4, rd1D, imm_extend, PC_next;
    wire [31:0] wd3, write2reg, PC_branch, PC_next_jump, alu_src, rd2D;
    // wire pcsrc;

    wire [31:0] instrD, rd1E, rd2E, imm_extendE;
    wire [4:0] rsD, rtD, rdD, rsE, rtE, rdE, rtM, rdM, rtW, rdW;
    wire [31:0] ALU_resultM, ALU_resultW, mem_rdataW;
    wire zeroM;
    wire [31:0]WriteDataM;

    wire [4:0]write2regE, write2regM, write2regW;

    // wire [1:0] forwardAE, forwardBE;
    wire [31:0] rd1, rd2;

    wire stallF, stallD, flushE;

    wire forwardAD, forwardBD, flushD;

    wire [31:0] eq1, eq2;
    wire eqout;

    assign pcsrc = branch & eqout;
    // assign mem_wdata = rd2;

    // mux for pc_next
    mux2 #(32) mux2_pc_next(
        .a(PC_branchM),
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
        .q(PC),
        .en(~stallF)
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

    // F-D
    flopenrc #(32) r1(.clk(clk),.rst(rst),.en(~stallD),.clear(1'b0),.d(instr),.q(instrD));
    flopenrc #(32) r2(.clk(clk),.rst(rst),.en(~stallD),.clear(1'b0),.d(PC_plus4),.q(PC_plus4D));

    // 有符号扩展
    signext signext1(
        .a(instrD[15:0]),
        .y(imm_extend)
    );

    mux2 #(32) forwardaux(rd1D, ALU_resultM, forwardAD, eq1);
    mux2 #(32) forwardbux(rd2D, ALU_resultM, forwardBD, eq2);
    eqcmp eqcmp1(eq1, eq2, eqout);

    assign rtD = instrD[20:16];
    assign rdD = instrD[15:11];
    assign rsD = instrD[25:21];


    // 寄存器堆
    RegFile regfile1(
        .clk(clk),
	    .we3(regwrite), // regwrite
	    .ra1(instrD[25:21]),
        .ra2(instrD[20:16]),
        .wa3(write2regW),
	    .wd3(wd3),
	    .rd1(rd1D),
        .rd2(rd2D)
    );

    // D-E
    flopenrc #(32) r3(.clk(clk),.rst(rst),.en(~flushE),.clear(1'b0),.d(rd1D),.q(rd1E));
    flopenrc #(32) r4(.clk(clk),.rst(rst),.en(~flushE),.clear(1'b0),.d(rd2D),.q(rd2E));
    flopenrc #(5) r5(.clk(clk),.rst(rst),.en(~flushE),.clear(1'b0),.d(rtD),.q(rtE));
    flopenrc #(5) r6(.clk(clk),.rst(rst),.en(~flushE),.clear(1'b0),.d(rdD),.q(rdE));
    flopenrc #(32) r7(.clk(clk),.rst(rst),.en(~flushE),.clear(1'b0),.d(PC_plus4D),.q(PC_plus4E));
    flopenrc #(32) r8(.clk(clk),.rst(rst),.en(~flushE),.clear(1'b0),.d(imm_extend),.q(imm_extendE));
    flopenrc #(5) r19(.clk(clk),.rst(rst),.en(~flushE),.clear(1'b0),.d(rsD),.q(rsE));


    mux3 #(32) srcA_sel(rd1E, wd3, ALU_resultM, forwardAE, rd1);
    mux3 #(32) srcB_sel(rd2E, wd3, ALU_resultM, forwardBE, rd2);


    // mux for alu src
    mux2 #(32) mux2_alu_src(
        .a(imm_extendE),
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

    // left shift 2
    sl2 sl2_1(
        .a(imm_extendE),
        .y(imm_sl2)
    );

    // mux for wa3
    mux2 #(5) mux2_wa3(
        .a(rtE),
        .b(rdE),
        .s(regdst), // regdst
        .y(write2regE)
    );

    // pc_branch
    adder adder_branch(
        .a(PC_plus4E),
        .b(imm_sl2),
        .y(PC_branch)
    );

    // E-M
    floprc #(32) r9(.clk(clk),.rst(rst),.clear(1'b0),.d(ALU_result),.q(ALU_resultM));
    floprc #(1) r10(.clk(clk),.rst(rst),.clear(1'b0),.d(zero),.q(zeroM));
    floprc #(32) r11(.clk(clk),.rst(rst),.clear(1'b0),.d(rd2E),.q(WriteDataM));
    floprc #(32) r12(.clk(clk),.rst(rst),.clear(1'b0),.d(PC_branch),.q(PC_branchM));
    floprc #(5) r20(.clk(clk),.rst(rst),.clear(1'b0),.d(write2regE),.q(write2regM));
    
    // 数据存储器
    RAM RAM1(
        .WriteData(WriteDataM),
        .ReadData(mem_rdata),
        .Addr(ALU_resultM/4),
        .R_W(R_W),
        .CLK(clk)
    );

    // M-W
    floprc #(32) r13(.clk(clk),.rst(rst),.clear(1'b0),.d(ALU_resultM),.q(ALU_resultW));
    floprc #(32) r14(.clk(clk),.rst(rst),.clear(1'b0),.d(mem_rdata),.q(mem_rdataW));
    floprc #(5) r15(.clk(clk),.rst(rst),.clear(1'b0),.d(write2regM),.q(write2regW));
    

    // mux for wd3
    mux2 #(32) mux2_wd3(
        .a(mem_rdataW),
        .b(ALU_resultW),
        .s(memtoreg), // memtoreg
        .y(wd3)
    );

    // hazard detection
    hazard h(
        .rsE(rsE),
        .rtE(rtE),
        .writeregM(write2regM),
        .writeregW(write2regW),
        .regwriteM(regwriteM),
        .regwriteW(regwrite),
        .forwardAE(forwardAE),
        .forwardBE(forwardBE),

        .rsD(rsD),
        .rtD(rtD),
        .memtoregE(memtoregE),
        .stallF(stallF),
        .stallD(stallD),
        .flushE(flushE),

        .forwardAD(forwardAD),
        .forwardBD(forwardBD),
        .branchD(branch),
        .regWriteE(regwriteE),
        .writeregE(write2regE)
    );

endmodule
