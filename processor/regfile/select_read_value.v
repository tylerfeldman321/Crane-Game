module select_read_value(data_out, select, data_reg0, data_reg1, data_reg2, data_reg3, data_reg4, data_reg5, data_reg6, data_reg7, data_reg8, data_reg9, data_reg10, data_reg11, data_reg12, data_reg13,
        data_reg14, data_reg15, data_reg16, data_reg17, data_reg18, data_reg19, data_reg20, data_reg21, data_reg22, data_reg23, data_reg24, data_reg25, data_reg26, data_reg27,
        data_reg28, data_reg29, data_reg30, data_reg31);
    input [4:0] select;
    input [31:0] data_reg0, data_reg1, data_reg2, data_reg3, data_reg4, data_reg5, data_reg6, data_reg7, data_reg8, data_reg9, data_reg10, data_reg11, data_reg12, data_reg13,
        data_reg14, data_reg15, data_reg16, data_reg17, data_reg18, data_reg19, data_reg20, data_reg21, data_reg22, data_reg23, data_reg24, data_reg25, data_reg26, data_reg27,
        data_reg28, data_reg29, data_reg30, data_reg31;
    output [31:0] data_out;

    wire [31:0] select_onehot;
    decoder_5_to_32 decoder(select_onehot, select);

    tristate_buffer_32bit buffer0(.out(data_out), .in(data_reg0), .output_enable(select_onehot[0]));
    tristate_buffer_32bit buffer1(.out(data_out), .in(data_reg1), .output_enable(select_onehot[1]));
    tristate_buffer_32bit buffer2(.out(data_out), .in(data_reg2), .output_enable(select_onehot[2]));
    tristate_buffer_32bit buffer3(.out(data_out), .in(data_reg3), .output_enable(select_onehot[3]));
    tristate_buffer_32bit buffer4(.out(data_out), .in(data_reg4), .output_enable(select_onehot[4]));
    tristate_buffer_32bit buffer5(.out(data_out), .in(data_reg5), .output_enable(select_onehot[5]));
    tristate_buffer_32bit buffer6(.out(data_out), .in(data_reg6), .output_enable(select_onehot[6]));
    tristate_buffer_32bit buffer7(.out(data_out), .in(data_reg7), .output_enable(select_onehot[7]));
    tristate_buffer_32bit buffer8(.out(data_out), .in(data_reg8), .output_enable(select_onehot[8]));
    tristate_buffer_32bit buffer9(.out(data_out), .in(data_reg9), .output_enable(select_onehot[9]));
    tristate_buffer_32bit buffer10(.out(data_out), .in(data_reg10), .output_enable(select_onehot[10]));
    tristate_buffer_32bit buffer11(.out(data_out), .in(data_reg11), .output_enable(select_onehot[11]));
    tristate_buffer_32bit buffer12(.out(data_out), .in(data_reg12), .output_enable(select_onehot[12]));
    tristate_buffer_32bit buffer13(.out(data_out), .in(data_reg13), .output_enable(select_onehot[13]));
    tristate_buffer_32bit buffer14(.out(data_out), .in(data_reg14), .output_enable(select_onehot[14]));
    tristate_buffer_32bit buffer15(.out(data_out), .in(data_reg15), .output_enable(select_onehot[15]));
    tristate_buffer_32bit buffer16(.out(data_out), .in(data_reg16), .output_enable(select_onehot[16]));
    tristate_buffer_32bit buffer17(.out(data_out), .in(data_reg17), .output_enable(select_onehot[17]));
    tristate_buffer_32bit buffer18(.out(data_out), .in(data_reg18), .output_enable(select_onehot[18]));
    tristate_buffer_32bit buffer19(.out(data_out), .in(data_reg19), .output_enable(select_onehot[19]));
    tristate_buffer_32bit buffer20(.out(data_out), .in(data_reg20), .output_enable(select_onehot[20]));
    tristate_buffer_32bit buffer21(.out(data_out), .in(data_reg21), .output_enable(select_onehot[21]));
    tristate_buffer_32bit buffer22(.out(data_out), .in(data_reg22), .output_enable(select_onehot[22]));
    tristate_buffer_32bit buffer23(.out(data_out), .in(data_reg23), .output_enable(select_onehot[23]));
    tristate_buffer_32bit buffer24(.out(data_out), .in(data_reg24), .output_enable(select_onehot[24]));
    tristate_buffer_32bit buffer25(.out(data_out), .in(data_reg25), .output_enable(select_onehot[25]));
    tristate_buffer_32bit buffer26(.out(data_out), .in(data_reg26), .output_enable(select_onehot[26]));
    tristate_buffer_32bit buffer27(.out(data_out), .in(data_reg27), .output_enable(select_onehot[27]));
    tristate_buffer_32bit buffer28(.out(data_out), .in(data_reg28), .output_enable(select_onehot[28]));
    tristate_buffer_32bit buffer29(.out(data_out), .in(data_reg29), .output_enable(select_onehot[29]));
    tristate_buffer_32bit buffer30(.out(data_out), .in(data_reg30), .output_enable(select_onehot[30]));
    tristate_buffer_32bit buffer31(.out(data_out), .in(data_reg31), .output_enable(select_onehot[31]));

endmodule