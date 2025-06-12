module tb_branch_compare;
    reg [31:0] reg1;
    reg [31:0] reg2;
    reg [2:0] funct3;
    wire branch_taken;

    branch_compare uut (
        .reg1(reg1),
        .reg2(reg2),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );

    initial begin
        $display("Time\tfunct3\treg1\t\treg2\t\tBranchTaken");
        $monitor("%0t\t%b\t%0d\t%0d\t%b", $time, funct3, reg1, reg2, branch_taken);

        reg1 = 32'd10; reg2 = 32'd10;
        funct3 = 3'b000; #10;  // BEQ: true

        funct3 = 3'b001; #10;  // BNE: false

        reg2 = 32'd20; funct3 = 3'b001; #10;  // BNE: true

        funct3 = 3'b100; #10;  // BLT: true
        funct3 = 3'b101; #10;  // BGE: false

        reg1 = 32'd30; reg2 = 32'd20;
        funct3 = 3'b100; #10;  // BLT: false
        funct3 = 3'b101; #10;  // BGE: true

        funct3 = 3'b110; #10;  // BLTU: false
        funct3 = 3'b111; #10;  // BGEU: true

        $finish;
    end
endmodule