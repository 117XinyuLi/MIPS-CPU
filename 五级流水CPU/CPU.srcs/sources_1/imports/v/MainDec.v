`timescale 1ns / 1ps


module MainDec(
    input [5:0] Op,
    // output MemToReg, MemWrite,
    // output Branch, ALUSrc,
    // output RegDst, RegWrite,
    // output Jump,
    output reg[6:0] Sigs,
    output reg[1:0] ALUOp
);
    
    reg [8:0] Controls;
    
    // assign {RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = Controls;
    always@(*)
        case(Op)
            6'b000000: //Controls <= 9'b110000010;//register-type
                begin
                    Sigs[6:0] <= 7'b1100000;
                    ALUOp <= 2'b10;
                end
            6'b100011: //Controls <= 9'b101001000;//LW
                begin
                    Sigs[6:0] <= 7'b1010010;
                    ALUOp <= 2'b00;
                end
            6'b101011: //Controls <= 9'b001010000;//SW
                begin
                    Sigs[6:0] <= 7'b0010100;
                    ALUOp <= 2'b00;
                end
            6'b000100: //Controls <= 9'b000100001;//BEQ
                begin
                    Sigs[6:0] <= 7'b0001000;
                    ALUOp <= 2'b01;
                end
            6'b001000: //Controls <= 9'b101000000;//ADDI
                begin
                    Sigs[6:0] <= 7'b1010000;
                    ALUOp <= 2'b00;
                end
            6'b001101: //Controls <= 9'b101000000;//ORI
                begin
                    Sigs[6:0] <= 7'b1010000;
                    ALUOp <= 2'b00;
                end
            6'b001111: //Controls <= 9'b101000000;//LUI
                begin
                    Sigs[6:0] <= 7'b1010000;
                    ALUOp <= 2'b00;
                end
            6'b000010: //Controls <= 9'b000000100;//J
                begin
                    Sigs[6:0] <= 7'b0000001;
                    ALUOp <= 2'b00;
                end
            default:   //Controls <= 9'bxxxxxxxxx;//illegal Op
                begin
                    Sigs[6:0] <= 7'bxxxxxxx;
                    ALUOp <= 2'bxx;
                end
        endcase 
endmodule
