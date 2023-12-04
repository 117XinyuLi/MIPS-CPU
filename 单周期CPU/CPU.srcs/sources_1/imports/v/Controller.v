`timescale 1ns / 1ps

module Controller(
    input [5:0] Op, Funct, // op = instruction[31:26], funct = instruction[5:0]
    input Zero,
    output MemToReg, MemWrite,
    output Branch, ALUSrc,
    output RegDst, RegWrite,
    output Jump,
    output [2:0] ALUControl);
    
    wire [1:0] ALUOp;
    // wire Branch;
    
    MainDec MainDec_1(Op, MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump, ALUOp);
    ALUDec ALUDec_1(Funct, ALUOp, ALUControl);
    // assign PCSrc = Branch & Zero;
endmodule
