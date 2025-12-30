module gpio (
    input wire clk, rst,
    input wire [31:0] bAddr, bWData,
    input wire bSel, bWrite,
    input wire [1:0] mem_size,
    output reg [31:0] bRData,
    output wire [15:0] gpioOutput,
    input wire [15:0] gpioInput
);
    wire gpioOutWe = bSel & bWrite & (bAddr[3:0] == 4'h4);
    wire [15:0] gpioOut; 

    register_we #(16) reg_out (
        .clk(clk),
        .rst(rst),
        .we(gpioOutWe),
        .d(bWData[15:0]),
        .q(gpioOut)
    );

    always @(*) begin
        case (bAddr[3:0])
            4'h0: begin  // Read gpioInput
                case (mem_size)
                    2'b00: bRData = {{16{1'b0}}, gpioInput};  // Word
                    2'b01: bRData = {{16{1'b0}}, gpioInput[15:8]};  // Half-word
                    2'b10: bRData = {{24{1'b0}}, gpioInput[7:0]};   // Byte
                    default: bRData = 32'b0;
                endcase
            end
            4'h4: begin  // Read gpioOut
                case (mem_size)
                    2'b00: bRData = {{16{1'b0}}, gpioOut};  // Word
                    2'b01: bRData = {{16{1'b0}}, gpioOut[15:8]};  // Half-word
                    2'b10: bRData = {{24{1'b0}}, gpioOut[7:0]};   // Byte
                    default: bRData = 32'b0;
                endcase
            end
            default: bRData = 32'b0;
        endcase
    end

    assign gpioOutput = gpioOut;	
endmodule