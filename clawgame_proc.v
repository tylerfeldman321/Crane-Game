module clawgame_proc(
    input clock, 
    input reset,
    input increment_score,
    output [7:0] anode_activate,
    output [7:0] LED_out,
    output game_active
);

    // INPUTS:
    // Score increment from Arduino
    // Game start - set score to zero and reset the timer, keep game as active. Will come from PMOD port

    // OUTPUTS:
    // Game Active - from PMOD port, tells arduino to cancel motor movement

    // TODO: 
    // - When time runs out shouldn't be able to increment $r3
    // - For timer: Create subdivided clock, use positive_edge_detector, then decrement a register each time. In that block of code
    // - On startup, write 1 to game_active

    wire [31:0] time_left;
    wire [31:0] score;
    wire time_out;

    wire increment_score_pe, game_clock_pe;

    assign time_out = (time_left == 32'b00000000000000000000000000000000);

    Wrapper WRAPPER(clock, reset, score, increment_score_pe, time_left, game_clock_pe);

    assign game_active = ~(time_left == 32'b0) && ~reset;

    // wire increment_score_debounced;
    // debouncer increment_score_debouncer(increment_score, clock, increment_score_debounced);

    positive_edge_detector PE_score(increment_score, ~clock, 1'b0, increment_score_pe);

    // dffe_ref DFF(q, d, clk, en, clr);
    wire game_clock;
    one_second_clock GAME_TIMER(clock, reset, game_clock);
    positive_edge_detector PE_game_clock(game_clock, ~clock, 1'b0, game_clock_pe);
    
    //timer TIMER(clock, reset, time_left);
    LED_display_controller LEDCONTROLLER(clock, reset, time_left[15:0], score[15:0], anode_activate, LED_out);

    // ila_0 debuggers(.clk(clock), .probe0(score), .probe1(reset), .probe2(clock));

endmodule