// Multiplication Extension for RISC-V M Extension (MUL, MULH, MULHSU, MULHU)
module alu_m_extension (
    input [31:0] data1,
    input [31:0] data2,
    input [4:0] alu_control,
    output reg [31:0] result
);

    // 64-bit multiplication results
    wire [63:0] mul_signed;         // For MUL and MULH
    wire [63:0] mul_signed_unsigned; // For MULHSU
    wire [63:0] mul_unsigned;       // For MULHU

    assign mul_signed          = $signed(data1) * $signed(data2);
    assign mul_signed_unsigned = $signed(data1) * $unsigned(data2);
    assign mul_unsigned        = $unsigned(data1) * $unsigned(data2);

    always @(*) begin
        case (alu_control)
            5'b01000: result = mul_signed[31:0];          // MUL: lower 32 bits of signed * signed
            5'b01001: result = mul_signed[63:32];         // MULH: upper 32 bits of signed * signed
            5'b01010: result = mul_unsigned[63:32];       // MULHU: upper 32 bits of unsigned * unsigned
            5'b01011: result = mul_signed_unsigned[63:32];// MULHSU: upper 32 bits of signed * unsigned
            default:  result = 32'b0;
        endcase
    end

endmodule