module soc_top_tb;
    reg clk = 0, rst = 1;
    reg [15:0] gpioInput = 16'h1234;
    wire [15:0] gpioOutput;
    wire pwmOut;

    soc_top uut (
        .clk(clk),
        .rst(rst),
        .gpioInput(gpioInput),
        .gpioOutput(gpioOutput),
        .pwmOut(pwmOut)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        // Reset pulse
        #10 rst = 0;

        // Run for a while
        #500;

        // Check outputs
        $display("GPIO Output = %h", gpioOutput);
        $display("PWM Output = %b", pwmOut);

        $finish;
    end
	 always @(posedge clk) begin
    $display("PC: %h | Instruction: %h", uut.cpu.pc, uut.instr);
	end

endmodule
