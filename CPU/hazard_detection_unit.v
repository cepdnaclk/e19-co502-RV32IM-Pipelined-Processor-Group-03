module HazardDetectionUnit (
    input [4:0] ID_RS1, ID_RS2,            // From instruction in Decode stage
    input [4:0] EX_RD,                     // Destination reg of LW in Execute
    input       EX_MemRead,                // Is EX instruction a Load?
    output reg  PCWrite, IF_ID_Write,     // Control PC and IF/ID register
    output reg  Stall_ID_EX                // Insert NOP in ID/EX
);

    always @(*) begin
        // Default: no stall
        PCWrite     = 1;
        IF_ID_Write = 1;
        Stall_ID_EX = 0;

        if (EX_MemRead && ((EX_RD == ID_RS1) || (EX_RD == ID_RS2))) begin
            // Load-use hazard detected
            PCWrite     = 0;
            IF_ID_Write = 0;
            Stall_ID_EX = 1;
        end
    end
endmodule
