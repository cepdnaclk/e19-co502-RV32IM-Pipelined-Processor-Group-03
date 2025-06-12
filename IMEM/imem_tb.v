`timescale 1ns / 1ps

module imem_tb;

    reg  [31:0] addr;
    wire [31:0] instr;

    // Instantiate the instruction memory
    imem uut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        $display("Starting instruction memory test...");

        // Test a few addresses (assuming program.hex is preloaded)
        addr = 32'd0;     #10;
        $display("instr[0x%h] = %h", addr, instr);

        addr = 32'd4;     #10;
        $display("instr[0x%h] = %h", addr, instr);

        addr = 32'd8;     #10;
        $display("instr[0x%h] = %h", addr, instr);

        $finish;
    end

endmodule
