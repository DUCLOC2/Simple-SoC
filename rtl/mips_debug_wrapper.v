module mips_debug_wrapper(
    input  wire        clk,
    input  wire        rst,

    // ===== FETCH =====
    output wire [31:0] pc,
    output wire [31:0] instr,

    // ===== DECODE (tách từ instr) =====
    output wire [5:0]  opcode,
    output wire [4:0]  rs,
    output wire [4:0]  rt,
    output wire [4:0]  rd,
    output wire [15:0] imm,

    // ===== MEMORY INTERFACE =====
    output wire        mem_we,
    output wire [31:0] mem_addr,
    output wire [31:0] mem_wd,
    output wire [31:0] mem_rd
);

    wire [1:0] mem_size;

    // ================= CPU =================
    mips_cpu cpu (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .mem_rd(mem_rd),
        .pc(pc),
        .mem_addr(mem_addr),
        .mem_wd(mem_wd),
        .mem_we(mem_we),
        .mem_size(mem_size)
    );

    // ================= Instruction Memory =================
    instruction_memory im (
        .addr(pc),
        .instr(instr)
    );

    // ================= Data Memory =================
    data_memory dm (
        .clk(clk),
        .rst(rst),
        .we(mem_we),
        .addr(mem_addr),
        .wd(mem_wd),
        .mem_size(mem_size),
        .rd(mem_rd)
    );

    // ================= DECODE SIGNALS =================
    assign opcode = instr[31:26];
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign imm    = instr[15:0];

endmodule
