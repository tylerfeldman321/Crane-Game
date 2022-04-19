module clawgame_proc(
    input clock, 
    input reset,
    input increment_score,
    output [7:0] anode_activate,
    output [7:0] LED_out
);

    // INPUTS:
    // Don't need left/right/up/down, since that goes to the arduino
    // Score increment from Arduino
    // Reset - set score and timer to zero, tell Arduino game inactive (maybe arduino puts motors on standby)
    // Game start - set score and timer to zero, keep game as active

    wire [15:0] time_left;
    wire [31:0] score;

    Wrapper WRAPPER(clock, reset, score, increment_score);

    assign game_active = ~(time_left == 32'b0) && ~reset;

    // wire increment_score_debounced, game_start_debounced, reset_debounced;
    // debouncer increment_score_debouncer(increment_score, clock, increment_score_debounced);
    // dffe_ref DFF(q, d, clk, en, clr);

    timer TIMER(clock, reset, time_left);
    LED_display_controller LEDCONTROLLER(clock, reset, time_left, score[15:0], anode_activate, LED_out);

    // ila_0 debuggers(.clk(clock), .probe0(score), .probe1(reset), .probe2(clock));

endmodule