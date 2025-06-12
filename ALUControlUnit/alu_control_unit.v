module alu_control_unit (
    input  [1:0] alu_op,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] alu_control
);

    // ALU operations
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = ALU_ADD; // For load/store
            2'b01: alu_control = ALU_SUB; // For branches (usually subtract to compare)
            2'b10: begin // R-type
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_control = ALU_ADD;
                    {7'b0100000, 3'b000}: alu_control = ALU_SUB;
                    {7'b0000000, 3'b111}: alu_control = ALU_AND;
                    {7'b0000000, 3'b110}: alu_control = ALU_OR;
                    {7'b0000000, 3'b100}: alu_control = ALU_XOR;
                    {7'b0000000, 3'b010}: alu_control = ALU_SLT;
                    default: alu_control = ALU_ADD;
                endcase
            end
            2'b11: begin // I-type ALU ops
                case (funct3)
                    3'b000: alu_control = ALU_ADD; // addi
                    3'b111: alu_control = ALU_AND; // andi
                    3'b110: alu_control = ALU_OR;  // ori
                    3'b100: alu_control = ALU_XOR; // xori
                    3'b010: alu_control = ALU_SLT; // slti
                    default: alu_control = ALU_ADD;
                endcase
            end
            default: alu_control = ALU_ADD;
        endcase
    end

endmodule
