module sra_barrel_shifter(data_in, ctrl_shiftamt, data_out);
    input [31:0] data_in;
    input [4:0] ctrl_shiftamt;

    output [31:0] data_out;

    wire [31:0] shift_1_out;
    wire [31:0] shift_2_out;
    wire [31:0] shift_4_out;
    wire [31:0] shift_8_out;

    sra_1 shift_1(shift_1_out, data_in, ctrl_shiftamt[0]);
    sra_2 shift_2(shift_2_out, shift_1_out, ctrl_shiftamt[1]);
    sra_4 shift_4(shift_4_out, shift_2_out, ctrl_shiftamt[2]);
    sra_8 shift_8(shift_8_out, shift_4_out, ctrl_shiftamt[3]);
    sra_16 shift_16(data_out, shift_8_out, ctrl_shiftamt[4]);

endmodule