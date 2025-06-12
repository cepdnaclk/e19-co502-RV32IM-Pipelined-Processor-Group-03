`timescale 1ns / 1ps

module tb_control_unit;

    reg [6:0] opcode;
    wire reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch;
    wire [1:0] alu_op;

    control_unit uut (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .alu_op(alu_op)
    );

    initial begin
        $display("Time | Opcode     | RegWrite MemRead MemWrite MemToReg AluSrc Branch AluOp");
        $display("--------------------------------------------------------------------------");

        // R-type (add, sub, etc.)
        opcode = 7'b0110011; #10;
        $display("%4t | %b |     %b       %b        %b         %b       %b      %b     %b", $time, opcode, reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op);

        // I-type ALU (addi)
        opcode = 7'b0010011; #10;
        $display("%4t | %b |     %b       %b        %b         %b       %b      %b     %b", $time, opcode, reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op);

        // Load (lw)
        opcode = 7'b0000011; #10;
        $display("%4t | %b |     %b       %b        %b         %b       %b      %b     %b", $time, opcode, reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op);

        // Store (sw)
        opcode = 7'b0100011; #10;
        $display("%4t | %b |     %b       %b        %b         %b       %b      %b     %b", $time, opcode, reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op);

        // Branch (beq)
        opcode = 7'b1100011; #10;
        $display("%4t | %b |     %b       %b        %b         %b       %b      %b     %b", $time, opcode, reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op);

        $finish;
    end

endmodule
