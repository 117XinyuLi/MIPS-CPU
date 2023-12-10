`timescale 1ns / 1ps


`define DATA_WIDTH 32
module IMem(
    input [`DATA_WIDTH-1:0] Addr,
    output [`DATA_WIDTH-1:0] RD, 
    input CLK);
    
    parameter IMEM_SIZE = 64; 
    reg [`DATA_WIDTH-1:0] RAM [IMEM_SIZE-1:0];
    initial begin
        $readmemh("C:/Users/13151/Desktop/v/mips1.txt",RAM);
    end
    
    assign RD = RAM[Addr];

endmodule
