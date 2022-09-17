module register_64bit(data_out, clk, data_in, write_enable, clr);
    input [63:0] data_in;
    input clk, write_enable, clr;
    output [63:0] data_out;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin: loop1
            dffe_ref dff(.q(data_out[i]), .d(data_in[i]), .clk(clk), .en(write_enable), .clr(clr));
        end
    endgenerate
endmodule;