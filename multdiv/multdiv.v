module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;


    // Keeping track of which operation is occuring
    wire operation_is_div;  // 0 if mult, 1 if div
    wire operation_write_enable;
    wire operation_in;
    assign operation_in = ctrl_DIV;
    assign operation_write_enable = ctrl_MULT | ctrl_DIV;  // Write when ctrl_MULT or ctrl_DIV is true
    dffe_ref dff_operation(.q(operation_is_div), .d(operation_in), .clk(clock), .en(operation_write_enable), .clr(1'b0));


    // Counter
    wire [5:0] count;
    counter COUNTER(count, clock, ctrl_MULT | ctrl_DIV);

    wire max_count, count_overflowed;
    assign max_count = (count[5] & count[4] & count[3] & count[2] & count[1] & count[0]);
    dffe_ref dff_max_count(.q(count_overflowed), .d(1'b1), .clk(clock), .en(max_count), .clr(ctrl_MULT | ctrl_DIV));


    // ----------- Division -----------
    wire [31:0] quotient;
    wire div_ready, div_exception;
    div divider(quotient, div_ready, div_exception, clock, data_operandA, data_operandB, ctrl_DIV, count);

    // ----------- Multiplication -----------
    wire [31:0] mult_result;
    wire mult_ready, mult_exception;
    mult MULT(mult_result, mult_ready, mult_exception, clock, data_operandA, data_operandB, ctrl_MULT, count);

    
    assign data_resultRDY = (mult_ready & ~operation_is_div) | (div_ready & operation_is_div) & ~count_overflowed;
    
    assign data_result = operation_is_div ? quotient : mult_result;

    assign data_exception = (mult_exception & ~operation_is_div) | (div_exception & operation_is_div);

endmodule