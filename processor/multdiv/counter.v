module counter(count, clock, reset);
    // Will need 16-17 cycles
    input clock, reset;
    output [5:0] count;

    wire one;
    assign one = 1'b1;

    wire en;
    assign en = one;

    wire q0, q1, q2, q3, q4, q5;
    wire t0, t1, t2, t3, t4, t5;

    assign t0 = one;
    assign t1 = q0;
    and AND_t2(t2, q0, q1);
    and AND_t3(t3, q0, q1, q2);
    and AND_t4(t4, q0, q1, q2, q3);
    and AND_t5(t5, q0, q1, q2, q3, q4);

    tff TFF0(q0, t0, clock, en, reset);
    tff TFF1(q1, t1, clock, en, reset);
    tff TFF2(q2, t2, clock, en, reset);
    tff TFF3(q3, t3, clock, en, reset);
    tff TFF4(q4, t4, clock, en, reset);
    tff TFF5(q5, t5, clock, en, reset);

    assign count = {q5, q4, q3, q2, q1, q0};

endmodule