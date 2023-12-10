`timescale 1ns / 1ps

module ALU(
	input wire[31:0] a,b,
	input wire[2:0] op,
	output reg[31:0] y,
	output reg overflow,
	output wire zero
    );

	wire[31:0] s,bout;
	assign bout = op[2] ? ~b : b;
	assign s = a + bout + op[2];
	
	always @(*) begin
		case (op)
			3'b000: y <= a & b;
			3'b001: y <= a | b;
			3'b010: y <= s;
			3'b110: y <= a - b;
			3'b111: y <=  (a < b) ? 32'b1 : 32'b0;
			default : y <= 32'b0;
		endcase	
	end
	assign zero = (y == 32'b0) ? 1'b1 : 1'b0;

	always @(*) begin
		case (op[2:1])
			2'b01:overflow <= a[31] & b[31] & ~s[31] |
							~a[31] & ~b[31] & s[31];
			2'b11:overflow <= ~a[31] & b[31] & s[31] |
							a[31] & ~b[31] & ~s[31];
			default : overflow <= 1'b0;
		endcase	
	end

endmodule
