`timescale 1ns / 1ps

module branch_unit_tb;

    reg [2:0] funct3;
    reg [31:0] rs1_data, rs2_data;
    wire branch_taken;

    branch_unit uut (
        .funct3(funct3),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .branch_taken(branch_taken)
    );

    initial begin
        $display("Testing branch decision unit...");

        // BEQ (equal)
        funct3 = 3'b000; rs1_data = 32'd10; rs2_data = 32'd10; #10;
        $display("BEQ taken? %b (expected 1)", branch_taken);

        // BNE (not equal)
        funct3 = 3'b001; rs1_data = 32'd10; rs2_data = 32'd5; #10;
        $display("BNE taken? %b (expected 1)", branch_taken);

        // BLT
        funct3 = 3'b100; rs1_data = -5; rs2_data = 3; #10;
        $display("BLT taken? %b (expected 1)", branch_taken);

        // BGE
        funct3 = 3'b101; rs1_data = 10; rs2_data = 10; #10;
        $display("BGE taken? %b (expected 1)", branch_taken);

        // BLTU (unsigned)
        funct3 = 3'b110; rs1_data = 32'h00000002; rs2_data = 32'hFFFFFFF0; #10;
        $display("BLTU taken? %b (expected 1)", branch_taken);

        $finish;
    end
endmodule
