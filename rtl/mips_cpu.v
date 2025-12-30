module mips_cpu (
    input wire clk,
    input wire rst,
    input wire [31:0] instr,        // Instruction from instruction memory
    input wire [31:0] mem_rd,       // Data read from data memory
    output wire [31:0] pc,          // Program counter
    output wire [31:0] mem_addr,    // Address for data memory
    output wire [31:0] mem_wd,      // Data to write to data memory
    output wire mem_we,             // Data memory write enable
    output wire [1:0] mem_size      // Data memory access size (word, half-word, byte)
);
    // Internal signals
    wire [31:0] pc_next;            // Next PC value
    wire [31:0] rd1, rd2;           // Register file read data
    wire [31:0] alu_result;         // ALU result
    wire [31:0] ext_imm;            // Sign-extended immediate
    wire [4:0] wa;                  // Register write address
    wire [31:0] wd;                 // Register write data
    wire zero;                      // ALU zero flag
    wire [1:0] regDst, PCSrc, memToReg;
    wire regWrite, ALUSrc, memWrite, branch;
    wire [3:0] ALUOp;
    wire [31:0] alu_b;              // ALU operand B

    // Program Counter
    reg [31:0] pc_reg;
    assign pc = pc_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_reg <= 32'b0;
        else
            pc_reg <= pc_next;
    end

    // Instruction fields
    wire [5:0] opcode = instr[31:26];
    wire [4:0] rs = instr[25:21];
    wire [4:0] rt = instr[20:16];
    wire [4:0] rd = instr[15:11];
    wire [4:0] shamt = instr[10:6];
    wire [5:0] funct = instr[5:0];
    wire [15:0] imm = instr[15:0];
    wire [25:0] target = instr[25:0];

    // Control Unit
    control_unit cu (
        .condZero(zero),
        .Branch(branch),
        .opcode(opcode),
        .funct(funct),
        .regDst(regDst),
        .regWrite(regWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .PCSrc(PCSrc),
        .memWrite(mem_we),
        .memToReg(memToReg),
        .mem_size(mem_size)
    );

    // Register File
    register_file rf (
        .clk(clk),
        .rst(rst),
        .we(regWrite),
        .ra1(rs),
        .ra2(rt),
        .wa((regDst == 2'b10) ? 5'd31 : (regDst == 2'b01 ? rd : rt)),  // $ra, rd, or rt
        .wd((memToReg == 2'b10) ? (pc + 4) : (memToReg == 2'b01 ? mem_rd : alu_result)),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Sign Extend
    sign_extend se (
        .imm(imm),
        .ext_imm(ext_imm)
    );

    // ALU
    assign alu_b = ALUSrc ? ext_imm : rd2;
    alu alu_inst (
        .a(rd1),
        .b(alu_b),
        .shamt(shamt),
        .alu_ctrl(ALUOp),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory Interface
    assign mem_addr = alu_result;
    assign mem_wd = rd2;

    // Branch Unit
    wire [31:0] pc_plus_4 = pc + 4;
    wire [31:0] pc_branch = pc_plus_4 + (ext_imm << 2);
    wire [31:0] jump_addr = {pc[31:28], target, 2'b00};
    wire branch_cond = (opcode == 6'b000100 && rd1 == rd2) || (opcode == 6'b000101 && rd1 != rd2);

    assign branch = (opcode == 6'b000100 || opcode == 6'b000101);  // beq, bne
    assign pc_next = (PCSrc == 2'b00) ? (branch_cond ? pc_branch : pc_plus_4) :
                     (PCSrc == 2'b01) ? jump_addr :
                     (PCSrc == 2'b10) ? rd1 : pc_plus_4;
endmodule