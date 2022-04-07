module not_5bit(in, out);
    input [4:0] in;
    output [4:0] out;

    not NOT0(out[0], in[0]);
    not NOT1(out[1], in[1]);
    not NOT2(out[2], in[2]);
    not NOT3(out[3], in[3]);
    not NOT4(out[4], in[4]);

endmodule;