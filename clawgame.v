module clawgame(
    input clock, 
    input reset,
    input score_increment,
    output [7:0] anode_activate,
    output [7:0] LED_out
    );

    // input start_button;
    // output game_active;

    // Wrapper WRAPPER(clock, reset);

    // register buttonInputReg();

    // reg game_active;

    wire [15:0] count, score_val;
    reg [15:0] score;

    always @(posedge score_increment or posedge reset) begin
        if (reset == 1)
            score <= 0;
        else
            score <= score + 1;
    end
    
    assign score_val = score;

    timer TIMER(clock, reset, count);
    LED_display_controller LEDCONTROLLER(clock, reset, count, score_val, anode_activate, LED_out);

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