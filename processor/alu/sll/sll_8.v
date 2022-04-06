module sll_8(data_out, data_in, shift);
    input [31:0] data_in;
    input shift;

    output [31:0] data_out;

    wire [31:0] shifted_data;

    assign shifted_data[7:0] = 0;
    assign shifted_data[31:8] = data_in[23:0];

    mux_2 pick_shifted_or_not(data_out, shift, data_in, shifted_data);

endmodule