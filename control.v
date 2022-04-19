module control(instruction, 
                basic_r_type, r_type, i_type, ji_type, jii_type,
                addi, mul, div, 
                sw, lw, j, bne, jal, jr, blt, 
                bex, setx, 
                regfile_wren, 
                write_reg, read_regA, read_regB,
                mem_wren, 
                write_data_mem_to_regfile, 
                alu_opcode,
                immediate_inALUB,
                jr_read_reg,
                increment_score);

    input [31:0] instruction;

    output basic_r_type, r_type, i_type, ji_type, jii_type;
    output addi, mul, div;
    output sw, lw, j, bne, jal, jr, blt;
    output bex, setx;
    output increment_score;

    output regfile_wren;
    output [4:0] write_reg, read_regA, read_regB;

    output mem_wren, write_data_mem_to_regfile;

    output [4:0] alu_opcode;
    output immediate_inALUB;

    output [4:0] jr_read_reg;


    // ----- SIGNAL GROUPS -----
    assign basic_r_type = r_type & ~mul & ~div;
    assign r_type = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];  // 00000

    assign i_type = addi | sw | lw | bne | blt;
    assign ji_type = j | jal | bex | setx;
    assign jii_type = jr;
    

    // ----- SPECIFIC SIGNALS -----
    assign addi = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0] || (increment_score);  // 00101
    assign mul = r_type & ~r_type_alu_opcode[4] & ~r_type_alu_opcode[3] & r_type_alu_opcode[2] & r_type_alu_opcode[1] & ~r_type_alu_opcode[0];  // 00000 (00110)
    assign div = r_type & ~r_type_alu_opcode[4] & ~r_type_alu_opcode[3] & r_type_alu_opcode[2] & r_type_alu_opcode[1] & r_type_alu_opcode[0];  // 00000 (00111)

    assign sw = ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & opcode[0];  // 00111
    assign lw = ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];  // 01000

    assign j = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0];  // 00001
    assign bne = ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0];  // 00010
    assign jal = ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & opcode[0];  // 00011
    assign jr = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & ~opcode[0];  // 00100
    assign blt = ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & ~opcode[0];  // 00110

    assign bex = opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & ~opcode[0];  // 10110
    assign setx = opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];  // 10101
    assign increment_score = ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0];  // 01001

    wire nop;
    assign nop = (instruction == 32'b00000000000000000000000000000000);


    // ----- PC CONTROL SIGNALS -----


    // ----- REGFILE SIGNALS -----
    assign regfile_wren = (r_type & ~nop & ~mul & ~div) | lw | jal | setx | addi;

    wire [4:0] rd, write_reg_temp;
    wire write_reg_rd, write_reg_rstatus, write_reg_r31;
    assign rd = instruction[26:22];
    assign write_reg_rd = r_type | addi | lw;
    assign write_reg_rstatus = setx;
    assign write_reg_r31 = jr;

    assign write_reg_temp = setx ? 5'b11110 : rd;
    assign write_reg = jal ? 5'b11111 : write_reg_temp;

    wire read_rd, read_rstatus;
    assign read_rd = sw | bne | blt | jr;

    // TODO: for BEX, need to read $rstatus and $0
    wire [4:0] read_regB_temp;
    assign read_regA = bex ? 5'b11110 : instruction[21:17];  // $rs

    assign read_regB_temp = read_rd ? instruction[26:22] : instruction[16:12];  // $rd : $rt
    assign read_regB = (bex | addi) ? 5'b00000 : read_regB_temp;


    // ----- DATA MEM SIGNALS -----
    assign mem_wren = sw;
    assign write_data_mem_to_regfile = lw;


    // ----- ALU SIGNALS -----
    // For basic R types, need ALU op to be instruction[6:2]
    // For sw and lw, need add
    // For bne, need subtract
    // For blt, need subtract
    // For bex, need subtract
    
    wire [4:0] opcode;
    assign opcode = instruction[31:27];

    wire [4:0] r_type_alu_opcode, non_r_type_alu_opcode;
    assign r_type_alu_opcode = instruction[6:2];

    wire non_r_type_alu_opcode_sub;
    assign non_r_type_alu_opcode_sub = bne | blt | bex;
    assign non_r_type_alu_opcode = non_r_type_alu_opcode_sub ? 5'b00001 : 5'b00000;

    assign alu_opcode = r_type ? r_type_alu_opcode : non_r_type_alu_opcode;

    assign immediate_inALUB = addi | sw | lw;


    // ----- JUMP -----
    assign jr_read_reg = rd;


endmodule