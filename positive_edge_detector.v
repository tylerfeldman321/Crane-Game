module positive_edge_detector(
    input signal,
    input clock,
    output positive_edge);

    reg signal_delay;

    always @(posedge clock) begin
        signal_delay <= signal;
    end

    assign positive_edge = signal & ~signal_delay

endmodule