module alu_control_unit (
    input [1:0] alu_op,               // Comes from main control unit
    input [6:0] funct7,               // Instruction[31:25]
    input [2:0] funct3,               // Instruction[14:12]
    output reg [4:0] alu_control      // Output to ALU and M-extension
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 5'b00000; // Load/Store -> ADD
            2'b01: begin                   // Branch
                case (funct3)
                    3'b000: alu_control = 5'b00001; // BEQ -> SUB
                    3'b001: alu_control = 5'b00001; // BNE -> SUB
                    3'b100: alu_control = 5'b10000; // BLT -> SLT
                    3'b101: alu_control = 5'b10000; // BGE -> SLT
                    default: alu_control = 5'b00000;
                endcase
            end
            2'b10: begin                   // R-type or I-type
                case ({funct7, funct3})
                    10'b0000000_000: alu_control = 5'b00000; // ADD
                    10'b0100000_000: alu_control = 5'b00001; // SUB
                    10'b0000000_111: alu_control = 5'b00100; // AND
                    10'b0000000_110: alu_control = 5'b00010; // OR
                    10'b0000000_100: alu_control = 5'b00011; // XOR
                    10'b0000000_001: alu_control = 5'b00110; // SLL
                    10'b0000000_101: alu_control = 5'b00101; // SRL
                    10'b0100000_101: alu_control = 5'b00111; // SRA
                    10'b0000000_010: alu_control = 5'b10000; // SLT
                    10'b0000000_011: alu_control = 5'b10000; // SLTU
                    // M-extension
                    10'b0000001_000: alu_control = 5'b01000; // MUL
                    10'b0000001_001: alu_control = 5'b01001; // MULH
                    10'b0000001_010: alu_control = 5'b01010; // MULHU
                    10'b0000001_011: alu_control = 5'b01011; // MULHSU
                    10'b0000001_100: alu_control = 5'b01100; // DIV
                    10'b0000001_101: alu_control = 5'b01101; // DIVU
                    10'b0000001_110: alu_control = 5'b01110; // REM
                    10'b0000001_111: alu_control = 5'b01111; // REMU
                    default: alu_control = 5'b00000;
                endcase
            end
            default: alu_control = 5'b00000;
        endcase
    end
endmodule
