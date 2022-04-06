module negate_32bit(out, in, negate);
    input [31:0] in;
    input negate;
    output [31:0] out;

    wire isNotEqual, isLessThan, overflow;
    wire [31:0] in_flipped, one, negative_in;
    assign in_flipped = ~in;

    assign one = 32'b00000000000000000000000000000001;
    
    alu ALU_div(.data_operandA(in_flipped), .data_operandB(one), .ctrl_ALUopcode(5'b00000), .ctrl_shiftamt(5'b00000), .data_result(negative_in), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));

    assign out = negate ? negative_in : in;

endmodule;