`include "../PC/pc.v"
`include "../IMEM/imem.v"
`include "../ImmGenerator/imm_generator.v"

module riscv_cpu (
    input wire clk,
    input wire reset
);

// ----------- PC -----------
reg [31:0] PC;
wire [31:0] PC_next;
assign PC_next = PC + 4;

pc pc (
    .clk(clk),
    .reset(reset),
    .pc_write(1'b1),  // Always write to PC for this simple CPU
    .next_pc(PC_next),
    .pc_out(PC)
);

// ----------- IF Stage -----------
wire [31:0] instr;
instruction_memory imem (
    .addr(PC),
    .instruction(instr)
);

// ----------- IF/ID Pipeline Register -----------
reg [31:0] IF_ID_PC, IF_ID_instr;

always @(posedge clk) begin
    IF_ID_PC <= PC;
    IF_ID_instr <= instr;
end

// ----------- ID Stage -----------
wire [4:0] rs1 = IF_ID_instr[19:15];
wire [4:0] rs2 = IF_ID_instr[24:20];
wire [4:0] rd  = IF_ID_instr[11:7];
wire [6:0] opcode = IF_ID_instr[6:0];
wire [2:0] funct3 = IF_ID_instr[14:12];
wire [6:0] funct7 = IF_ID_instr[31:25];
wire [31:7] immediate_reg = IF_ID_instr[31:7]; //-------------------------------------------------------------------------------------------

wire [31:0] rd1, rd2;
register_file rf (
    .clk(clk),
    .rs1_addr(rs1),
    .rs2_addr(rs2),
    .rd_addr(MEM_WB_rd),
    .rd_data(WB_result),
    .we(MEM_WB_reg_write),
    .rs1_data(rd1),
    .rs1_data(rd2)
);

wire [31:0] imm;
imm_generator imm_gen (
    .instr(IF_ID_instr),
    .imm_out(imm)
);

// Control Signals
wire reg_write, mem_read, mem_write, mem_to_reg, alu_src;
wire [1:0] alu_op;
control_unit cu (
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .alu_src(alu_src),
    .alu_op(alu_op)
);

// ----------- ID/EX Pipeline Register -----------
reg [31:0] ID_EX_PC, ID_EX_imm, ID_EX_rd1, ID_EX_rd2;
reg [4:0] ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
reg [2:0] ID_EX_funct3;
reg [6:0] ID_EX_funct7;
reg ID_EX_reg_write, ID_EX_mem_read, ID_EX_mem_write, ID_EX_mem_to_reg, ID_EX_alu_src;
reg [1:0] ID_EX_alu_op;

always @(posedge clk) begin
    ID_EX_PC <= IF_ID_PC;
    ID_EX_rd1 <= rd1;
    ID_EX_rd2 <= rd2;
    ID_EX_imm <= imm;
    ID_EX_rs1 <= rs1;
    ID_EX_rs2 <= rs2;
    ID_EX_rd <= rd;
    ID_EX_funct3 <= funct3;
    ID_EX_funct7 <= funct7;
    ID_EX_reg_write <= reg_write;
    ID_EX_mem_read <= mem_read;
    ID_EX_mem_write <= mem_write;
    ID_EX_mem_to_reg <= mem_to_reg;
    ID_EX_alu_src <= alu_src;
    ID_EX_alu_op <= alu_op;
end

// ----------- EX Stage -----------
wire [3:0] alu_control;
alu_control_unit alu_cu (
    .alu_op(ID_EX_alu_op),
    .funct3(ID_EX_funct3),
    .funct7(ID_EX_funct7),
    .alu_control(alu_control)
);

wire [31:0] alu_input_b = (ID_EX_alu_src) ? ID_EX_imm : ID_EX_rd2;
wire [31:0] alu_out;
alu alu (
    .a(ID_EX_rd1),
    .b(alu_input_b),
    .alu_control(alu_control),
    .result(alu_out)
);

// ----------- EX/MEM Pipeline Register -----------
reg [31:0] EX_MEM_alu_out, EX_MEM_rd2;
reg [4:0] EX_MEM_rd;
reg EX_MEM_reg_write, EX_MEM_mem_read, EX_MEM_mem_write, EX_MEM_mem_to_reg;

always @(posedge clk) begin
    EX_MEM_alu_out <= alu_out;
    EX_MEM_rd2 <= ID_EX_rd2;
    EX_MEM_rd <= ID_EX_rd;
    EX_MEM_reg_write <= ID_EX_reg_write;
    EX_MEM_mem_read <= ID_EX_mem_read;
    EX_MEM_mem_write <= ID_EX_mem_write;
    EX_MEM_mem_to_reg <= ID_EX_mem_to_reg;
end

// ----------- MEM Stage -----------
wire [31:0] mem_data_out;
data_memory dmem (
    .clk(clk),
    .addr(EX_MEM_alu_out),
    .write_data(EX_MEM_rd2),
    .mem_read(EX_MEM_mem_read),
    .mem_write(EX_MEM_mem_write),
    .read_data(mem_data_out)
);

// ----------- MEM/WB Pipeline Register -----------
reg [31:0] MEM_WB_mem_data, MEM_WB_alu_out;
reg [4:0] MEM_WB_rd;
reg MEM_WB_reg_write, MEM_WB_mem_to_reg;

always @(posedge clk) begin
    MEM_WB_mem_data <= mem_data_out;
    MEM_WB_alu_out <= EX_MEM_alu_out;
    MEM_WB_rd <= EX_MEM_rd;
    MEM_WB_reg_write <= EX_MEM_reg_write;
    MEM_WB_mem_to_reg <= EX_MEM_mem_to_reg;
end

// ----------- WB Stage -----------
wire [31:0] WB_result = MEM_WB_mem_to_reg ? MEM_WB_mem_data : MEM_WB_alu_out;

endmodule
