module simple_bus (
    input wire clk,
    input wire rst,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    input wire we,
    input wire re,
    output reg [31:0] rdata,
    output reg [31:0] gpio_addr,
    output reg [31:0] gpio_wdata,
    output reg gpio_we,
    input wire [31:0] gpio_rdata,
    output reg [31:0] pwm_addr,
    output reg [31:0] pwm_wdata,
    output reg pwm_we,
    input wire [31:0] pwm_rdata
);
    always @(*) begin
        if (addr[31:16] == 16'h1000) begin
            gpio_addr = addr;
            gpio_wdata = wdata;
            gpio_we = we;
            rdata = gpio_rdata;
            pwm_addr = 0;
            pwm_wdata = 0;
            pwm_we = 0;
        end
        else if (addr[31:16] == 16'h2000) begin
            pwm_addr = addr;
            pwm_wdata = wdata;
            pwm_we = we;
            rdata = pwm_rdata;
            gpio_addr = 0;
            gpio_wdata = 0;
            gpio_we = 0;
        end
        else begin
            gpio_addr = 0;
            gpio_wdata = 0;
            gpio_we = 0;
            pwm_addr = 0;
            pwm_wdata = 0;
            pwm_we = 0;
            rdata = 0;
        end
    end
endmodule