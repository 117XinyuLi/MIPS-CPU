`timescale 1ns / 1ps


module MainDec(
    input [5:0] Op,
    output MemToReg, MemWrite,
    output Branch, ALUSrc,
    output RegDst, RegWrite,
    output Jump,
    output [1:0] ALUOp);
    
    reg [8:0] Controls;
    
    assign {RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = Controls;
    always@(*)
        case(Op)
            6'b000000: Controls <= 9'b110000010;//register-type
            6'b100011: Controls <= 9'b101001000;//LW
            6'b101011: Controls <= 9'b001010000;//SW
            6'b000100: Controls <= 9'b000100001;//BEQ
            6'b001000: Controls <= 9'b101000000;//ADDI
            6'b001101: Controls <= 9'b101000000;//ORI
            6'b001111: Controls <= 9'b101000000;//LUI
            6'b000010: Controls <= 9'b000000100;//J
            default:   Controls <= 9'bxxxxxxxxx;//illegal Op
        endcase 
endmodule
