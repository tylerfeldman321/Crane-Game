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
    reg [31:0] scoreReg = 0;
    wire [31:0] score, score_display;
    assign score_display = scoreReg;

    Wrapper WRAPPER(clock, reset, score, need_to_increment_score_wire, finished_incrementing_score);

    assign game_active = ~(time_left == 32'b0) && ~reset;

    wire increment_score_debounced, game_start_debounced, reset_debounced;
    debouncer increment_score_debouncer(increment_score, clock, increment_score_debounced);
    dffe_ref DFF(q, d, clk, en, clr);
    // debouncer game_start_debouncer(game_start, clock, game_start_debounced);
    
    // dffe_ref (q, d, clk, en, clr);
    // wire need_to_increment_score_wire;
    // assign need_to_increment_score_wire = need_to_increment_score;
    // reg need_to_increment_score;
    // wire finished_incrementing_score;
    // always @(posedge increment_score_debounced or posedge finished_incrementing_score) begin
    //     if (increment_score_debounced == 1)
    //         need_to_increment_score <= 1;
    //     else
    //         need_to_increment_score <= 0;
    // end
    
    always @(posedge time_left) begin
        scoreReg <= score;
    end

    timer TIMER(clock, reset, time_left);
    LED_display_controller LEDCONTROLLER(clock, reset, time_left, score_display[15:0], anode_activate, LED_out);

    // ila_0 debuggers(.clk(clock), .probe0(score), .probe1(reset), .probe2(clock));

endmodule