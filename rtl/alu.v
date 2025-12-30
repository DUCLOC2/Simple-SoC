module alu (
    input wire [31:0] a,         // Operand 1
    input wire [31:0] b,         // Operand 2
    input wire [4:0] shamt,      // Shift amount for sll, srl
    input wire [3:0] alu_ctrl,   // ALU control signal
    output reg [31:0] result,    // ALU result
    output reg zero              // Zero flag
);
    always @(*) begin
        case (alu_ctrl)
            4'b0101: result = a + b;        // ADD (addu, addiu, lw, sw, lbu, lhu, sb, sh)
            4'b0110: result = a - b;        // SUB (subu, beq, bne)
            4'b0001: result = a & b;        // AND (and, andi)
            4'b0011: result = a | b;        // OR (or, ori)
            4'b0010: result = a ^ b;        // XOR (xor)
            4'b1000: result = ($unsigned(a) < $unsigned(b)) ? 1 : 0;  // SLTU (sltu, sltiu)
				4'b1001: result = ($signed(a) < $signed(b)) ? 1 : 0;  // slt
            4'b1010: result = b << shamt;   // SLL (sll)
            4'b1011: result = b >> shamt;   // SRL (srl)
            4'b1100: result = b << 16;      // LUI (lui)
            default: result = 32'b0;
        endcase
        zero = (result == 32'b0);
    end
endmodule