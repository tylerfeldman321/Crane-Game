`timescale 1 ns / 100 ps
module mux_32_tb;
    wire [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
    wire [4:0] select;

    wire[31:0] out;

    assign in0 = 0;
    assign in1 = 1;
    assign in2 = 2;
    assign in3 = 3;
    assign in4 = 4;
    assign in5 = 5;
    assign in6 = 6;
    assign in7 = 7;
    assign in8 = 8;
    assign in9 = 9;
    assign in10 = 10;
    assign in11 = 11;
    assign in12 = 12;
    assign in13 = 13;
    assign in14 = 14;
    assign in15 = 15;
    assign in16 = 16;
    assign in17 = 17;
    assign in18 = 18;
    assign in19 = 19;
    assign in20 = 20; 
    assign in21 = 21; 
    assign in22 = 22; 
    assign in23 = 23; 
    assign in24 = 24; 
    assign in25 = 25; 
    assign in26 = 26; 
    assign in27 = 27; 
    assign in28 = 28; 
    assign in29 = 29; 
    assign in30 = 30; 
    assign in31 = 31;

    mux_32 mux(out, select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31); 
    
    integer i;

    assign select = i;
    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            #20;
            if (out == i) begin
                $display("PASSED: out:%b, select:%b", out, select);
            end else begin
                $display("FAILED: out:%b, select:%b, Expected Out is out:%b", out, select);
            end
        end
        $finish;
    end

    initial begin
        $dumpfile("mux_32_wave.vcd");
        $dumpvars(0, mux_32_tb);
    end

endmodule