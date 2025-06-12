<<<<<<< HEAD
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

=======
module control_unit(
    instruction,
    write_enable,         // RegWrite back
    memory_access,        // Memory Access: Load/Store
    mem_write,            // Memory Write
    mem_read,             // Memory Read
    jump_and_link,        // Enables JALR and JAL
    alu_opcode,           // Specifies ALU operation
    immediate_select,     // Selects the source of immediate
    offset_generator,     // Selects type of PC offset used in jumps/branches.
    branch,jump,          // Control signals for branching and jumping.
    imm_sel        // Specifies the type of immediate value(I-type, S-type, B-type, U-type)
);

input[31:0] instruction;
output reg[4:0] alu_opcode;
output reg[2:0] imm_sel;
output reg write_enable,memory_access,mem_write,mem_read,jump_and_link,branch,jump;
output reg[1:0]offset_generator,immediate_select;
wire [6:0] opcode,funct7;
wire [2:0] funct3;


assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];


always @(opcode,funct3,funct7) begin
    #1 
    case(opcode)
    7'b0110011:begin //R type istruction
        imm_sel = 3'bxxx;
        write_enable = 1'b1;
        memory_access = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        jump_and_link = 1'b0;
        immediate_select = 2'b00;
        offset_generator = 2'b00;
        branch = 1'b0;
        jump = 1'b0 ;
        
        case({funct7,funct3})
        10'b0000000000:alu_opcode = 5'b00000; // ADD
        10'b0100000000:alu_opcode = 5'b00001; // SUB
        10'b0000000110:alu_opcode = 5'b00010; // OR
        10'b0000000100:alu_opcode = 5'b00011; // XOR
        10'b0000000111:alu_opcode = 5'b00100; // AND 
        10'b0000000101:alu_opcode = 5'b00101; // SRL
        10'b0000000001:alu_opcode = 5'b00110; // SLL
        10'b0100000101:alu_opcode = 5'b00111; // SRA
        10'b0000001000:alu_opcode = 5'b01000; // MUL
        10'b0000001001:alu_opcode = 5'b01001; // MULH
        10'b0000001011:alu_opcode = 5'b01010; // MULHU
        10'b0000001010:alu_opcode = 5'b01011; // MULHSU
        10'b0000001100:alu_opcode = 5'b01100; // DIV
        10'b0000001101:alu_opcode = 5'b01101; // DIVH
        10'b0000001110:alu_opcode = 5'b01110; // REM
        10'b0000001111:alu_opcode = 5'b01111; // REMU
        10'b0000000010:alu_opcode = 5'b10000; // SLT 
        endcase
    end

    7'b0010011:begin //I type istruction
        imm_sel = 3'b000;
        write_enable = 1'b1;
        memory_access = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        jump_and_link = 1'b0;
        immediate_select = 2'b10;
        offset_generator = 2'b00;
        branch = 1'b0;
        jump = 1'b0 ;

        case(funct3)
        3'b000:alu_opcode = 5'b00000; // ADDI
        3'b010:alu_opcode = 5'b10000; // SLTI
        3'b111:alu_opcode = 5'b00100; // ANDI
        3'b110:alu_opcode = 5'b00010; // ORI
        3'b100:alu_opcode = 5'b00011; // XORI
        endcase

        case(funct7)
        7'b0000000:begin
            case (funct3)
                3'b001: alu_opcode = 5'b00110; //SLLI
                3'b101: alu_opcode = 5'b00101; //SRLI 
            endcase
        end
        7'b0100000:begin
            case (funct3)
                3'b101: alu_opcode = 5'b00111; //SRAI
                endcase
        end
        endcase
    
    end

    7'b0000011:begin //LW istruction
        imm_sel = 3'b000;
        write_enable = 1'b1;
        memory_access = 1'b1;
        mem_write = 1'b0;
        mem_read = 1'b1;
        jump_and_link = 1'b0;
        immediate_select = 2'b10;
        offset_generator = 2'b00;
        branch = 1'b0;
        jump = 1'b0 ;
        alu_opcode = 5'b00000;
        end 

    7'b0100011:begin //S type istruction
        imm_sel = 3'b001;
        write_enable = 1'b0;
        memory_access = 1'b1;
        mem_write = 1'b1;    
        mem_read = 1'b0;
        jump_and_link = 1'b0;    
        immediate_select = 2'b10;
        offset_generator = 2'b00;
        branch = 1'b0;
        jump = 1'b0 ;
        alu_opcode = 5'b00000; 
    end

    7'b1101111:begin //J type istruction
        imm_sel = 3'b010;
        write_enable = 1'b1;
        memory_access = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        jump_and_link = 1'b1;
        immediate_select = 2'b10;
        offset_generator = 2'b10;
        branch = 1'b0;
        jump = 1'b1 ;
        alu_opcode = 5'b00000;
    end

    7'b1100111:begin //JALR istruction
        imm_sel = 3'b000;
        write_enable = 1'b1;
        memory_access = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        jump_and_link = 1'b1;
        immediate_select = 2'b10;
        offset_generator = 2'b00;
        branch = 1'b0;
        jump = 1'b1;
        alu_opcode = 5'b00000;
    end

    7'b0110111:begin // LUI
        imm_sel = 3'b011;
        write_enable = 1'b1;
        memory_access = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        jump_and_link = 1'b0;
        immediate_select = 2'b10;
        offset_generator = 2'b00;
        branch = 1'b0;
        jump = 1'b0;
        alu_opcode = 5'b10001;
    end

     7'b0010111:begin // AUIPC
        imm_sel = 3'b011;
        write_enable = 1'b1;
        memory_access = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        jump_and_link = 1'b0;
        immediate_select = 2'b10;
        offset_generator = 2'b10;
        branch = 1'b0;
        jump = 1'b0;
        alu_opcode = 5'b00000;
    end
    
    7'b1100011:begin // B type instruction
        imm_sel = 3'b100;
        write_enable = 1'b0;
        memory_access = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        jump_and_link = 1'b0;
        immediate_select = 2'b10;
        offset_generator = 2'b10;
        branch = 1'b1;
        jump = 1'b0;
        alu_opcode = 5'b00000;
    end
    

    endcase
end

>>>>>>> 1abd3169fce111782281f233e42426f0c9cf2ba5
endmodule
