`timescale 1ns/1ps

module data_memory_tb;

    // Inputs
    reg clk;
    reg [31:0] address;
    reg [31:0] data_in;
    reg [1:0] write;
    reg [1:0] data;

    // Output
    wire [31:0] data_out;

    // Instantiate the module
    DataMemory uut (
        .clk(clk),
        .address(address),
        .data_in(data_in),
        .write(write),
        .data(data),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        $dumpfile("data_memory_tb.vcd");
        $dumpvars(0, data_memory_tb);

        // Initialize all signals
        address = 0;
        data_in = 0;
        write = 2'b00;
        data = 2'b00;

        #10;

        // Write byte
        address = 32'h00000004;
        data_in = 32'h000000AA;
        write = 2'b01;
        #10 write = 2'b00; // Disable write

        // Read byte
        data = 2'b00;
        #10;

        // Write halfword
        address = 32'h00000008;
        data_in = 32'h0000BEEF;
        write = 2'b10;
        #10 write = 2'b00;

        // Read halfword
        data = 2'b01;
        #10;

        // Write word
        address = 32'h0000000C;
        data_in = 32'hDEADBEEF;
        write = 2'b11;
        #10 write = 2'b00;

        // Read word
        data = 2'b10;
        #10;

        $finish;
    end

endmodule
