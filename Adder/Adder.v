module adder(
    input [31:0] PC,
    output [31:0] updated_PC
);

    assign #1 updated_PC =  PC + 4;

endmodule