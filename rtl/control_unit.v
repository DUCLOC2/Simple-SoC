module control_unit (
    input wire condZero,        // Zero flag from ALU
    input wire Branch,          // Branch signal
    input wire [5:0] opcode,    // Opcode from instruction
    input wire [5:0] funct,     // Funct field for R-type
    output reg [1:0] regDst,    // Register destination: 00=rt, 01=rd, 10=$ra
    output reg regWrite,        // Register write enable
    output reg ALUSrc,          // ALU source: 0=register, 1=immediate
    output reg [3:0] ALUOp,     // ALU operation code
    output reg [1:0] PCSrc,     // PC source: 00=PC+4, 01=jump/jal, 10=jr
    output reg memWrite,        // Memory write enable
    output reg [1:0] memToReg,  // Memory to register: 00=ALU, 01=mem, 10=PC+4
    output reg [1:0] mem_size   // Memory access size: 00=word, 01=half-word, 10=byte
);
    always @(*) begin
        // Default values
        regDst = 2'b00;
        regWrite = 1'b0;
        ALUSrc = 1'b0;
        ALUOp = 4'b0000;
        PCSrc = 2'b00;
        memWrite = 1'b0;
        memToReg = 2'b00;
        mem_size = 2'b00;

        case (opcode)
            6'b000000: begin  // R-Type
                regDst = 2'b01;  // rd
                regWrite = (funct != 6'b001000);  // No write for jr
                ALUSrc = 1'b0;
                memWrite = 1'b0;
                memToReg = 2'b00;  // ALU result
                case (funct)
                    6'b100001: ALUOp = 4'b0101;  // addu: add
                    6'b100011: ALUOp = 4'b0110;  // subu: subtract
                    6'b100100: ALUOp = 4'b0001;  // and
                    6'b100101: ALUOp = 4'b0011;  // or
                    6'b100110: ALUOp = 4'b0010;  // xor
                    6'b101011: ALUOp = 4'b1000;  // sltu: compare
                    6'b000000: ALUOp = 4'b1010;  // sll: shift left
                    6'b000010: ALUOp = 4'b1011;  // srl: shift right
						  6'b100000: ALUOp = 4'b0101;  // add
						  6'b100010: ALUOp = 4'b0110;  // sub
						  6'b101010: ALUOp = 4'b1001;  // slt
                    6'b001000: begin  // jr
                        ALUOp = 4'b0110;  // Not used
                        PCSrc = 2'b10;    // PC = rs
                    end
                    default: ALUOp = 4'b0000;
                endcase
            end
            6'b001001: begin  // addiu
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b0101;  // add
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
				6'b001000: begin  // addi
					 regDst = 2'b00;  // rt
					 regWrite = 1'b1;
					 ALUSrc = 1'b1;
					 ALUOp = 4'b0101;  // add
					 PCSrc = 2'b00;
					 memWrite = 1'b0;
					 memToReg = 2'b00;
					 mem_size = 2'b00;
				end
            6'b001100: begin  // andi
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b0001;  // and
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
            6'b001101: begin  // ori
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b0011;  // or
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
            6'b001011: begin  // sltiu
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b1000;  // compare
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
            6'b001111: begin  // lui
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b1100;  // lui
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
            6'b000100: begin  // beq
                regDst = 2'b00;
                regWrite = 1'b0;
                ALUSrc = 1'b0;
                ALUOp = 4'b0110;  // subtract
                PCSrc = (Branch && condZero) ? 2'b00 : 2'b00;  // Handled in branch_unit
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
            6'b000101: begin  // bne
                regDst = 2'b00;
                regWrite = 1'b0;
                ALUSrc = 1'b0;
                ALUOp = 4'b0110;  // subtract
                PCSrc = (Branch && !condZero) ? 2'b00 : 2'b00;  // Handled in branch_unit
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
            6'b100011: begin  // lw
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b0101;  // add
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b01;  // memory data
                mem_size = 2'b00;  // word
            end
            6'b100100: begin  // lbu
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b0101;  // add
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b01;  // memory data
                mem_size = 2'b10;  // byte
            end
            6'b100101: begin  // lhu
                regDst = 2'b00;  // rt
                regWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 4'b0101;  // add
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b01;  // memory data
                mem_size = 2'b01;  // half-word
            end
            6'b101011: begin  // sw
                regDst = 2'b00;
                regWrite = 1'b0;
                ALUSrc = 1'b1;
                ALUOp = 4'b0101;  // add
                PCSrc = 2'b00;
                memWrite = 1'b1;
                memToReg = 2'b00;
                mem_size = 2'b00;  // word
            end
            6'b101000: begin  // sb
                regDst = 2'b00;
                regWrite = 1'b0;
                ALUSrc = 1'b1;
                ALUOp = 4'b0101;  // add
                PCSrc = 2'b00;
                memWrite = 1'b1;
                memToReg = 2'b00;
                mem_size = 2'b10;  // byte
            end
            6'b101001: begin  // sh
                regDst = 2'b00;
                regWrite = 1'b0;
                ALUSrc = 1'b1;
                ALUOp = 4'b0101;  // add
                PCSrc = 2'b00;
                memWrite = 1'b1;
                memToReg = 2'b00;
                mem_size = 2'b01;  // half-word
            end
            6'b000010: begin  // j
                regDst = 2'b00;
                regWrite = 1'b0;
                ALUSrc = 1'b0;
                ALUOp = 4'b0110;  // Not used
                PCSrc = 2'b01;    // jump
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
            6'b000011: begin  // jal
                regDst = 2'b10;  // $ra
                regWrite = 1'b1;
                ALUSrc = 1'b0;
                ALUOp = 4'b0110;  // Not used
                PCSrc = 2'b01;    // jump
                memWrite = 1'b0;
                memToReg = 2'b10;  // PC+4
                mem_size = 2'b00;
            end

				6'b001010: begin  // slti
					 regDst = 2'b00;  // rt
					 regWrite = 1'b1;
					 ALUSrc = 1'b1;
					 ALUOp = 4'b1001;  // slt
					 PCSrc = 2'b00;
					 memWrite = 1'b0;
					 memToReg = 2'b00;
					 mem_size = 2'b00;
				end

            default: begin
                regDst = 2'b00;
                regWrite = 1'b0;
                ALUSrc = 1'b0;
                ALUOp = 4'b0000;
                PCSrc = 2'b00;
                memWrite = 1'b0;
                memToReg = 2'b00;
                mem_size = 2'b00;
            end
        endcase
    end
endmodule