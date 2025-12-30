module sign_extend (
    input wire [15:0] imm,       // 16-bit immediate
    output reg [31:0] ext_imm    // 32-bit sign-extended immediate
);
    always @(*) begin
        ext_imm = {{16{imm[15]}}, imm};  // Sign-extend 16-bit to 32-bit
    end
endmodule