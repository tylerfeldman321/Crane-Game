module timer(input clock_100Mhz,
    input reset,
    output [15:0] count
    );

    localparam START_TIME = 20;
    reg [51:0] countReg = START_TIME;
    assign count = countReg;

    reg [26:0] one_second_counter;
    wire one_second_enable;  // one second enable for counting numbers

    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            one_second_counter <= 0;
        else begin
            if(one_second_counter >= 99999999)
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end
    assign one_second_enable = (one_second_counter == 99999999) ? 1 : 0;

    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            countReg <= START_TIME;
        else if(one_second_enable == 1 && countReg != 0)
            countReg <= countReg - 1;
    end

endmodule