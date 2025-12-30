module soc_tb;
    reg clk, rst;
    reg [7:0] gpio_in;
    wire [7:0] gpio_out;
    wire pwm_out;

    soc soc_inst (
        .clk(clk),
        .rst(rst),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out),
        .pwm_out(pwm_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        gpio_in = 8'hFF;
        #10 rst = 0;
        #1000;
        $finish;
    end

    initial begin
        $monitor("Time=%0t rst=%b pc=%h instr=%h t0=%h t1=%h t2=%h ra=%h mem[0]=%h gpio_out=%h pwm_out=%b",
                 $time, rst, soc_inst.cpu.pc, soc_inst.cpu.instr,
                 soc_inst.cpu.rf.registers[8],
                 soc_inst.cpu.rf.registers[9],
                 soc_inst.cpu.rf.registers[10],
                 soc_inst.cpu.rf.registers[31],
                 soc_inst.dmem.ram[0],
                 gpio_out, pwm_out);
    end
endmodule