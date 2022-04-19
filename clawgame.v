module clawgame_proc(
    input clock, 
    input reset,
    input score_increment,
    output [7:0] anode_activate,
    output [7:0] LED_out,
    output game_active);

    // input start_button;
    // output game_active;

    // Wrapper WRAPPER(clock, reset);

    // register buttonInputReg();

    assign game_active = ~(time_left == 16'b0) && ~reset;

    wire [15:0] count, score_val;
    reg [15:0] score;

    wire score_increment_debounced;
    debouncer score_increment_debouncer(score_increment, clock, score_increment_debounced);
    
    always @(posedge score_increment_debounced or posedge reset) begin
        if (reset == 1)
            score <= 0;
        else if (game_active)
            score <= score + 1;
    end
    assign score_val = score;

    wire [15:0] time_left;
    timer TIMER(clock, reset, time_left);
    LED_display_controller LEDCONTROLLER(clock, reset, time_left, score_val, anode_activate, LED_out);

    // initial begin
    //     game_active = 0;
    // end

    // always @(posedge start_button) begin
    //     game_active <= 1;
    // end

    // always @(posedge end_button) begin
    //     game_active <= 0;
    // end


endmodule