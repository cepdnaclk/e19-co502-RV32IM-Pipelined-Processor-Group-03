
// alu_m_extension_tb.v
`timescale 1ns/1ps

module alu_m_extension_tb;
  reg [31:0] data1, data2;
  reg [4:0] alu_control;
  wire [31:0] result;

  alu_m_extension uut (
    .data1(data1),
    .data2(data2),
    .alu_control(alu_control),
    .result(result)
  );

  initial begin
    $display("---- ALU M EXTENSION TEST ----");

    // MUL (signed * signed, lower 32)
    data1 = -32'sd7; data2 = 32'sd3; alu_control = 5'b01000;
    #10 $display("MUL: %0d * %0d (low) = %0d", data1, data2, result);

    // MULH (signed * signed, upper 32)
    alu_control = 5'b01001;
    #10 $display("MULH: %0d * %0d (high) = %0d", data1, data2, result);

    // MULHU (unsigned * unsigned, upper 32)
    data1 = 32'd4000000000; data2 = 32'd2; alu_control = 5'b01010;
    #10 $display("MULHU: %0d * %0d (high) = %0d", data1, data2, result);

    // MULHSU (signed * unsigned, upper 32)
    data1 = -32'sd9; data2 = 32'd5; alu_control = 5'b01011;
    #10 $display("MULHSU: %0d * %0d (high) = %0d", data1, data2, result);

    $finish;
  end
endmodule
