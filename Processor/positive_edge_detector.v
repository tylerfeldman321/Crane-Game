module positive_edge_detector (
    input sig,           
    input clk,            
    input res,            
    output pe
);          
    reg out;
    reg sig_dly;                         

    wire dff1_out, dff2_out;
    dffe_ref DFF1(dff1_out, sig, clk, 1'b1, res);  //q, d, clk, en, clr

    dffe_ref DFF2(dff2_out, dff1_out, clk, 1'b1, res);

    assign pe = dff1_out & ~dff2_out;

endmodule 