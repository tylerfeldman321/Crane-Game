module sll_4(data_out, data_in, shift);
    input [31:0] data_in;
    input shift;

    output [31:0] data_out;

    wire [31:0] shifted_data;

    assign shifted_data[3:0] = 0;
    assign shifted_data[31:4] = data_in[27:0];

    mux_2 pick_shifted_or_not(data_out, shift, data_in, shifted_data);

endmodule