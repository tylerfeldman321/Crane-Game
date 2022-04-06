module carry_lookahead_adder(data_operandA, data_operandB, subtraction, adder_result, and_result, or_result, isNotEqual, isLessThan, overflow);
    input [31:0] data_operandA, data_operandB;
    input subtraction; // 0 if addition, 1 if subtraction

    output [31:0] adder_result, and_result, or_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] data_B;
    xor_32bit_w_1bit XOR_negate_input_if_subtraction(data_operandB, subtraction, data_B);

    wire overflow0, overflow1, overflow2;

    wire [31:0] p, g;
    assign and_result = g;
    assign or_result = p;

    wire P0, P1, P2, P3;
    wire G0, G1, G2, G3;

    wire c0, c8, c16, c24, c32;
    assign c0 = subtraction;

    wire P0_c0;
    and AND_P0_c0(P0_c0, P0, c0);
    or OR_c8(c8, G0, P0_c0);

    wire P1_G0, P1_P0_c0;
    and AND_P1_G0(P1_G0, P1, G0);
    and AND_P1_P0_c0(P1_P0_c0, P1, P0, c0);
    or OR_c16(c16, G1, P1_G0, P1_P0_c0);

    wire P2_G1, P2_P1_G0, P2_P1_P0_c0;
    and AND_P2_G1(P2_G1, P2, G1);
    and AND_P2_P1_G0(P2_P1_G0, P2, P1, G0);
    and AND_P2_P1_P0_c0(P2_P1_P0_c0, P2, P1, P0, c0);
    or OR_c24(c24, G2, P2_G1, P2_P1_G0, P2_P1_P0_c0);

    wire P3_G2, P3_P2_G1, P3_P2_P1_G0, P3_P2_P1_P0_c0;
    and AND_P3_G2(P3_G2, P3, G2);
    and AND_P3_P2_G1(P3_P2_G1, P3, P2, G1);
    and AND_P3_P2_P1_G0(P3_P2_P1_G0, P3, P2, P1, G0);
    and AND_P3_P2_P1_P0_c0(P3_P2_P1_P0_c0, P3, P2, P1, P0, c0);
    or OR_c32(c32, G3, P3_G2, P3_P2_G1, P3_P2_P1_G0, P3_P2_P1_P0_c0);

    cla_8_bit_block cla_block0(adder_result[7:0], G0, P0, g[7:0], p[7:0], overflow0, data_operandA[7:0], data_B[7:0], c0);
    cla_8_bit_block cla_block1(adder_result[15:8], G1, P1, g[15:8], p[15:8], overflow1, data_operandA[15:8], data_B[15:8], c8);
    cla_8_bit_block cla_block2(adder_result[23:16], G2, P2, g[23:16], p[23:16], overflow2, data_operandA[23:16], data_B[23:16], c16);
    cla_8_bit_block cla_block3(adder_result[31:24], G3, P3, g[31:24], p[31:24], overflow, data_operandA[31:24], data_B[31:24], c24);

    // Only needs to be correct when doing subtraction. If subtraction, A < B if A - B is negative
    wire a_positive, b_positive, a_negative_and_b_positive, not_a_positive_and_b_negative, result_negative_or_a_negative_and_b_positive;
    not NOT_a_positive(a_positive, data_operandA[31]);
    not NOT_b_positive(b_positive, data_operandB[31]);
    and AND_a_negative_and_b_positive(a_negative_and_b_positive, data_operandA[31], b_positive);
    nand NAND_a_positive_and_b_negative(not_a_positive_and_b_negative, a_positive, data_operandB[31]);
    or OR_result_negative_or_a_negative_and_b_positive(result_negative_or_a_negative_and_b_positive, a_negative_and_b_positive, adder_result[31]);
    and AND_isLessThan(isLessThan, result_negative_or_a_negative_and_b_positive, not_a_positive_and_b_negative);
    
    or not_equal(isNotEqual, adder_result[31], adder_result[30], adder_result[29], adder_result[28], adder_result[27], adder_result[26], adder_result[25], adder_result[24], adder_result[23], adder_result[22], adder_result[21],
    adder_result[20], adder_result[19], adder_result[18], adder_result[17], adder_result[16], adder_result[15], adder_result[14], adder_result[13], adder_result[12], adder_result[11], adder_result[10], adder_result[9], 
    adder_result[8], adder_result[7], adder_result[6], adder_result[5], adder_result[4], adder_result[3], adder_result[2], adder_result[1], adder_result[0]);

endmodule