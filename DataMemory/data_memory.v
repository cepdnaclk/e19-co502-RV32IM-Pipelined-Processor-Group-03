module data_memory (
    input         clk,
    input  [31:0] address,
    input  [31:0] data_in,
    input  [1:0]  write,   // 00: no write, 01: byte, 10: halfword, 11: word
    input  [1:0]  data,    // 00: byte, 01: halfword, 10: word
    output reg [31:0] data_out
);

    // 1K memory (1024 x 8-bit = 1024 bytes = 256 words)
    reg [7:0] mem [0:1023];

    wire [31:0] addr = address & 32'h000003FF; // Mask to fit in 1K

    always @(posedge clk) begin
        case (write)
            2'b01: mem[addr]     <= data_in[7:0];                    // Byte write
            2'b10: begin                                            // Halfword write
                mem[addr]     <= data_in[7:0];
                mem[addr + 1] <= data_in[15:8];
            end
            2'b11: begin                                            // Word write
                mem[addr]     <= data_in[7:0];
                mem[addr + 1] <= data_in[15:8];
                mem[addr + 2] <= data_in[23:16];
                mem[addr + 3] <= data_in[31:24];
            end
        endcase
    end

    always @(*) begin
        case (data)
            2'b00: data_out = {{24{mem[addr][7]}}, mem[addr]};                  // Sign-extended byte
            2'b01: data_out = {{16{mem[addr + 1][7]}}, mem[addr + 1], mem[addr]}; // Sign-extended halfword
            2'b10: data_out = {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]}; // Full word
            default: data_out = 32'b0;
        endcase
    end

endmodule
