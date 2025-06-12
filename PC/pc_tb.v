`timescale 1ns / 1ps

module pc_tb;

    reg clk, reset, pc_write;
    reg [31:0] next_pc;
    wire [31:0] pc_out;

    pc uut (
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting PC test...");
        clk = 0; reset = 1; pc_write = 0; next_pc = 32'h00000004;
        #10 reset = 0;

        // Let PC update to next_pc
        pc_write = 1;
        next_pc = 32'h00000004; #10;
        $display("PC = %h (expected 00000004)", pc_out);

        // Change PC again
        next_pc = 32'h00000008; #10;
        $display("PC = %h (expected 00000008)", pc_out);

        // Disable write (stall)
        pc_write = 0;
        next_pc = 32'h0000000C; #10;
        $display("PC = %h (expected 00000008 - stalled)", pc_out);

        $finish;
    end
endmodule
