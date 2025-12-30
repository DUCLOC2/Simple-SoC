module bus_decoder (
    input wire [31:0] bAddr,
    output wire [5:0] bSel
);
    assign bSel[0] = (bAddr[15:14] == 2'b00);          // RAM
    assign bSel[1] = (bAddr[15:4] == 12'h7f0);         // GPIO
    assign bSel[2] = (bAddr[15:4] == 12'h7f1);         // PWM
    assign bSel[5:3] = 3'b000;                         // Unused
	 

	 
endmodule
