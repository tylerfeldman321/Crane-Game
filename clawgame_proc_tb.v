`timescale 1ns / 1ps
module clawgame_proc_tb;

    wire [7:0] anode_activate, LED_out;
    reg clock = 0, reset = 0;
    reg increment_score = 0;
    wire game_active;

    clawgame_proc CLAWGAME(clock, reset, increment_score, anode_activate, LED_out, game_active);

    localparam DEFAULT_CYCLES = 255;
    reg[7:0] num_cycles = DEFAULT_CYCLES;
    integer cycles = 0;

    initial begin
        // Output file name
		$dumpfile("clawgame_proc.vcd");
		// Module to capture and what level, 0 means all wires
		$dumpvars(0, clawgame_proc_tb);

        #50 
        increment_score = 1;

        #200 
        increment_score = 0;

        #200 
        increment_score = 1;

        #20000
        $finish;
    end

    always
        #10 clock <= ~clock;

        

endmodule