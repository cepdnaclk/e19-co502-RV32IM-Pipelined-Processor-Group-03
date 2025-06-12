module alu_m_extension (
    input [31:0] data1,
    input [31:0] data2,
    input [4:0] alu_control,
    output reg [31:0] result
);
    wire [63:0] mul_signed, mul_unsigned, mul_signed_unsigned;

    assign mul_signed         = $signed(data1) * $signed(data2);
    assign mul_unsigned       = $unsigned(data1) * $unsigned(data2);
    assign mul_signed_unsigned = $signed(data1) * $unsigned(data2);

    always @(*) begin
        case (alu_control)
            5'b01000: result = data1 * data2;                                // MUL
            5'b01001: result = mul_signed[63:32];                            // MULH
            5'b01010: result = mul_unsigned[63:32];                          // MULHU
            5'b01011: result = mul_signed_unsigned[63:32];                  // MULHSU
            5'b01100: result = $signed(data1) / $signed(data2);             // DIV
            5'b01101: result = $unsigned(data1) / $unsigned(data2);         // DIVU
            5'b01110: result = $signed(data1) % $signed(data2);             // REM
            5'b01111: result = $unsigned(data1) % $unsigned(data2);         // REMU
            default:   result = 32'b0;
        endcase
    end
endmodule