`timescale 1ns / 1ps

module imm_generator_tb;

    reg [31:0] instr;
    wire [31:0] imm_out;

    imm_gen uut (
        .instr(instr),
        .imm_out(imm_out)
    );

    initial begin
        $display("Immediate Generator Test:");

        // ADDI x1, x2, -12 => opcode 0010011
        instr = 32'b111111111100_00010_000_00001_0010011; #10;
        $display("I-type imm: %h (expected FFFFFF FFF4)", imm_out);

        // SW x3, 20(x4) => opcode 0100011
        instr = 32'b0000001_00011_00100_010_00100_0100011; #10;
        $display("S-type imm: %h (expected 00000014)", imm_out);

        // BEQ x1, x2, -8 => opcode 1100011
        instr = 32'b1111111_00010_00001_000_11100_1100011; #10;
        $display("B-type imm: %h", imm_out);

        // LUI x5, 0x12345000 => opcode 0110111
        instr = 32'b00010010001101000101_00000_0110111; #10;
        $display("U-type imm: %h (expected 12345000)", imm_out);

        // JAL x0, 8 => opcode 1101111
        instr = 32'b00000000000000000000010000000000_1101111; #10;
        $display("J-type imm: %h", imm_out);

        $finish;
    end

endmodule
