module total_control(instruction_fetch, instruction_decode, instruction_execute, instruction_mem, instruction_writeback,
                basic_r_type, r_type, i_type, ji_type, jii_type,
                addi, mul, div, 
                sw, lw, j, bne, jal, jr, blt, 
                bex, setx, 
                regfile_wren, 
                write_reg, 
                mem_wren, 
                write_data_mem_to_regfile, 
                alu_opcode);

    input [31:0] instruction;

    output basic_r_type, r_type, i_type, ji_type, jii_type;
    output addi, mul, div;
    output sw, lw, j, bne, jal, jr, blt;
    output bex, setx;

    output regfile_wren;
    output [4:0] write_reg;

    output mem_wren, write_data_mem_to_regfile;

    output [4:0] alu_opcode;


    // ----- SIGNAL GROUPS -----
    assign basic_r_type = r_type & ~mul & ~div;
    assign r_type = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];  // 00000

    assign i_type = addi || sw || lw || bne || blt;
    assign ji_type = j || jal || bex || setx;
    assign jii_type = jr;
    

    // ----- SPECIFIC SIGNALS -----
    assign addi = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];  // 00101
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



    // assign thing = instruction[31] & instruction[30] & instruction[29] & instruction[28] & instruction[27] & instruction[26] & instruction[25] & instruction[24] &
    //                     instruction[23] & instruction[22] & instruction[21] & instruction[20] & instruction[19] & instruction[18] & instruction[17] & instruction[16] &
    //                     instruction[15] & instruction[14] & instruction[13] & instruction[12] & instruction[11] & instruction[10] & instruction[9] & instruction[8] &
    //                     instruction[7] & instruction[6] & instruction[5] & instruction[4] & instruction[3] & instruction[2] & instruction[1] & instruction[0];
    // assign thing = opcode[4] & opcode[3] & opcode[2] & opcode[1] & opcode[0];

    // ----- PC CONTROL SIGNALS -----


    // ----- REGFILE SIGNALS -----
    assign regfile_wren = r_type || lw || jal || setx;

    wire [4:0] rd;
    wire write_reg_rd, write_reg_rstatus, write_reg_r31, regfile_wren;
    assign rd = instruction[26:22];
    assign write_reg_rd = r_type || addi || lw;
    assign write_reg_rstatus = setx;
    assign write_reg_r31 = jr;

    assign write_reg = write_reg_rd;  // TODO



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
    assign non_r_type_alu_opcode_sub = bne || blt || bex;
    assign non_r_type_alu_opcode = non_r_type_alu_opcode_sub ? 5'b00001 : 5'b00000;

    assign alu_opcode = r_type ? r_type_alu_opcode : non_r_type_alu_opcode;



endmodule