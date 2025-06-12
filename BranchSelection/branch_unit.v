module branch_unit (
    input  [2:0]  funct3,           // From instruction (e.g., BEQ, BNE)
    input  [31:0] rs1_data,         // First operand
    input  [31:0] rs2_data,         // Second operand
    output        branch_taken      // 1 if branch should be taken
);

    reg result;

    always @(*) begin
        case (funct3)
            3'b000: result = (rs1_data == rs2_data);  // BEQ
            3'b001: result = (rs1_data != rs2_data);  // BNE
            3'b100: result = ($signed(rs1_data) < $signed(rs2_data)); // BLT
            3'b101: result = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
            3'b110: result = (rs1_data < rs2_data);   // BLTU
            3'b111: result = (rs1_data >= rs2_data);  // BGEU
            default: result = 0;
        endcase
    end

    assign branch_taken = result;

endmodule
