module sra_4(data_out, data_in, shift);
    input [31:0] data_in;
    input shift;

    output [31:0] data_out;

    wire [31:0] shifted_data;

    assign shifted_data[31:28] = {data_in[31], data_in[31], data_in[31], data_in[31]};
    assign shifted_data[27:0] = data_in[31:4];

    mux_2 pick_shifted_or_not(data_out, shift, data_in, shifted_data);

endmodule