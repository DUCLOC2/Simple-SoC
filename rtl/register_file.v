module register_file (
    input wire clk,
    input wire rst,
    input wire we,               // Write enable
    input wire [4:0] ra1,        // Read address 1
    input wire [4:0] ra2,        // Read address 2
    input wire [4:0] wa,         // Write address
    input wire [31:0] wd,        // Write data
    output reg [31:0] rd1,       // Read data 1
    output reg [31:0] rd2        // Read data 2
);
    reg [31:0] registers [0:31];  // 32 registers, each 32-bit

    // Initialize registers
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Write operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (we && wa != 5'b0)  // Write if we=1 and not $zero
            registers[wa] <= wd;
    end

    // Read operation
    always @(*) begin
        rd1 = (ra1 == 5'b0) ? 32'b0 : registers[ra1];  // $zero is always 0
        rd2 = (ra2 == 5'b0) ? 32'b0 : registers[ra2];
    end
endmodule