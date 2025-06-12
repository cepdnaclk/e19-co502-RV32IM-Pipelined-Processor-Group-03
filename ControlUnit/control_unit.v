module control_unit (
    input  [6:0] opcode,
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       alu_src,
    output reg       branch,
    output reg [1:0] alu_op
);

    always @(*) begin
        // Default values
        reg_write   = 0;
        mem_read    = 0;
        mem_write   = 0;
        mem_to_reg  = 0;
        alu_src     = 0;
        alu_op      = 2'b00;
        branch      = 0;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write   = 1;
                alu_src     = 0;
                alu_op      = 2'b10;
            end
            7'b0010011: begin // I-type ALU (addi, andi, ori, etc.)
                reg_write   = 1;
                alu_src     = 1;
                alu_op      = 2'b11;
            end
            7'b0000011: begin // Load
                reg_write   = 1;
                mem_read    = 1;
                mem_to_reg  = 1;
                alu_src     = 1;
                alu_op      = 2'b00;
            end
            7'b0100011: begin // Store
                mem_write   = 1;
                alu_src     = 1;
                alu_op      = 2'b00;
            end
            7'b1100011: begin // Branch
                branch      = 1;
                alu_src     = 0;
                alu_op      = 2'b01;
            end
            default: begin
                // Unsupported or NOP
            end
        endcase
    end

endmodule
