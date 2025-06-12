`timescale 1ns / 1ps

module tb_alu_control_unit;

    reg [1:0] alu_op;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [3:0] alu_control;

    alu_control_unit uut (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );

    initial begin
        $display("Time | alu_op funct3 funct7    | alu_control");
        $display("-------------------------------------------");

        // R-type: add
        alu_op  = 2'b10;
        funct3  = 3'b000;
        funct7  = 7'b0000000;
        #10 $display("%4t |  %b    %b    %b |     %b", $time, alu_op, funct3, funct7, alu_control);

        // R-type: sub
        funct7  = 7'b0100000;
        #10 $display("%4t |  %b    %b    %b |     %b", $time, alu_op, funct3, funct7, alu_control);

        // R-type: and
        funct3  = 3'b111;
        funct7  = 7'b0000000;
        #10 $display("%4t |  %b    %b    %b |     %b", $time, alu_op, funct3, funct7, alu_control);

        // I-type: addi
        alu_op  = 2'b11;
        funct3  = 3'b000;
        #10 $display("%4t |  %b    %b    %b |     %b", $time, alu_op, funct3, funct7, alu_control);

        // I-type: andi
        funct3  = 3'b111;
        #10 $display("%4t |  %b    %b    %b |     %b", $time, alu_op, funct3, funct7, alu_control);

        // Branch (beq)
        alu_op  = 2'b01;
        #10 $display("%4t |  %b    %b    %b |     %b", $time, alu_op, funct3, funct7, alu_control);

        // Load/Store (default to add)
        alu_op  = 2'b00;
        #10 $display("%4t |  %b    %b    %b |     %b", $time, alu_op, funct3, funct7, alu_control);

        $finish;
    end

endmodule
