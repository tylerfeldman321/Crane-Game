module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	score, time_left
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;
	
	output [31:0] score, time_left;
	assign score = data_reg3;
	assign time_left = data_reg4;

	// add your code here

	// Constants
	wire one, zero;
	assign zero = 1'b0;
	assign one = 1'b1;

	// Write enable for each register by decoding ctrl_writeReg and then anding it with  ctrl_writeEnable
	wire [31:0] ctrl_writeReg_onehot, write_enable_onehot;
	decoder_5_to_32 decoder_writeReg(ctrl_writeReg_onehot, ctrl_writeReg);
	and_32bit_w_1bit writeReg_and_enable(write_enable_onehot, ctrl_writeReg_onehot, ctrl_writeEnable);


	wire [31:0] data_reg0, data_reg1, data_reg2, data_reg3, data_reg4, data_reg5, data_reg6, data_reg7, data_reg8, data_reg9, data_reg10, data_reg11, data_reg12, data_reg13,
		data_reg14, data_reg15, data_reg16, data_reg17, data_reg18, data_reg19, data_reg20, data_reg21, data_reg22, data_reg23, data_reg24, data_reg25, data_reg26, data_reg27,
		data_reg28, data_reg29, data_reg30, data_reg31;

	// 32 32-bit registers
	register register0(data_reg0, clock, data_writeReg, zero, ctrl_reset);
	register register1(data_reg1, clock, data_writeReg, write_enable_onehot[1], ctrl_reset);
	register register2(data_reg2, clock, data_writeReg, write_enable_onehot[2], ctrl_reset);
	register register3(data_reg3, clock, data_writeReg, write_enable_onehot[3], ctrl_reset);
	register register4(data_reg4, clock, data_writeReg, write_enable_onehot[4], ctrl_reset);
	register register5(data_reg5, clock, data_writeReg, write_enable_onehot[5], ctrl_reset);
	register register6(data_reg6, clock, data_writeReg, write_enable_onehot[6], ctrl_reset);
	register register7(data_reg7, clock, data_writeReg, write_enable_onehot[7], ctrl_reset);
	register register8(data_reg8, clock, data_writeReg, write_enable_onehot[8], ctrl_reset);
	register register9(data_reg9, clock, data_writeReg, write_enable_onehot[9], ctrl_reset);
	register register10(data_reg10, clock, data_writeReg, write_enable_onehot[10], ctrl_reset);
	register register11(data_reg11, clock, data_writeReg, write_enable_onehot[11], ctrl_reset);
	register register12(data_reg12, clock, data_writeReg, write_enable_onehot[12], ctrl_reset);
	register register13(data_reg13, clock, data_writeReg, write_enable_onehot[13], ctrl_reset);
	register register14(data_reg14, clock, data_writeReg, write_enable_onehot[14], ctrl_reset);
	register register15(data_reg15, clock, data_writeReg, write_enable_onehot[15], ctrl_reset);
	register register16(data_reg16, clock, data_writeReg, write_enable_onehot[16], ctrl_reset);
	register register17(data_reg17, clock, data_writeReg, write_enable_onehot[17], ctrl_reset);
	register register18(data_reg18, clock, data_writeReg, write_enable_onehot[18], ctrl_reset);
	register register19(data_reg19, clock, data_writeReg, write_enable_onehot[19], ctrl_reset);
	register register20(data_reg20, clock, data_writeReg, write_enable_onehot[20], ctrl_reset);
	register register21(data_reg21, clock, data_writeReg, write_enable_onehot[21], ctrl_reset);
	register register22(data_reg22, clock, data_writeReg, write_enable_onehot[22], ctrl_reset);
	register register23(data_reg23, clock, data_writeReg, write_enable_onehot[23], ctrl_reset);
	register register24(data_reg24, clock, data_writeReg, write_enable_onehot[24], ctrl_reset);
	register register25(data_reg25, clock, data_writeReg, write_enable_onehot[25], ctrl_reset);
	register register26(data_reg26, clock, data_writeReg, write_enable_onehot[26], ctrl_reset);
	register register27(data_reg27, clock, data_writeReg, write_enable_onehot[27], ctrl_reset);
	register register28(data_reg28, clock, data_writeReg, write_enable_onehot[28], ctrl_reset);
	register register29(data_reg29, clock, data_writeReg, write_enable_onehot[29], ctrl_reset);
	register register30(data_reg30, clock, data_writeReg, write_enable_onehot[30], ctrl_reset);
	register register31(data_reg31, clock, data_writeReg, write_enable_onehot[31], ctrl_reset);

	select_read_value select_readA(data_readRegA, ctrl_readRegA, data_reg0, data_reg1, data_reg2, data_reg3, data_reg4, data_reg5, data_reg6, data_reg7, data_reg8, data_reg9, data_reg10, data_reg11, data_reg12, data_reg13,
        data_reg14, data_reg15, data_reg16, data_reg17, data_reg18, data_reg19, data_reg20, data_reg21, data_reg22, data_reg23, data_reg24, data_reg25, data_reg26, data_reg27,
        data_reg28, data_reg29, data_reg30, data_reg31);
	select_read_value select_readB(data_readRegB, ctrl_readRegB, data_reg0, data_reg1, data_reg2, data_reg3, data_reg4, data_reg5, data_reg6, data_reg7, data_reg8, data_reg9, data_reg10, data_reg11, data_reg12, data_reg13,
        data_reg14, data_reg15, data_reg16, data_reg17, data_reg18, data_reg19, data_reg20, data_reg21, data_reg22, data_reg23, data_reg24, data_reg25, data_reg26, data_reg27,
        data_reg28, data_reg29, data_reg30, data_reg31);

endmodule
