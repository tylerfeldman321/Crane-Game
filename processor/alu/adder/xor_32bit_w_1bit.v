module xor_32bit_w_1bit(data_in, data_in1bit, data_out);
    input [31:0] data_in;
    input data_in1bit;
    output [31:0] data_out;

    xor XOR0(data_out[0], data_in[0], data_in1bit);
    xor XOR1(data_out[1], data_in[1], data_in1bit);
    xor XOR2(data_out[2], data_in[2], data_in1bit);
    xor XOR3(data_out[3], data_in[3], data_in1bit);
    xor XOR4(data_out[4], data_in[4], data_in1bit);
    xor XOR5(data_out[5], data_in[5], data_in1bit);
    xor XOR6(data_out[6], data_in[6], data_in1bit);
    xor XOR7(data_out[7], data_in[7], data_in1bit);
    xor XOR8(data_out[8], data_in[8], data_in1bit);
    xor XOR9(data_out[9], data_in[9], data_in1bit);
    xor XOR10(data_out[10], data_in[10], data_in1bit);
    xor XOR11(data_out[11], data_in[11], data_in1bit);
    xor XOR12(data_out[12], data_in[12], data_in1bit);
    xor XOR13(data_out[13], data_in[13], data_in1bit);
    xor XOR14(data_out[14], data_in[14], data_in1bit);
    xor XOR15(data_out[15], data_in[15], data_in1bit);
    xor XOR16(data_out[16], data_in[16], data_in1bit);
    xor XOR17(data_out[17], data_in[17], data_in1bit);
    xor XOR18(data_out[18], data_in[18], data_in1bit);
    xor XOR19(data_out[19], data_in[19], data_in1bit);
    xor XOR20(data_out[20], data_in[20], data_in1bit);
    xor XOR21(data_out[21], data_in[21], data_in1bit);
    xor XOR22(data_out[22], data_in[22], data_in1bit);
    xor XOR23(data_out[23], data_in[23], data_in1bit);
    xor XOR24(data_out[24], data_in[24], data_in1bit);
    xor XOR25(data_out[25], data_in[25], data_in1bit);
    xor XOR26(data_out[26], data_in[26], data_in1bit);
    xor XOR27(data_out[27], data_in[27], data_in1bit);
    xor XOR28(data_out[28], data_in[28], data_in1bit);
    xor XOR29(data_out[29], data_in[29], data_in1bit);
    xor XOR30(data_out[30], data_in[30], data_in1bit);
    xor XOR31(data_out[31], data_in[31], data_in1bit);

endmodule