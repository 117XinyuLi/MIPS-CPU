`timescale 1ns / 1ps

module RegFile(
	input wire clk,
	input wire we3,// 写使能
	input wire[4:0] ra1,ra2,wa3,
	input wire[31:0] wd3,
	output wire[31:0] rd1,rd2
    );

	reg [31:0] rf[63:0];
	integer i;
	initial begin
		for(i=0;i<64;i=i+1) begin
			rf[i] = 32'b0;
		end
	end

	always @(*) begin
		if(we3) begin
			 rf[wa3] <= wd3;
		end
	end

	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
	assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

