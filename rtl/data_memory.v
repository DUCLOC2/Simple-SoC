module data_memory (
    input wire clk,
    input wire rst,
    input wire we,
    input wire [31:0] addr,
    input wire [31:0] wd,
    input wire [1:0] mem_size,
    output reg [31:0] rd
);
    reg [7:0] ram [0:63];  // Byte-addressable RAM (4KB)

    integer i;
    initial begin
        for (i = 0; i < 63; i = i + 1)
            ram[i] = 8'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 63; i = i + 1)
                ram[i] <= 8'b0;
        end
        else if (we) begin
            case (mem_size)
                2'b00: begin  // Word
                    ram[addr] <= wd[31:24];
                    ram[addr+1] <= wd[23:16];
                    ram[addr+2] <= wd[15:8];
                    ram[addr+3] <= wd[7:0];
                end
                2'b01: begin  // Half-word
                    ram[addr] <= wd[15:8];
                    ram[addr+1] <= wd[7:0];
                end
                2'b10: begin  // Byte
                    ram[addr] <= wd[7:0];
                end
                default: ;
            endcase
        end
    end

    always @(*) begin
        case (mem_size)
            2'b00: rd = {ram[addr], ram[addr+1], ram[addr+2], ram[addr+3]};
            2'b01: rd = {{16{1'b0}}, ram[addr], ram[addr+1]};
            2'b10: rd = {{24{1'b0}}, ram[addr]};
            default: rd = 32'b0;
        endcase
    end
endmodule