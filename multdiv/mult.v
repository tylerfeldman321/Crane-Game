module mult(mult_result, mult_ready, mult_exception, clock, data_operandA, data_operandB, ctrl_MULT, count);
    input [31:0] data_operandA, data_operandB;
    input clock, ctrl_MULT;
    input [5:0] count;
    output mult_ready, mult_exception;
    output [31:0] mult_result;

    // Multiplicand is data_operandB, and multiplier is data_operandA
    // Multiplicand register
    wire [31:0] multiplicand;
    register multiplicand_reg(multiplicand, clock, data_operandA, ctrl_MULT, 1'b0);


    // Compute control bits
    wire shift_multiplicand, do_nothing;
    wire [4:0] ctrl_ALUopcode;
    multdiv_control MULTDIV_CONTROL(shift_multiplicand, do_nothing, ctrl_ALUopcode, clock, product[2:0]);


    // Compute what should go into product. Get new_product_calculated_shifted
    wire [31:0] multiplicand_potentially_shifted, alu_result, calculated_product_msb;
    wire isNotEqual, isLessThan, overflow;

    assign multiplicand_potentially_shifted = multiplicand << shift_multiplicand;
    alu ALU(.data_operandA(product[64:33]), .data_operandB(multiplicand_potentially_shifted), .ctrl_ALUopcode(ctrl_ALUopcode), .ctrl_shiftamt(5'b00000), .data_result(alu_result), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));
    
    assign calculated_product_msb = do_nothing ? product[64:33] : alu_result;

    wire [64:0] new_product_calculated, new_product_calculated_shifted;
    assign new_product_calculated = {calculated_product_msb, product[32:0]};

    assign new_product_calculated_shifted[64:63] = {new_product_calculated[64], new_product_calculated[64]};
    assign new_product_calculated_shifted[62:0] = new_product_calculated[64:2];


    // Get initial product and see if we should write this into the product register
    wire [64:0] initial_product;
    assign initial_product[64:33] = 32'b0;
    assign initial_product[32:1] = data_operandB;
    assign initial_product[0] = 0;

    wire write_initial_product;
    assign write_initial_product = ctrl_MULT;//~count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0];


    // Choose new product, either initial product or new calculated and shifted product
    wire [64:0] new_product;
    assign new_product = write_initial_product ? initial_product : new_product_calculated_shifted;

    wire [64:0] product;
    register_65bit product_reg(product, clock, new_product, 1'b1, 1'b0);


    // Assert data_resultRDY when have counter at 17, and assign result


    // Check for data_exception, which occurs if the highest 33 bits are not all the same
    wire all_33_msb_zero, all_33_msb_one;
    nor NOR_all_33_msb_zero(all_33_msb_zero, product[64], product[63], product[62], product[61], product[60], product[59], product[58], product[57], 
                                            product[56], product[55], product[54], product[53], product[52], product[51], product[50], product[49], 
                                            product[48], product[47], product[46], product[45], product[44], product[43], product[42], product[41], 
                                            product[40], product[39], product[38], product[37], product[36], product[35], product[34], product[33], product[32]);
    and and_all_33_msb_one(all_33_msb_one, product[64], product[63], product[62], product[61], product[60], product[59], product[58], product[57], 
                                            product[56], product[55], product[54], product[53], product[52], product[51], product[50], product[49], 
                                            product[48], product[47], product[46], product[45], product[44], product[43], product[42], product[41], 
                                            product[40], product[39], product[38], product[37], product[36], product[35], product[34], product[33], product[32]);

    wire invalid_signs, correct_sign_of_result, result_is_zero, result_is_not_zero;
    assign result_is_not_zero = (mult_result[31] | mult_result[30] | mult_result[29] | mult_result[28] | mult_result[27] | mult_result[26] | mult_result[25] | mult_result[24] | 
                                mult_result[23] | mult_result[22] | mult_result[21] | mult_result[20] | mult_result[19] | mult_result[18] | mult_result[17] | mult_result[31] | 
                                mult_result[15] | mult_result[14] | mult_result[13] | mult_result[12] | mult_result[11] | mult_result[10] | mult_result[9] | mult_result[8] | 
                                mult_result[7] | mult_result[6] | mult_result[5] | mult_result[4] | mult_result[3] | mult_result[2] | mult_result[1] | mult_result[0]);
    assign correct_sign_of_result = (data_operandA[31] ^ data_operandB[31]) & result_is_not_zero;
    assign invalid_signs = (correct_sign_of_result ^ mult_result[31]);
    assign mult_exception = ~(all_33_msb_zero + all_33_msb_one) | invalid_signs;

    assign mult_result = product[32:1];
    assign mult_ready = ~count[5] & count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0];

endmodule;
