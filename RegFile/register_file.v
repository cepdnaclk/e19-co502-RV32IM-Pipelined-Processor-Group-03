module register_file (
    input         clk,
    input         we,             // Write enable
    input  [4:0]  rs1_addr,       // Read register 1 address
    input  [4:0]  rs2_addr,       // Read register 2 address
    input  [4:0]  rd_addr,        // Write register address
    input  [31:0] rd_data,        // Data to write
    output [31:0] rs1_data,       // Read data 1
    output [31:0] rs2_data        // Read data 2
);

    reg [31:0] regs [0:31];       // 32 registers of 32 bits

    // Read ports are combinational
    assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : regs[rs2_addr];

    // Write port on rising clock edge
    always @(posedge clk) begin
        if (we && (rd_addr != 5'd0)) begin
            regs[rd_addr] <= rd_data;
        end
    end
endmodule
