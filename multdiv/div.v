module div(div_result, div_ready, div_exception, clock, data_operandA, data_operandB, ctrl_DIV, count);
    input [31:0] data_operandA, data_operandB;
    input clock, ctrl_DIV;
    input [5:0] count;
    output div_ready, div_exception;
    output [31:0] div_result;


    // Divisor is data_operandB, and dividend is data_operandA
    wire need_to_negative_result;
    xor XOR_need_to_negative_result(need_to_negative_result, data_operandA[31], data_operandB[31]);

    wire [31:0] divisor, positive_divisor;
    negate_32bit make_divisor_positive(positive_divisor, data_operandB, data_operandB[31]);
    register divisor_reg(divisor, clock, positive_divisor, 1'b1, 1'b0);

    wire [63:0] initial_AQ, new_AQ, AQ, AQ_shifted, new_computed_AQ;
    wire [31:0] positive_dividend;
    negate_32bit make_dividend_positive(positive_dividend, data_operandA, data_operandA[31]);
    assign initial_AQ = {32'b0, positive_dividend};

    assign new_AQ = ctrl_DIV ? initial_AQ : new_computed_AQ;

    register_64bit AQ_reg(AQ, clock, new_AQ, 1'b1, 1'b0);


    wire A_sign_bit;
    assign A_sign_bit = AQ[63];

    assign AQ_shifted = AQ << 1;

    wire [4:0] alu_operand;
    assign alu_operand = A_sign_bit ? 5'b00000 : 5'b00001;

    wire [31:0] new_A;
    wire isNotEqual, overflow, isLessThan;
    alu ALU_div(.data_operandA(AQ_shifted[63:32]), .data_operandB(divisor), .ctrl_ALUopcode(alu_operand), .ctrl_shiftamt(5'b00000), .data_result(new_A), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));

    assign new_computed_AQ = {new_A, AQ_shifted[31:1], ~new_A[31]};


    assign div_ready = count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0];

    wire [31:0] div_result_correct_sign;
    negate_32bit correct_sign_of_result(div_result_correct_sign, AQ[31:0], need_to_negative_result);
    assign div_result = div_exception ? 32'b0 : div_result_correct_sign;
    wire divide_by_zero;

    assign divide_by_zero = ~(data_operandB[31] | data_operandB[30] | data_operandB[29] | data_operandB[28] | data_operandB[27] | data_operandB[26]
                            | data_operandB[25] | data_operandB[24] | data_operandB[23] | data_operandB[22] | data_operandB[21] | data_operandB[20]
                            | data_operandB[19] | data_operandB[18] | data_operandB[17] | data_operandB[16] | data_operandB[15] | data_operandB[14]
                            | data_operandB[13] | data_operandB[12] | data_operandB[11] | data_operandB[10] | data_operandB[9] | data_operandB[8]
                            | data_operandB[7] | data_operandB[6] | data_operandB[5] | data_operandB[4] | data_operandB[3] | data_operandB[2]
                            | data_operandB[1] | data_operandB[0]);

    assign div_exception = divide_by_zero;

    // Not needed if not returning remainder
    // wire [63:0] final_AQ, final_A_plus_M, final_A;
    // alu ALU_div_final(.data_operandA(A), .data_operandB(divisor), .ctrl_ALUopcode(5'b00000), .ctrl_shiftamt(ctrl_shiftamt), .data_result(final_A_plus_M), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));
    // assign final_A = A_sign_bit ? final_A_plus_M : A;
    // assign final_AQ = {final_A, AQ[31:0]};

endmodule;