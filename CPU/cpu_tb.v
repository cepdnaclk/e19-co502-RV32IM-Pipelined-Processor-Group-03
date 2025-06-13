// Simple testbench for riscv_cpu without hazards
`timescale 1ns / 1ps

module cpu_tb;
    reg clk;
    reg reset;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Simulation control
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        clk = 0;
        reset = 1;
        #20;
        reset = 0;

        // Run for a fixed number of cycles
        #200;
        $finish;
    end
endmodule
