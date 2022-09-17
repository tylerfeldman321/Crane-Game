module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:

    wire [31:0] sll_result, sra_result, adder_result, and_result, or_result;
    sll_barrel_shifter sll_shifter(data_operandA, ctrl_shiftamt, sll_result);
    sra_barrel_shifter sra_shifter(data_operandA, ctrl_shiftamt, sra_result);

    wire four_msb_zero, sub;
    nor NOR_four_msb_zero(four_msb_zero, ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1]);
    and AND_sub(sub, four_msb_zero, ctrl_ALUopcode[0]);

    carry_lookahead_adder cla(data_operandA, data_operandB, sub, adder_result, and_result, or_result, isNotEqual, isLessThan, overflow);

    mux_8 select_output(data_result, ctrl_ALUopcode[2:0], adder_result, adder_result, and_result, or_result, sll_result, sra_result, adder_result, adder_result);

endmodule