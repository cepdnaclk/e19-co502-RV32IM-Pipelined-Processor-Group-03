
module Register(
    input clk,
    input rst,
    input [31:0] data_in,
    input [4:0] write_addr,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input write_enable,
    output reg [31:0] data_out1,
    output reg [31:0] data_out2
);

    reg [31:0] registers [0:31]; // 32 registers of 32 bits each

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (write_enable) begin
            // Write data to the specified register
            registers[write_addr] <= data_in;
        end
    end

    always @(*) begin
        // Read data from the specified registers
        data_out1 = registers[read_addr1];
        data_out2 = registers[read_addr2];
    end
endmodule