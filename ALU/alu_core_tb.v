// alu_core_tb.v
`timescale 1ns/1ps

module alu_core_tb;
  reg [31:0] data1, data2;
  reg [4:0] alu_control;
  wire [31:0] result;

  alu_core uut (
    .data1(data1),
    .data2(data2),
    .alu_control(alu_control),
    .result(result)
  );

  initial begin
    $display("---- ALU CORE TEST ----");

    // ADD
    data1 = 32'd10; data2 = 32'd5; alu_control = 5'b00000;
    #10 $display("ADD: %0d + %0d = %0d", data1, data2, result);

    // SUB
    data1 = 32'd10; data2 = 32'd5; alu_control = 5'b00001;
    #10 $display("SUB: %0d - %0d = %0d", data1, data2, result);

    // OR
    data1 = 32'h0F0F; data2 = 32'h00FF; alu_control = 5'b00010;
    #10 $display("OR: %h | %h = %h", data1, data2, result);

    // AND
    data1 = 32'h0F0F; data2 = 32'h00FF; alu_control = 5'b00100;
    #10 $display("AND: %h & %h = %h", data1, data2, result);

    // SLT
    data1 = 32'd5; data2 = 32'd10; alu_control = 5'b10000;
    #10 $display("SLT: %0d < %0d = %0d", data1, data2, result);

    $finish;
  end
endmodule

