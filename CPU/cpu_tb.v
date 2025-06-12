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

    // Instruction memory initialization
    initial begin
        // Initialize instruction memory with a sequence of instructions
        // No hazards: insert NOPs (addi x0, x0, 0) between dependent instructions

        // Example instructions (in hex):
        // addi x1, x0, 5     --> 0x00500093
        // addi x2, x0, 10    --> 0x00a00113
        // add x3, x1, x2     --> 0x002081b3
        // sw x3, 0(x0)       --> 0x00302023
        // lw x4, 0(x0)       --> 0x00002283

        // Memory address 0x00
        uut.imem.mem[0] = 8'h93; // addi x1, x0, 5
        uut.imem.mem[1] = 8'h00;
        uut.imem.mem[2] = 8'h50;
        uut.imem.mem[3] = 8'h00;

        // Memory address 0x04
        uut.imem.mem[4] = 8'h13; // addi x2, x0, 10
        uut.imem.mem[5] = 8'h01;
        uut.imem.mem[6] = 8'ha0;
        uut.imem.mem[7] = 8'h00;

        // Memory address 0x08
        uut.imem.mem[8] = 8'h13; // NOP (addi x0, x0, 0)
        uut.imem.mem[9] = 8'h00;
        uut.imem.mem[10] = 8'h00;
        uut.imem.mem[11] = 8'h00;

        // Memory address 0x0C
        uut.imem.mem[12] = 8'hb3; // add x3, x1, x2
        uut.imem.mem[13] = 8'h81;
        uut.imem.mem[14] = 8'h20;
        uut.imem.mem[15] = 8'h00;

        // Memory address 0x10
        uut.imem.mem[16] = 8'h23; // sw x3, 0(x0)
        uut.imem.mem[17] = 8'h20;
        uut.imem.mem[18] = 8'h30;
        uut.imem.mem[19] = 8'h00;

        // Memory address 0x14
        uut.imem.mem[20] = 8'h83; // lw x4, 0(x0)
        uut.imem.mem[21] = 8'h22;
        uut.imem.mem[22] = 8'h00;
        uut.imem.mem[23] = 8'h00;

        // Final NOPs to let pipeline flush
        uut.imem.mem[24] = 8'h13;
        uut.imem.mem[25] = 8'h00;
        uut.imem.mem[26] = 8'h00;
        uut.imem.mem[27] = 8'h00;

        uut.imem.mem[28] = 8'h13;
        uut.imem.mem[29] = 8'h00;
        uut.imem.mem[30] = 8'h00;
        uut.imem.mem[31] = 8'h00;
    end

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
