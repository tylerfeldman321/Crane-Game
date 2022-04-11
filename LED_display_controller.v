module LED_display_controller(
    input clock_100Mhz,  // 100 Mhz clock source on Basys 3 FPGA
    input reset,  // reset
    output reg [7:0] Anode_Activate,  // anode signals of the 7-segment LED display
    output reg [7:0] LED_out  // cathode patterns of the 7-segment LED display
    );


    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;// one second enable for counting numbers
    reg [15:0] displayed_number; // counting number to be displayed
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [2:0] LED_activating_counter; 
                 // count     0    ->  1  ->  2  ->  3
              // activates    LED1    LED2   LED3   LED4
             // and repeat
    
    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            one_second_counter <= 0;
        else begin
            if(one_second_counter>=99999999) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 
    assign one_second_enable = (one_second_counter==99999999)?1:0;
    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            displayed_number <= 0;
        else if(one_second_enable==1)
            displayed_number <= displayed_number + 1;
    end
    always @(posedge clock_100Mhz or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:18];


    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 8'b01111111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = displayed_number/1000;
            // the first digit of the 16-bit number
            end
        2'b01: begin
            Anode_Activate = 8'b10111111; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (displayed_number % 1000)/100;
            // the second digit of the 16-bit number
            end
        2'b10: begin
            Anode_Activate = 8'b11011111; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((displayed_number % 1000)%100)/10;
            // the third digit of the 16-bit number
            end
        2'b11: begin
            Anode_Activate = 8'b11101111; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((displayed_number % 1000)%100)%10;
            // the fourth digit of the 16-bit number    
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