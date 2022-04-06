module multdiv_control(shift_multiplicand, do_nothing, ctrl_ALUopcode, clock, current_three_bits);
    output shift_multiplicand, do_nothing;
    output [4:0] ctrl_ALUopcode;
    input clock;
    input [2:0] current_three_bits;

    wire sub;

    assign do_nothing = (~current_three_bits[2] & ~current_three_bits[1] & ~current_three_bits[0])   // 000
                            | (current_three_bits[2] & current_three_bits[1] & current_three_bits[0]);  // 111

    assign shift_multiplicand = (current_three_bits[2] & ~current_three_bits[1] & ~current_three_bits[0])  // 100
                            | (~current_three_bits[2] & current_three_bits[1] & current_three_bits[0]);    // 011

    assign sub = (current_three_bits[2] & ~current_three_bits[1] & ~current_three_bits[0])       // 100
                    | (current_three_bits[2] & current_three_bits[1] & ~current_three_bits[0])   // 110
                    | (current_three_bits[2] & ~current_three_bits[1] & current_three_bits[0]);  // 101

    assign ctrl_ALUopcode = sub ? 5'b00001 : 5'b00000;
    
endmodule