/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    // iverilog -o proc -c FileList.txt -s Wrapper_tb -P Wrapper_tb.FILE=\"addi_basic\"

    // module register(data_out, clk, data_in, write_enable, clr);
    // module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

    // TODO LIST
    // DONE: Memory wo bypassing, jump, jal, bypassing into alu inputs, bypassing into memory, bne, blt, bypassing zero, stall logic
    // TODO: jr, mult/div

    
    // Stall logic
    // Write nop into D/X.IR (flush_DX), disable F/D latch and PC write enable
    wire stall;
    assign stall = (X_lw & ((D_read_regA == X_write_reg) | ((D_read_regB == X_write_reg) & ~D_sw))) | multdiv_active | ready_to_write_multdiv_result;


    // Fetch: Create a PC and hook it up with the ROM.v module    
    wire [31:0] PC, PC_plus_1, current_instruction, FD_PC, FD_IR, new_PC, new_PC_temp1, new_PC_temp2;
    wire isNotEqual_PC_plus_1, isLessThan_PC_plus_1, overflow_PC_plus_1, PC_enable;

    assign PC_enable = ~stall;
    register PC_reg(PC, ~clock, new_PC, PC_enable, reset);
    assign address_imem = PC;
    assign current_instruction = q_imem;

    wire F_basic_r_type, F_r_type, F_i_type, F_ji_type, F_jii_type, F_addi, F_mul, F_div, F_sw, F_lw, F_j, F_bne, F_jal, F_jr, F_blt, F_bex, F_setx;
    wire F_regfile_wren, F_mem_wren, F_write_data_mem_to_regfile, F_immediate_inALUB;
    wire [4:0] F_alu_opcode, F_write_reg, F_read_regA, F_read_regB, F_jr_read_reg;

    control CONTROL_F(current_instruction,
                    F_basic_r_type, F_r_type, F_i_type, F_ji_type, F_jii_type,
                    F_addi, F_mul, F_div, 
                    F_sw, F_lw, F_j, F_bne, F_jal, F_jr, F_blt, 
                    F_bex, F_setx, 
                    F_regfile_wren, 
                    F_write_reg, F_read_regA, F_read_regB,
                    F_mem_wren, 
                    F_write_data_mem_to_regfile, 
                    F_alu_opcode,
                    F_immediate_inALUB,
                    F_jr_read_reg);


    // Set Next PC
    alu ALU_PC_plus_1(PC, 32'b00000000000000000000000000000001, 5'b00000, 5'b00000, PC_plus_1, isNotEqual_PC_plus_1, isLessThan_PC_plus_1, overflow_PC_plus_1);
    
    wire set_pc_to_j_target;
    assign set_pc_to_j_target = F_j | F_jal;
    wire [31:0] j_target_extended;
    assign j_target_extended = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, current_instruction[26:0]};

    wire [31:0] jr_data, bypassed_jr_temp1, bypassed_jr_temp2, bypassed_jr;
    wire bypass_jr_DX, bypass_jr_XM, bypass_jr_MW;
    assign jr_data = data_readRegB;
    assign bypass_jr_DX = (D_read_regB == X_write_reg) & X_regfile_wren & (X_write_reg != 5'b00000);
    assign bypass_jr_XM = (D_read_regB == M_write_reg) & M_regfile_wren & (M_write_reg != 5'b00000);
    assign bypass_jr_MW = (D_read_regB == W_write_reg) & W_regfile_wren & (W_write_reg != 5'b00000);
    
    assign bypassed_jr_temp1 = bypass_jr_DX ? XM_O_in : jr_data;
    assign bypassed_jr_temp2 = bypass_B_XM ? XM_O : bypassed_jr_temp1;    
    assign bypassed_jr = bypass_B_MW ? data_writeReg : bypassed_jr_temp2;

    assign new_PC_temp1 = set_pc_to_j_target ? j_target_extended : PC_plus_1;
    assign new_PC_temp2 = take_branch ? branch_PC : new_PC_temp1;
    assign new_PC = D_jr ? bypassed_jr : new_PC_temp2;
        
    // FD Latch
    wire flush_FD, enable_FD;
    assign enable_FD = ~stall;
    assign flush_FD = take_branch | D_jr;
    wire [31:0] FD_PC_in, FD_IR_in;

    assign FD_PC_in = flush_FD ? 32'b0 : PC_plus_1;
    assign FD_IR_in = flush_FD ? 32'b0 : current_instruction;

    register FD_PC_reg(FD_PC, ~clock, FD_PC_in, enable_FD, reset);
    register FD_IR_reg(FD_IR, ~clock, FD_IR_in, enable_FD, reset);


    // ----- Decode: Parse the instruction and pass appropriate info to the Regfile.v -----
    wire D_basic_r_type, D_r_type, D_i_type, D_ji_type, D_jii_type, D_addi, D_mul, D_div, D_sw, D_lw, D_j, D_bne, D_jal, D_jr, D_blt, D_bex, D_setx;
    wire D_regfile_wren, D_mem_wren, D_write_data_mem_to_regfile, D_immediate_inALUB;
    wire [4:0] D_alu_opcode, D_write_reg, D_read_regA, D_read_regB, D_jr_read_reg;

    control CONTROL_D(FD_IR,
                    D_basic_r_type, D_r_type, D_i_type, D_ji_type, D_jii_type,
                    D_addi, D_mul, D_div, 
                    D_sw, D_lw, D_j, D_bne, D_jal, D_jr, D_blt, 
                    D_bex, D_setx, 
                    D_regfile_wren, 
                    D_write_reg, D_read_regA, D_read_regB,
                    D_mem_wren, 
                    D_write_data_mem_to_regfile, 
                    D_alu_opcode,
                    D_immediate_inALUB,
                    D_jr_read_reg);

    assign ctrl_readRegA = D_read_regA;
    assign ctrl_readRegB = D_read_regB;

    wire [31:0] data_A, data_B;
    assign data_A = data_readRegA;
    assign data_B = data_readRegB;

    // DX Latch
    wire flush_DX, enable_DX;
    assign enable_DX = 1'b1;
    assign flush_DX = take_branch | stall;
    wire [31:0] DX_PC_in, DX_A_in, DX_B_in, DX_IR_in;

    assign DX_PC_in = flush_DX ? 32'b0 : FD_PC;
    assign DX_A_in = flush_DX ? 32'b0 : data_A;
    assign DX_B_in = flush_DX ? 32'b0 : data_B;
    assign DX_IR_in = flush_DX ? 32'b0 : FD_IR;

    wire [31:0] DX_PC, DX_A, DX_B, DX_IR;
    register DX_PC_reg(DX_PC, ~clock, DX_PC_in, enable_DX, reset);  
    register DX_A_reg(DX_A, ~clock, DX_A_in, enable_DX, reset);  
    register DX_B_reg(DX_B, ~clock, DX_B_in, enable_DX, reset);  
    register DX_IR_reg(DX_IR, ~clock, DX_IR_in, enable_DX, reset);  

    
    // ----- Execute: Run the proper ALU inputs (for the basic arithmetic tests) -----

    wire X_basic_r_type, X_r_type, X_i_type, X_ji_type, X_jii_type, X_addi, X_mul, X_div, X_sw, X_lw, X_j, X_bne, X_jal, X_jr, X_blt, X_bex, X_setx;
    wire X_regfile_wren, X_mem_wren, X_write_data_mem_to_regfile, X_immediate_inALUB;
    wire [4:0] X_alu_opcode, X_write_reg, X_write_reg_temp, X_read_regA, X_read_regB, X_jr_read_reg;

    control CONTROL_X(DX_IR,
                    X_basic_r_type, X_r_type, X_i_type, X_ji_type, X_jii_type,
                    X_addi, X_mul, X_div, 
                    X_sw, X_lw, X_j, X_bne, X_jal, X_jr, X_blt, 
                    X_bex, X_setx, 
                    X_regfile_wren, 
                    X_write_reg_temp, X_read_regA, X_read_regB,
                    X_mem_wren, 
                    X_write_data_mem_to_regfile, 
                    X_alu_opcode,
                    X_immediate_inALUB,
                    X_jr_read_reg);

    // Bypassing A
    wire bypass_A_XM, bypass_A_MW;
    assign bypass_A_XM = (X_read_regA == M_write_reg) & M_regfile_wren & (M_write_reg != 5'b00000);
    assign bypass_A_MW = (X_read_regA == W_write_reg) & W_regfile_wren & (W_write_reg != 5'b00000);

    wire [31:0] bypassed_A_temp, bypassed_A;
    assign bypassed_A_temp = bypass_A_MW ? data_writeReg : DX_A;
    assign bypassed_A = bypass_A_XM ? XM_O : bypassed_A_temp;

    // Bypassing B
    wire bypass_B_XM, bypass_B_MW;
    assign bypass_B_XM = (X_read_regB == M_write_reg) & M_regfile_wren & (M_write_reg != 5'b00000);
    assign bypass_B_MW = (X_read_regB == W_write_reg) & W_regfile_wren & (W_write_reg != 5'b00000);

    wire [31:0] bypassed_B_temp, bypassed_B;
    assign bypassed_B_temp = bypass_B_MW ? data_writeReg : DX_B;
    assign bypassed_B = bypass_B_XM ? XM_O : bypassed_B_temp;

    // Extend Immediate
    wire [16:0] immediate;
    wire [31:0] sign_extended_immediate;
    assign immediate = DX_IR[16:0];
    assign sign_extended_immediate = {immediate[16], immediate[16], immediate[16], immediate[16], 
                                    immediate[16], immediate[16], immediate[16], immediate[16], 
                                    immediate[16], immediate[16], immediate[16], immediate[16], 
                                    immediate[16], immediate[16], immediate[16], immediate};
    
    // Pick ALU Op B
    wire [31:0] alu_data_operandB;
    assign alu_data_operandB = X_immediate_inALUB ? sign_extended_immediate : bypassed_B;

    wire isNotEqual, isLessThan, overflow;
    wire [31:0] alu_out;
    alu ALU(bypassed_A, alu_data_operandB, X_alu_opcode, DX_IR[11:7], alu_out, isNotEqual, isLessThan, overflow);

    wire [31:0] XM_O_in_temp1, XM_O_in_temp2, XM_O_in_temp, target_extended;
    assign target_extended = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, DX_IR[26:0]};
    assign XM_O_in_temp1 = X_jal ? DX_PC : alu_out;
    assign XM_O_in_temp2 = X_setx ? target_extended : XM_O_in_temp1;
    assign XM_O_in_temp = overflow ? overflow_value : XM_O_in_temp2;

    // Overflow
    wire [31:0] overflow_value, overflow_value_temp1, overflow_value_temp2;
    wire X_add, X_sub;
    assign X_add = (X_alu_opcode == 5'b00000) & X_r_type;
    assign X_sub = (X_alu_opcode == 5'b00001) & X_r_type;
    assign overflow_value_temp1 = X_add ? 32'b00000000000000000000000000000001 : 32'b00000000000000000000000000000000;
    assign overflow_value_temp2 = X_addi ? 32'b00000000000000000000000000000010 : overflow_value_temp1;
    assign overflow_value = X_sub ? 32'b00000000000000000000000000000011 : overflow_value_temp2;
    
    assign X_write_reg = overflow ? 5'b11110 : X_write_reg_temp;


    // Branch Logic
    // A is $rs, and B is $rd, we want $rd < $rs for blt
    wire take_branch, overflow_branch_PC, isNotEqual_branch_PC, isLessThan_branch_PC;
    wire [31:0] branch_PC, PC_plus_1_plus_N;
    assign take_branch = (X_bne & isNotEqual) | (X_blt & isNotEqual & ~isLessThan) | (X_bex & isNotEqual);
    alu ALU_branch_PC(DX_PC, sign_extended_immediate, 5'b00000, 5'b00000, PC_plus_1_plus_N, isNotEqual_branch_PC, isLessThan_branch_PC, overflow_branch_PC);  // PC = PC + 1 + N
    assign branch_PC = X_bex ? target_extended : PC_plus_1_plus_N;

    wire enable_XM, flush_XM, overflow_in;
    assign flush_XM = 1'b0;
    assign enable_XM = 1'b1;
    wire [31:0] XM_PC, XM_O, XM_B, XM_IR, XM_PC_in, XM_O_in, XM_B_in, XM_IR_in;

    assign XM_PC_in = flush_XM ? 32'b0 : DX_PC;
    assign XM_O_in = flush_XM ? 32'b0 : XM_O_in_temp;
    assign XM_B_in = flush_XM ? 32'b0 : bypassed_B;
    assign XM_IR_in = flush_XM ? 32'b0 : DX_IR;
    assign overflow_in = flush_XM ? 1'b0 : overflow;

    wire XM_overflow;
    register XM_PC_reg(XM_PC, ~clock, DX_PC, enable_XM, reset);
    register XM_O_reg(XM_O, ~clock, XM_O_in, enable_XM, reset);
    register XM_B_reg(XM_B, ~clock, bypassed_B, enable_XM, reset);
    register XM_IR_reg(XM_IR, ~clock, DX_IR, enable_XM, reset);
    dffe_ref XM_dffe_overflow(XM_overflow, overflow_in, ~clock, enable_XM, reset);


    // ----- Memory: Pass in the appropriate values to the RAM.v module (needed for lw and sw) -----

    wire M_basic_r_type, M_r_type, M_i_type, M_ji_type, M_jii_type, M_addi, M_mul, M_div, M_sw, M_lw, M_j, M_bne, M_jal, M_jr, M_blt, M_bex, M_setx;
    wire M_regfile_wren, M_mem_wren, M_write_data_mem_to_regfile, M_immediate_inALUB;
    wire [4:0] M_alu_opcode, M_write_reg_temp, M_write_reg, M_read_regA, M_read_regB, M_jr_read_reg;

    control CONTROL_M(XM_IR,
                    M_basic_r_type, M_r_type, M_i_type, M_ji_type, M_jii_type,
                    M_addi, M_mul, M_div, 
                    M_sw, M_lw, M_j, M_bne, M_jal, M_jr, M_blt, 
                    M_bex, M_setx, 
                    M_regfile_wren, 
                    M_write_reg_temp, M_read_regA, M_read_regB,
                    M_mem_wren, 
                    M_write_data_mem_to_regfile, 
                    M_alu_opcode,
                    M_immediate_inALUB,
                    M_jr_read_reg);

    // In case of overflow in last stage
    assign M_write_reg = XM_overflow ? 5'b11110 : M_write_reg_temp;

    // Bypassing into memory
    wire bypass_data_MW;
    assign bypass_data_MW = (XM_IR[26:22] == W_write_reg) & (W_write_reg != 5'b00000);  // (RD == regfile write reg)

    assign address_dmem = XM_O;
    assign data = bypass_data_MW ? data_writeReg : XM_B;
    assign wren = M_sw;

    // MW Latch
    wire enable_MW;
    assign enable_MW = 1'b1;
    wire [31:0] MW_PC, MW_O, MW_D, MW_IR;
    wire MW_overflow;
    register MW_PC_reg(MW_PC, ~clock, XM_PC, enable_MW, reset);
    register MW_O_reg(MW_O, ~clock, XM_O, enable_MW, reset);
    register MW_D_reg(MW_D, ~clock, q_dmem, enable_MW, reset);
    register MW_IR_reg(MW_IR, ~clock, XM_IR, enable_MW, reset);
    dffe_ref MW_dffe_overflow(MW_overflow, XM_overflow, ~clock, enable_MW, reset);

    
    // ----- Writeback: Add the register to write to in regfile -----

    wire W_basic_r_type, W_r_type, W_i_type, W_ji_type, W_jii_type, W_addi, W_mul, W_div, W_sw, W_lw, W_j, W_bne, W_jal, W_jr, W_blt, W_bex, W_setx;
    wire W_regfile_wren, W_mem_wren, W_write_data_mem_to_regfile, W_immediate_inALUB;
    wire [4:0] W_alu_opcode, W_write_reg, W_write_reg_temp, W_write_reg_temp1, W_read_regA, W_read_regB, W_jr_read_reg;

    control CONTROL_W(MW_IR,
                    W_basic_r_type, W_r_type, W_i_type, W_ji_type, W_jii_type,
                    W_addi, W_mul, W_div, 
                    W_sw, W_lw, W_j, W_bne, W_jal, W_jr, W_blt, 
                    W_bex, W_setx, 
                    W_regfile_wren, 
                    W_write_reg_temp, W_read_regA, W_read_regB,
                    W_mem_wren, 
                    W_write_data_mem_to_regfile, 
                    W_alu_opcode,
                    W_immediate_inALUB,
                    W_jr_read_reg);

    wire [31:0] data_writeReg_temp1, data_writeReg_temp2;

    assign data_writeReg_temp1 = W_lw ? MW_D : MW_O;
    assign data_writeReg_temp2 = W_jal ? MW_PC : data_writeReg_temp1;
    assign data_writeReg = ready_to_write_multdiv_result ? final_multdiv_result : data_writeReg_temp2;

    assign ctrl_writeEnable = W_regfile_wren | ready_to_write_multdiv_result;
    assign W_write_reg_temp1 = ready_to_write_multdiv_result ? PW_write_reg : W_write_reg_temp;
    assign W_write_reg = MW_overflow ? 5'b11110 : W_write_reg_temp1;
    assign ctrl_writeReg = W_write_reg;


    // ----- PW Stage -----
    
    wire enable_PW;
    assign enable_PW = (X_mul | X_div);  // Latch when have a muldiv instruction in execute
    wire [31:0] PW_P, PW_IR, PW_A, PW_B;
    register PW_IR_reg(PW_IR, ~clock, DX_IR, enable_PW, reset);

    wire PW_basic_r_type, PW_r_type, PW_i_type, PW_ji_type, PW_jii_type, PW_addi, PW_mul, PW_div, PW_sw, PW_lw, PW_j, PW_bne, PW_jal, PW_jr, PW_blt, PW_bex, PW_setx;
    wire PW_regfile_wren, PW_mem_wren, PW_write_data_mem_to_regfile, PW_immediate_inALUB;
    wire [4:0] PW_alu_opcode, PW_write_reg, PW_write_reg_temp, PW_read_regA, PW_read_regB, PW_jr_read_reg;

    control CONTROL_PW(PW_IR,
                    PW_basic_r_type, PW_r_type, PW_i_type, PW_ji_type, PW_jii_type,
                    PW_addi, PW_mul, PW_div, 
                    PW_sw, PW_lw, PW_j, PW_bne, PW_jal, PW_jr, PW_blt, 
                    PW_bex, PW_setx, 
                    PW_regfile_wren, 
                    PW_write_reg_temp, PW_read_regA, PW_read_regB,
                    PW_mem_wren, 
                    PW_write_data_mem_to_regfile, 
                    PW_alu_opcode,
                    PW_immediate_inALUB,
                    PW_jr_read_reg);

    wire [31:0] multdiv_result;
    wire data_exception, data_resultRDY, ctrl_MULT, ctrl_DIV, multdiv_active, multdiv_active_test, PW_data_exception;
    multdiv MULTDIV(bypassed_A, bypassed_B, X_mul, X_div, clock, multdiv_result, data_exception, data_resultRDY);
    dffe_ref multdiv_active_dffe(multdiv_active, 1'b1, clock, X_mul || X_div, data_resultRDY || reset);  // Written to when X_mul or X_div is on, cleared when data is ready

    register PW_P_reg(PW_P, ~clock, multdiv_result, data_resultRDY, reset);
    dffe_ref multdiv_exception(PW_data_exception, data_exception, ~clock, data_resultRDY, reset);

    wire ready_to_write_multdiv_result;
    assign ready_to_write_multdiv_result = data_resultRDY;  // When ready to write multdiv result, disable all latches

    wire [31:0] final_multdiv_result, exception_status;
    assign PW_write_reg = PW_data_exception ? 5'b11110 : PW_write_reg_temp;
    assign exception_status = PW_div ? 32'b00000000000000000000000000000101 : 32'b00000000000000000000000000000100;
    assign final_multdiv_result = PW_data_exception ? exception_status : PW_P;

	/* END CODE */

endmodule
