module instruction_memory (
    input wire [31:0] addr,      // PC address
    output reg [31:0] instr      // Instruction output
);
    reg [31:0] rom [0:63];     

    initial begin
        $readmemh("program.hex", rom);  
    end

    // Read instruction from ROM
    always @(*) begin
        instr = rom[addr[11:2]]; 
    end
endmodule