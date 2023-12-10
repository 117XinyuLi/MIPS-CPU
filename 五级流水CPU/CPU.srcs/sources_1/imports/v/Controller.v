`timescale 1ns / 1ps

module Controller(
    input [5:0] Op, Funct, // op = instruction[31:26], funct = instruction[5:0]
    input Zero,
    output MemToReg, MemWrite,
    output Branch, ALUSrc,
    output RegDst, RegWrite,
    output Jump,
    output [2:0] ALUControl,
    input clk, reset,
    output regwriteM,
    output memtoregE,
    output regwriteE
);
    
    wire [1:0] ALUOp;
    // wire [8:0] Controls;
    // wire Branch;
    
    wire [6:0] SigsD, SigsE;
    MainDec MainDec_1(Op, SigsD, ALUOp);

    wire [2:0] ALUControlD, ALUControlE;
    ALUDec ALUDec_1(Funct, ALUOp, ALUControlD);
    // assign PCSrc = Branch & Zero;

    assign Jump = SigsD[0];
    assign Branch = SigsD[3];
    floprc #(7) Floprc_1(clk, reset, 1'b0, SigsD, SigsE);
    floprc #(3) Floprc_2(clk, reset, 1'b0, ALUControlD, ALUControlE);
    
    // RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, Jump = SigsE;
    assign RegDst = SigsE[5];
    assign ALUSrc = SigsE[4];
    assign ALUControl = ALUControlE;
    assign memtoregE = SigsE[1];
    assign regwriteE = SigsE[6];

    wire [4:0] SigsM;
    floprc #(5) Floprc_3(clk, reset, 1'b0, {SigsE[6], SigsE[3:0]}, SigsM);
    // RegWrite, Branch, MemWrite, MemToReg, Jump = SigsM;
    assign MemWrite = SigsM[2];
    // assign Branch = SigsM[3];
    assign regwriteM = SigsM[4];

    wire [1:0] SigsW;
    floprc #(2) Floprc_4(clk, reset, 1'b0, {SigsM[4], SigsM[1]}, SigsW);
    // RegWrite, MemToReg = SigsM;
    assign RegWrite = SigsW[1];
    assign MemToReg = SigsW[0];


endmodule
