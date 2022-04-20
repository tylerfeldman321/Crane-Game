module debouncer(signal, clock, debounced_signal);
    input signal, clock;
    output debounced_signal;

    wire slow_clock;
    wire Q1, Q2, Q0;
    clock_div u1(clock, slow_clk);
    dff d0(slow_clk, signal, Q0);

    dff d1(slow_clk, Q0, Q1);
    dff d2(slow_clk, Q1, Q2);

    assign debounced_signal = Q1 & ~Q2;
endmodule

// Slow clock for debouncing 
module clock_div(clock100MHz, slow_clk_out);
    
    input clock100MHz;
    output slow_clk_out;

    assign slow_clk_out = slow_clk;
    reg slow_clk;

    reg [26:0] counter = 0;
    always @(posedge clock100MHz) begin
        counter <= (counter >= 249999) ? 0 : counter + 1;
        slow_clk <= (counter < 125000) ? 1'b0 : 1'b1;
    end
endmodule

// D-flip-flop for debouncing module 
module dff(input DFF_CLOCK, D, output Q_val);
    reg Q = 0;
    always @ (posedge DFF_CLOCK) begin
        Q <= D;
    end
    assign Q_val = Q;
endmodule