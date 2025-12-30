module mips_cpu_tb;
    reg clk = 0;
    reg rst = 1;
    wire [31:0] pc, mem_addr, mem_wd;
    wire [31:0] instr, mem_rd;
    wire mem_we;
    wire [1:0] mem_size;

    mips_cpu cpu (.clk(clk), .rst(rst), .instr(instr), .mem_rd(mem_rd),
                  .pc(pc), .mem_addr(mem_addr), .mem_wd(mem_wd),
                  .mem_we(mem_we), .mem_size(mem_size));
    instruction_memory im (.addr(pc), .instr(instr));
    data_memory dm (.clk(clk), .rst(rst), .we(mem_we), .addr(mem_addr),
                   .wd(mem_wd), .mem_size(mem_size), .rd(mem_rd));

    always #5 clk = ~clk;
    initial begin
        $readmemh("program.hex", im.rom);
        #10 rst = 0;
        #1000 $finish;
    end
endmodule