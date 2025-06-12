module instruction_memory (
    input  [31:0] addr,       // Byte address from PC
    output [31:0] instr       // 32-bit instruction
);

    // Memory size: 256 words (1 KB), can be adjusted
    reg [31:0] memory [0:255];

    // Initialize from file (optional)
    initial begin
        $readmemh("program.hex", memory);  // Load instructions in hex
    end

    assign instr = memory[addr[9:2]]; // Word aligned access (ignore lower 2 bits)

endmodule
