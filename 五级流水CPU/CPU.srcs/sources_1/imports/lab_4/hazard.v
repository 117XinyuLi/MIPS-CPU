`timescale 1ns / 1ps

module hazard(
	input wire[4:0] rsE, rtE, writeregM, writeregW,
	input wire regwriteM, regwriteW,
	output wire[1:0] forwardAE, forwardBE,

	input wire[4:0] rsD, rtD,
	input wire memtoregE,
	output wire stallF, stallD, flushE,

	output forwardAD, forwardBD,
	input wire branchD, regWriteE, 
	input wire [4:0]writeregE
);

	// 前推：需要的寄存器号和写回的寄存器号对比，( rsE != 5'b0 ) 0号寄存器不用，
	// ( rsE == writeregM ) 读取的寄存器号和写回的寄存器号相同，regwriteM 写回使能
	assign forwardAE = (( rsE != 5'b0 ) & ( rsE == writeregM ) & regwriteM) ? 2'b10 :
						(( rsE != 5'b0 ) & ( rsE == writeregW ) & regwriteW) ? 2'b01 : 2'b00;

	assign forwardBE = (( rtE != 5'b0 ) & ( rtE == writeregM ) & regwriteM) ? 2'b10 :
						(( rtE != 5'b0 ) & ( rtE == writeregW ) & regwriteW) ? 2'b01 : 2'b00;

	assign forwardAD = (rsD != 5'b0) & (rsD == writeregM) & regwriteM;
	assign forwardBD = (rtD != 5'b0) & (rtD == writeregM) & regwriteM;

	// 暂停
	wire lwstall;
	wire branch_stall;
	assign branch_stall = branchD & regWriteE & ((writeregE == rsD) | (writeregE == rtD)) |
							branchD & regWriteE & ((writeregM == rsD) & (writeregM == rtD)); 
	assign lwstall = ((rsD == rtE) | (rtD == rtE)) & memtoregE;
	assign stallF = lwstall | branch_stall;
	assign stallD = lwstall | branch_stall;
	assign flushE = lwstall | branch_stall;


endmodule
