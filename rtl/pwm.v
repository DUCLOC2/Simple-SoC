module pwm (
    input wire clk, rst,
    input wire [31:0] bWData, bAddr,
    input wire bSel, bWrite,
    input wire [1:0] mem_size,
    output reg [31:0] bRData,
    output wire pwmOut
);
    wire [7:0] comp, count, countNext;
    wire enable;
    assign countNext = count + 1;
    assign pwmOut = enable & (count < comp);

    wire compWe = bSel & bWrite & (bAddr[3:0] == 4'h0) & (mem_size == 2'b10);  // Byte write
    wire enableWe = bSel & bWrite & (bAddr[3:0] == 4'h4) & (mem_size == 2'b10); // Byte write

    register_we #(8) r_Compare (.clk(clk), .rst(rst), .we(compWe), .d(bWData[7:0]), .q(comp));
    register_we #(8) r_Counter (.clk(clk), .rst(rst), .we(1'b1), .d(countNext), .q(count));
    register_we #(1) r_Enable (.clk(clk), .rst(rst), .we(enableWe), .d(bWData[0]), .q(enable));

    always @(*) begin
        case (bAddr[3:0])
            4'h0: bRData = {{24{1'b0}}, comp};     // Read compare
            4'h4: bRData = {{31{1'b0}}, enable};   // Read enable
            default: bRData = 32'b0;
        endcase
    end
endmodule