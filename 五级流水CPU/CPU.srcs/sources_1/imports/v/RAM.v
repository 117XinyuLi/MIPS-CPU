`timescale 1ns / 1ps


module RAM(WriteData, ReadData, Addr, R_W, CLK);
    parameter Addr_Width = 32;
    parameter Data_Width = 32;
    parameter SIZE = 2 ** Addr_Width;
    input [Data_Width-1:0] WriteData;
    output [Data_Width-1:0] ReadData;
    input [Addr_Width-1:0] Addr;
    input R_W, CLK;// R_W = 1: write, R_W = 0: read
    reg [Data_Width-1:0] Data_i;
    reg [Data_Width-1:0] RAM [SIZE-1:0];
    
    initial
    begin
        $readmemh("C:/Users/13151/Desktop/v/ram.txt",RAM);
    end
    
    always @(*)
    begin
        if(R_W == 1)
        begin
            RAM[Addr] <= WriteData;
        end
    end

    always @(*)
    begin
        if(R_W == 0)
        begin
            Data_i <= RAM[Addr];
        end
    end

endmodule
