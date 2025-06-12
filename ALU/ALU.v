module alu (
    input [31:0] data1,
    input [31:0] data2,
    input [4:0] alu_control,
    output reg [31:0] result
);
    always @(*) begin
        case (alu_control)
            5'b00000: result = data1 + data2;                                // ADD
            5'b00001: result = data1 - data2;                                // SUB
            5'b00010: result = data1 | data2;                                // OR
            5'b00011: result = data1 ^ data2;                                // XOR
            5'b00100: result = data1 & data2;                                // AND
            5'b00101: result = data1 >> data2;                               // SRL
            5'b00110: result = data1 << data2;                               // SLL
            5'b00111: result = $signed(data1) >>> data2;                    // SRA
            5'b10000: result = (data1 < data2) ? 32'b1 : 32'b0;              // SLT
            5'b10001: result = data2;                                       // Forwarding
            default:   result = 32'b0;
        endcase
    end
endmodule