module cla_8_bit_block(sum, G, P, and_8bit, or_8bit, overflow_8bit, a, b, c0);
    input [7:0] a, b;
    input c0;

    output [7:0] sum, and_8bit, or_8bit;
    output overflow_8bit, G, P;
    wire cout;

    wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire p0, p1, p2, p3, p4, p5, p6, p7;

    and ANDg0(g0, a[0], b[0]);
    and ANDg1(g1, a[1], b[1]);
    and ANDg2(g2, a[2], b[2]);
    and ANDg3(g3, a[3], b[3]);
    and ANDg4(g4, a[4], b[4]);
    and ANDg5(g5, a[5], b[5]);
    and ANDg6(g6, a[6], b[6]);
    and ANDg7(g7, a[7], b[7]);
    assign and_8bit = {g7, g6, g5, g4, g3, g2, g1, g0};

    or ORp0(p0, a[0], b[0]);
    or ORp1(p1, a[1], b[1]);
    or ORp2(p2, a[2], b[2]);
    or ORp3(p3, a[3], b[3]);
    or ORp4(p4, a[4], b[4]);
    or ORp5(p5, a[5], b[5]);
    or ORp6(p6, a[6], b[6]);
    or ORp7(p7, a[7], b[7]);
    assign or_8bit = {p7, p6, p5, p4, p3, p2, p1, p0};

    wire c1, c2, c3, c4, c5, c6, c7;
    wire c0_and_p0, c1_and_p1, c2_and_p2, c3_and_p3, c4_and_p4, c5_and_p5, c6_and_p6, c7_and_p7;

    // Find c1
    wire p0_c0;
    and AND_p0_c0(p0_c0, p0, c0);
    or OR_c1(c1, g0, p0_c0);

    // Find c2
    wire p1_g0, p1_p0_c0;
    and AND_p1_g0(p1_g0, p1, g0);
    and AND_p1_p0_c0(p1_p0_c0, p1, p0, c0);
    or OR_c2(c2, g1, p1_g0, p1_p0_c0);

    // Find c3
    wire p2_g1, p2_p1_g0, p2_p1_p0_c0;
    and AND_p2_g1(p2_g1, p2, g1);
    and AND_p2_p1_g0(p2_p1_g0, p2, p1, g0);
    and AND_p2_p1_p0_c0(p2_p1_p0_c0, p2, p1, p0, c0);
    or OR_c3(c3, g2, p2_g1, p2_p1_g0, p2_p1_p0_c0);

    // Find c4
    wire p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_c0;
    and AND_p3_g2(p3_g2, p3, g2);
    and AND_p3_p2_g1(p3_p2_g1, p3, p2, g1);
    and AND_p3_p2_p1_g0(p3_p2_p1_g0, p3, p2, p1, g0);
    and AND_p3_p2_p1_p0_c0(p3_p2_p1_p0_c0, p3, p2, p1, p0, c0);
    or OR_c4(c4, g3, p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_c0);

    // Find c5
    wire p4_g3, p4_p3_g2, p4_p3_p2_g1, p4_p3_p2_p1_g0, p4_p3_p2_p1_p0_c0;
    and AND_p4_g3(p4_g3, p4, g3);
    and AND_p4_p3_g2(p4_p3_g2, p4, p3, g2);
    and AND_p4_p3_p2_g1(p4_p3_p2_g1, p4, p3, p2, g1);
    and AND_p4_p3_p2_p1_g0(p4_p3_p2_p1_g0, p4, p3, p2, p1, g0);
    and AND_p4_p3_p2_p1_p0_c0(p4_p3_p2_p1_p0_c0, p4, p3, p2, p1, p0, c0);
    or OR_c5(c5, g4, p4_g3, p4_p3_g2, p4_p3_p2_g1, p4_p3_p2_p1_g0, p4_p3_p2_p1_p0_c0);

    // Find c6
    wire p5_g4, p5_p4_g3, p5_p4_p3_g2, p5_p4_p3_p2_g1, p5_p4_p3_p2_p1_g0, p5_p4_p3_p2_p1_p0_c0;
    and AND_p5_g4(p5_g4, p5, g4);
    and AND_p5_p4_g3(p5_p4_g3, p5, p4, g3);
    and AND_p5_p4_p3_g2(p5_p4_p3_g2, p5, p4, p3, g2);
    and AND_p5_p4_p3_p2_g1(p5_p4_p3_p2_g1, p5, p4, p3, p2, g1);
    and AND_p5_p4_p3_p2_p1_g0(p5_p4_p3_p2_p1_g0, p5, p4, p3, p2, p1, g0);
    and AND_p5_p4_p3_p2_p1_p0_c0(p5_p4_p3_p2_p1_p0_c0, p5, p4, p3, p2, p1, p0, c0);
    or OR_c6(c6, g5, p5_g4, p5_p4_g3, p5_p4_p3_g2, p5_p4_p3_p2_g1, p5_p4_p3_p2_p1_g0, p5_p4_p3_p2_p1_p0_c0);

    // Find c7
    wire p6_g5, p6_p5_g4, p6_p5_p4_g3, p6_p5_p4_p3_g2, p6_p5_p4_p3_p2_g1, p6_p5_p4_p3_p2_p1_g0, p6_p5_p4_p3_p2_p1_p0_c0;
    and AND_p6_g5(p6_g5, p6, g5);
    and AND_p6_p5_g4(p6_p5_g4, p6, p5, g4);
    and AND_p6_p5_p4_g3(p6_p5_p4_g3, p6, p5, p4, g3);
    and AND_p6_p5_p4_p3_g2(p6_p5_p4_p3_g2, p6, p5, p4, p3, g2);
    and AND_p6_p5_p4_p3_p2_g1(p6_p5_p4_p3_p2_g1, p6, p5, p4, p3, p2, g1);
    and AND_p6_p5_p4_p3_p2_p1_g0(p6_p5_p4_p3_p2_p1_g0, p6, p5, p4, p3, p2, p1, g0);
    and AND_p6_p5_p4_p3_p2_p1_p0_c0(p6_p5_p4_p3_p2_p1_p0_c0, p6, p5, p4, p3, p2, p1, p0, c0);
    or OR_c7(c7, g6, p6_g5, p6_p5_g4, p6_p5_p4_g3, p6_p5_p4_p3_g2, p6_p5_p4_p3_p2_g1, p6_p5_p4_p3_p2_p1_g0, p6_p5_p4_p3_p2_p1_p0_c0);

    full_adder_sum s0(sum[0], a[0], b[0], c0);
    full_adder_sum s1(sum[1], a[1], b[1], c1);
    full_adder_sum s2(sum[2], a[2], b[2], c2);
    full_adder_sum s3(sum[3], a[3], b[3], c3);
    full_adder_sum s4(sum[4], a[4], b[4], c4);
    full_adder_sum s5(sum[5], a[5], b[5], c5);
    full_adder_sum s6(sum[6], a[6], b[6], c6);
    full_adder_sum s7(sum[7], a[7], b[7], c7);

    xor(overflow_8bit, c7, cout);

    and AND_P(P, p0, p1, p2, p3, p4, p5, p6, p7);

    wire p7_g6, p7_p6_g5, p7_p6_p5_g4, p7_p6_p5_p4_g3, p7_p6_p5_p4_p3_g2, p7_p6_p5_p4_p3_p2_g1, p7_p6_p5_p4_p3_p2_p1_g0;
    and AND_p7_g6(p7_g6, p7, g6);
    and AND_p7_p6_g5(p7_p6_g5, p7, p6, g5);
    and AND_p7_p6_p5_g4(p7_p6_p5_g4, p7, p6, p5, g4);
    and AND_p7_p6_p5_p4_g3(p7_p6_p5_p4_g3, p7, p6, p5, p4, g3);
    and AND_p7_p6_p5_p4_p3_g2(p7_p6_p5_p4_p3_g2, p7, p6, p5, p4, p3, g2);
    and AND_p7_p6_p5_p4_p3_p2_g1(p7_p6_p5_p4_p3_p2_g1, p7, p6, p5, p4, p3, p2, g1);
    and AND_p7_p6_p5_p4_p3_p2_p1_g0(p7_p6_p5_p4_p3_p2_p1_g0, p7, p6, p5, p4, p3, p2, p1, g0);
    or OR_G(G, g7, p7_g6, p7_p6_g5, p7_p6_p5_g4, p7_p6_p5_p4_g3, p7_p6_p5_p4_p3_g2, p7_p6_p5_p4_p3_p2_g1, p7_p6_p5_p4_p3_p2_p1_g0);

    // Find cout
    wire p7_p6_p5_p4_p3_p2_p1_p0_c0;
    and AND_p7_p6_p5_p4_p3_p2_p1_p0_c0(p7_p6_p5_p4_p3_p2_p1_p0_c0, p7, p6, p5, p4, p3, p2, p1, p0, c0);
    or OR_cout(cout, g7, p7_g6, p7_p6_g5, p7_p6_p5_g4, p7_p6_p5_p4_g3, p7_p6_p5_p4_p3_g2, p7_p6_p5_p4_p3_p2_g1, p7_p6_p5_p4_p3_p2_p1_g0, p7_p6_p5_p4_p3_p2_p1_p0_c0);

endmodule