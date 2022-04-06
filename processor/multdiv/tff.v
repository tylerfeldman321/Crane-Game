module tff(q, t, clk, en, clr);

    output q;
    input t, clk, en, clr;

    wire t_not, q_not;
    not TNOT(t_not, t);
    not QNOT(q_not, q);

    wire t_not_and_q, t_and_q_not, d;
    and AND1(t_not_and_q, t_not, q);
    and AND2(t_and_q_not, t, q_not);
    or OR(d, t_not_and_q, t_and_q_not);

    dffe_ref dff(q, d, clk, en, clr);
endmodule