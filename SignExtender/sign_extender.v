module SignExtender (
    input  [31:7] instrBits,
    input  [2:0] IMM_SEL,
    output reg [31:0] imm_out
);

    always @(*) begin
        case (IMM_SEL)
            3'b000: begin // I-type: imm[11:0] = instr[31:20]
                imm_out = {{20{instrBits[31]}}, instrBits[31:20]};
            end

            3'b001: begin // S-type: imm[11:5] = instr[31:25], imm[4:0] = instr[11:7]
                imm_out = {{20{instrBits[31]}}, instrBits[31:25], instrBits[11:7]};
            end

            3'b010: begin // B-type: imm[12] = instr[31], imm[10:5] = instr[30:25], imm[4:1] = instr[11:8], imm[11] = instr[7], LSB = 0
                imm_out = {{19{instrBits[31]}}, instrBits[31], instrBits[7], instrBits[30:25], instrBits[11:8], 1'b0};
            end

            3'b011: begin // U-type: imm[31:12] = instr[31:12], LSBs are 0
                imm_out = {instrBits[31:12], 12'b0};
            end

            3'b100: begin // J-type: imm[20] = instr[31], imm[10:1] = instr[30:21], imm[11] = instr[20], imm[19:12] = instr[19:12], LSB = 0
                imm_out = {{11{instrBits[31]}}, instrBits[31], instrBits[19:12], instrBits[20], instrBits[30:21], 1'b0};
            end

            default: imm_out = 32'b0; // For safety
        endcase
    end

endmodule
