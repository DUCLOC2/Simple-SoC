module mips_debug_tb;
    reg clk = 0;
    reg rst = 1;

    // ===== DEBUG SIGNALS =====
    wire [31:0] pc;
    wire [31:0] instr;

    wire [5:0]  opcode;
    wire [4:0]  rs, rt, rd;
    wire [15:0] imm;

    wire        mem_we;
    wire [31:0] mem_addr;
    wire [31:0] mem_wd;
    wire [31:0] mem_rd;

    // ===== DUT =====
    mips_debug_wrapper dut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instr(instr),

        .opcode(opcode),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .imm(imm),

        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wd(mem_wd),
        .mem_rd(mem_rd)
    );

    // ===== CLOCK =====
    always #5 clk = ~clk;

    // ===== TEST SEQUENCE =====
    initial begin
        // Load instruction memory
        $readmemh("program.hex", dut.im.rom);

        // Reset
        #10 rst = 0;

        // Header
        $display("Time  PC        Instr      op   rs rt rd imm    mem_we mem_addr mem_wd mem_rd");
        $monitor(
            "%4t  %08h  %08h  %02h   %02d %02d %02d %04h    %b      %08h %08h %08h",
            $time, pc, instr, opcode, rs, rt, rd, imm,
            mem_we, mem_addr, mem_wd, mem_rd
        );

        #1000 $finish;
    end
endmodule
