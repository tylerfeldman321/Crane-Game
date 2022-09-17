module tristate_buffer_32bit(out, in, output_enable);
    input [31:0] in;
    input output_enable;
    output [31:0] out;

    assign out = output_enable ? in : 32'bz;

endmodule