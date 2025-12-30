module bus (
    input wire clk,
    input wire [31:0] bAddr,
    input wire [31:0] bWData,
    input wire bWrite,
    input wire [1:0] mem_size,
    output wire [5:0] bSel,
    output wire [31:0] bRData,
    output wire [1:0] mem_size_out,
    input wire [31:0] bRData0, bRData1, bRData2
);
    wire [5:0] bSel_wire;

    bus_decoder decoder (
        .bAddr(bAddr),
        .bSel(bSel_wire)
    );

    bus_mux mux (
        .bSel(bSel_wire),
        .in0(bRData0),
        .in1(bRData1),
        .in2(bRData2),
        .in3(32'b0),
        .in4(32'b0),
        .in5(32'b0),
        .out(bRData)
    );

    assign bSel = bSel_wire;
    assign mem_size_out = mem_size;
endmodule