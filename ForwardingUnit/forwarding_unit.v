module ForwardingUnit (
    input  [4:0] EX_RS1, EX_RS2,           // Source regs from EX stage
    input  [4:0] MEM_RD, WB_RD,            // Dest regs from MEM & WB stages
    input        MEM_RegWrite, WB_RegWrite,
    output reg [1:0] ForwardA, ForwardB    // Control muxes before ALU
);
    always @(*) begin
        // Default: no forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // EX hazard: forward from MEM stage
        if (MEM_RegWrite && (MEM_RD != 0) && (MEM_RD == EX_RS1))
            ForwardA = 2'b10;
        if (MEM_RegWrite && (MEM_RD != 0) && (MEM_RD == EX_RS2))
            ForwardB = 2'b10;

        // WB hazard: forward from WB stage
        if (WB_RegWrite && (WB_RD != 0) && (WB_RD == EX_RS1) && !(MEM_RegWrite && MEM_RD == EX_RS1))
            ForwardA = 2'b01;
        if (WB_RegWrite && (WB_RD != 0) && (WB_RD == EX_RS2) && !(MEM_RegWrite && MEM_RD == EX_RS2))
            ForwardB = 2'b01;
    end
endmodule
