module soc_top (
    input wire clk,
    input wire rst,
    input wire [15:0] gpioInput,
    output wire [15:0] gpioOutput,
    output wire pwmOut
);
    // Wires
    wire [31:0] pc, instr, mem_rd;
    wire [31:0] mem_addr, mem_wd;
    wire mem_we;
    wire [1:0] mem_size;

    // Bus wires
    wire [5:0] bSel;
    wire [31:0] bRData;
    wire [31:0] ram_out, gpio_out, pwm_out;
    wire [1:0] mem_size_out;

    // MIPS CPU
    mips_cpu cpu (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .mem_rd(bRData),
        .pc(pc),
        .mem_addr(mem_addr),
        .mem_wd(mem_wd),
        .mem_we(mem_we),
        .mem_size(mem_size)
    );

    // Instruction Memory (ROM)
    instruction_memory im (
        .addr(pc),
        .instr(instr)
    );

    // Bus
    bus bus_inst (
        .clk(clk),
        .bAddr(mem_addr),
        .bWData(mem_wd),
        .bWrite(mem_we),
        .mem_size(mem_size),
        .bSel(bSel),
        .bRData(bRData),
        .mem_size_out(mem_size_out),
        .bRData0(ram_out),
        .bRData1(gpio_out),
        .bRData2(pwm_out)
    );

    // RAM (Data Memory)
    data_memory ram (
        .clk(clk),
        .rst(rst),
        .we(bSel[0] & mem_we),
        .addr(mem_addr),
        .wd(mem_wd),
        .mem_size(mem_size_out),
        .rd(ram_out)
    );

    // GPIO
    gpio gpio_inst (
        .clk(clk),
        .rst(rst),
        .bAddr(mem_addr),
        .bWData(mem_wd),
        .bSel(bSel[1]),
        .bWrite(mem_we),
        .mem_size(mem_size_out),
        .bRData(gpio_out),
        .gpioOutput(gpioOutput),
        .gpioInput(gpioInput)
    );

    // PWM
    pwm pwm_inst (
        .clk(clk),
        .rst(rst),
        .bWData(mem_wd),
        .bAddr(mem_addr),
        .bSel(bSel[2]),
        .bWrite(mem_we),
        .mem_size(mem_size_out),
        .bRData(pwm_out),
        .pwmOut(pwmOut)
    );
endmodule
