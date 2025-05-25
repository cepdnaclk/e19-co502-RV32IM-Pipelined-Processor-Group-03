`timescale 1ns/1ps

module sign_extender_tb;

    reg [31:7] instrBits;
    reg [2:0] IMM_SEL;
    wire [31:0] imm_out;

    // Instantiate the SignExtender module
    SignExtender uut (
        .instrBits(instrBits),
        .IMM_SEL(IMM_SEL),
        .imm_out(imm_out)
    );

    initial begin
        // Setup for GTKWave
        $dumpfile("sign_extender_tb.vcd");
        $dumpvars(0, sign_extender_tb);

        // Print header
        $display("Time | IMM_SEL | instrBits         | imm_out");
        $monitor("%4t |   %b    | %b | %h", $time, IMM_SEL, instrBits, imm_out);

        // I-type test: imm = -5 (0xFFF...FFB)
        IMM_SEL = 3'b000;
        instrBits = 25'b1111111111111111111111111; // instr[31:20] = -1
        #10;

        // S-type test
        IMM_SEL = 3'b001;
        instrBits = {7'b1110011, 5'b01100}; // instr[31:25] and instr[11:7]
        #10;

        // B-type test
        IMM_SEL = 3'b010;
        instrBits = {1'b1, 6'b000011, 4'b1111, 1'b0, 12'b000000000000};
        #10;

        // U-type test
        IMM_SEL = 3'b011;
        instrBits = 25'hABCDE;
        #10;

        // J-type test
        IMM_SEL = 3'b100;
        instrBits = {1'b0, 8'h01, 1'b1, 8'h0F}; // Custom encoding
        #10;

        // Invalid case
        IMM_SEL = 3'b111;
        instrBits = 25'h00000;
        #10;

        $finish;
    end

endmodule
