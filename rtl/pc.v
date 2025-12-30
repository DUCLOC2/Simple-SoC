module pc (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_next,  // Next PC value (from Branch Mux or PC+4)
    output reg [31:0] pc        
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'b0; 
        else
            pc <= pc_next;  
    end
endmodule
