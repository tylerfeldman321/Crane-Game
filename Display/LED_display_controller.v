module LED_display_controller(
    input clock_100Mhz,  // 100 Mhz clock source on Basys 3 FPGA
    input reset,  // reset
    input [15:0] displayed_number1,
    input [15:0] displayed_number2,
    output reg [7:0] anode_activate,  // anode signals of the 7-segment LED display
    output reg [7:0] LED_out  // cathode patterns of the 7-segment LED display
    );
    
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 3 MSB bits for creating 8 LED-activating signals with 10.5ms refresh period, 1.3 digit period
    wire [2:0] LED_activating_counter;  // Counts from 0 to 7, activating each LED one at a time
    
    
    always @(posedge clock_100Mhz or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:17];


    // anode activating signals for 8 LEDs, digit period of 1.3ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
            3'b000: begin
                anode_activate = 8'b01111111; 
                LED_BCD = displayed_number1 / 1000;
                end
            3'b001: begin
                anode_activate = 8'b10111111; 
                LED_BCD = (displayed_number1 % 1000) / 100;
                end
            3'b010: begin
                anode_activate = 8'b11011111; 
                LED_BCD = (displayed_number1 % 100) / 10;
                end
            3'b011: begin
                anode_activate = 8'b11101111; 
                LED_BCD = (displayed_number1 % 10); 
                end
            3'b100: begin
                anode_activate = 8'b11110111; 
                LED_BCD = displayed_number2 / 1000;
                end
            3'b101: begin
                anode_activate = 8'b11111011; 
                LED_BCD = (displayed_number2 % 1000) / 100;
                end
            3'b110: begin
                anode_activate = 8'b11111101; 
                LED_BCD = (displayed_number2 % 100) / 10;
                end
            3'b111: begin
                anode_activate = 8'b11111110; 
                LED_BCD = (displayed_number2 % 10); 
                end
        endcase
    end


    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: LED_out = 8'b00000011; // "0"     
        4'b0001: LED_out = 8'b10011111; // "1" 
        4'b0010: LED_out = 8'b00100101; // "2" 
        4'b0011: LED_out = 8'b00001101; // "3" 
        4'b0100: LED_out = 8'b10011001; // "4" 
        4'b0101: LED_out = 8'b01001001; // "5" 
        4'b0110: LED_out = 8'b01000001; // "6" 
        4'b0111: LED_out = 8'b00011111; // "7" 
        4'b1000: LED_out = 8'b00000001; // "8"     
        4'b1001: LED_out = 8'b00001001; // "9" 
        default: LED_out = 8'b00000011; // "0"
        endcase
    end
 endmodule