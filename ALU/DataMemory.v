
module DataMemory(
    input clk,
    input rst,
    input [31:0] address,
    input [31:0] write_data,
    input mem_read,
    input mem_write,
    output reg [31:0] read_data
);
    // Memory array
    reg [31:0] memory [0:1023]; // 1024 words of 32 bits each

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset memory to 0
            integer i;
            for (i = 0; i < 1024; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end else begin
            if (mem_write) begin
                // Write data to memory at the specified address
                memory[address[11:2]] <= write_data; // Address is word-aligned, so we use address[11:2]
            end
        end
    end

    always @(*) begin
        if (mem_read) begin
            // Read data from memory at the specified address
            read_data = memory[address[11:2]]; // Address is word-aligned, so we use address[11:2]
        end else begin
            read_data = 32'bz; // High impedance when not reading
        end
    end

endmodule