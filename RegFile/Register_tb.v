`timescale 1ns / 1ps

module regfile_tb;

    // Inputs
    reg clk;
    reg we;
    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;
    reg [4:0] rd_addr;
    reg [31:0] rd_data;

    // Outputs
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Instantiate the register file
    regfile uut (
        .clk(clk),
        .we(we),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period

    initial begin
        $display("Starting register file test...");
        clk = 0;
        we = 0;
        rd_addr = 0;
        rd_data = 0;
        rs1_addr = 0;
        rs2_addr = 0;

        // Wait for reset
        #10;

        // Write 32'hA5A5A5A5 to register x1
        rd_addr = 5'd1;
        rd_data = 32'hA5A5A5A5;
        we = 1;
        #10;

        // Disable write
        we = 0;
        #10;

        // Read from x1 and x0
        rs1_addr = 5'd1;
        rs2_addr = 5'd0;
        #10;

        $display("Read x1 = %h (expected A5A5A5A5)", rs1_data);
        $display("Read x0 = %h (expected 00000000)", rs2_data);

        // Try writing to x0 (should be ignored)
        rd_addr = 5'd0;
        rd_data = 32'hFFFFFFFF;
        we = 1;
        #10;

        we = 0;
        rs1_addr = 5'd0;
        #10;

        $display("After write attempt, x0 = %h (expected 00000000)", rs1_data);

        $finish;
    end

endmodule
