module branch_unit (
    input wire [31:0] pc,
    input wire [31:0] ext_imm,
    input wire [25:0] target,
    input wire [31:0] rd1,
    input wire [31:0] rd2,
    input wire branch,
    input wire jump,
    input wire jal,
    input wire jr,
    input wire [5:0] opcode,
    output reg [31:0] pc_next
);
    wire [31:0] pc_plus_4;
    wire [31:0] pc_branch;
    wire [31:0] jump_addr;
    wire branch_cond;

    assign pc_plus_4 = pc + 4;
    assign pc_branch = pc_plus_4 + (ext_imm << 2);
    assign jump_addr = {pc[31:28], target, 2'b00};
    assign branch_cond = (opcode == 6'b000100 && rd1 == rd2) || (opcode == 6'b000101 && rd1 != rd2);

    always @(*) begin
        if (jr)
            pc_next = rd1;
        else if (jump || jal)
            pc_next = jump_addr;
        else if (branch && branch_cond)
            pc_next = pc_branch;
        else
            pc_next = pc_plus_4;
    end
endmodule