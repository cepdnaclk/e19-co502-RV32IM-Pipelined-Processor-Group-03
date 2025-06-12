module pc (
    input         clk,
    input         reset,
    input         pc_write,          // Control signal to allow PC update
    input  [31:0] next_pc,           // Next PC (e.g., PC+4 or branch target)
    output reg [31:0] pc_out         // Current PC
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'h00000000;  // Start at address 0
        end else if (pc_write) begin
            pc_out <= next_pc;
        end
    end
endmodule
