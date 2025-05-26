
module MUX_1(
    input [31:0] data1,
    input [31:0] data2,
    input sel,
    output reg [31:0] out
);
    // 2-to-1 multiplexer
    // Select between data1 and data2 based on sel
    assign #1 out = (sel) ? data2 : data1;
    
endmodule

module MUX_2(
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [31:0] data4,
    input[1:0] sel,
    output reg [31:0] out
);
    // 4-to-1 multiplexer
    // Select between data1, data2, data3, and data4 based on sel
    always @(*) begin
        case (sel)
            2'b00: out = data1;
            2'b01: out = data2;
            2'b10: out = data3;
            2'b11: out = data4;
            default: out = 32'b0; // Default case to avoid latches
        endcase
    end
endmodule
