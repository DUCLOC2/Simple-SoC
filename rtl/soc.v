module soc (
    input wire clk,
    input wire rst,
    input wire [7:0] gpio_in,
    output wire [7:0] gpio_out,
    output wire pwm_out
);
    wire [31:0] pc, instr, dmem_addr, dmem_wdata, dmem_rdata;
    wire dmem_we, dmem_re;
    wire [1:0] dmem_size;
    wire [31:0] bus_rdata, gpio_addr, gpio_wdata, pwm_addr, pwm_wdata;
    wire gpio_we, pwm_we;
    wire [31:0] gpio_rdata, pwm_rdata;

    mips_cpu cpu (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instr(instr)
    );

    assign dmem_addr = cpu.alu_result;
    assign dmem_wdata = cpu.rd2;
    assign dmem_we = cpu.mem_write;
    assign dmem_re = cpu.mem_read;
    assign dmem_size = cpu.mem_size;
    assign cpu.rd = (dmem_addr[31:16] == 16'h0000) ? dmem_rdata : bus_rdata;

    data_memory dmem (
        .clk(clk),
        .rst(rst),
        .we(dmem_we && (dmem_addr[31:16] == 16'h0000)),
        .addr(dmem_addr),
        .wd(dmem_wdata),
        .mem_size(dmem_size),
        .rd(dmem_rdata)
    );

    simple_bus bus (
        .clk(clk),
        .rst(rst),
        .addr(dmem_addr),
        .wdata(dmem_wdata),
        .we(dmem_we && (dmem_addr[31:16] != 16'h0000)),
        .re(dmem_re),
        .rdata(bus_rdata),
        .gpio_addr(gpio_addr),
        .gpio_wdata(gpio_wdata),
        .gpio_we(gpio_we),
        .gpio_rdata(gpio_rdata),
        .pwm_addr(pwm_addr),
        .pwm_wdata(pwm_wdata),
        .pwm_we(pwm_we),
        .pwm_rdata(pwm_rdata)
    );

    gpio gpio_inst (
        .clk(clk),
        .rst(rst),
        .addr(gpio_addr),
        .wdata(gpio_wdata),
        .we(gpio_we),
        .rdata(gpio_rdata),
        .gpio_out(gpio_out),
        .gpio_in(gpio_in)
    );

    pwm pwm_inst (
        .clk(clk),
        .rst(rst),
        .addr(pwm_addr),
        .wdata(pwm_wdata),
        .we(pwm_we),
        .rdata(pwm_rdata),
        .pwm_out(pwm_out)
    );
endmodule